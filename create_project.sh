#!/bin/bash
set -e

# ---------- CONFIG ----------
GITHUB_USERNAME="sergyst"
REPO_NAME="sample-commerce-project"
PROJECT_DIR="$HOME/$REPO_NAME"

# ---------- CREATE REPO ----------
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"
git init
git branch -M main
git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git

# ---------- README ----------
cat <<EOF > README.md
# Sample Commerce Project

Spring Boot backend + Angular frontend
- Backend: /spring-server
- Frontend: /angular-client

Run backend: mvn spring-boot:run
Run frontend: npm install && ng serve --proxy-config proxy.conf.json
EOF

# ---------- SPRING SERVER ----------
mkdir spring-server
cd spring-server
curl https://start.spring.io/starter.zip \
  -d dependencies=web,lombok,validation \
  -d name=sample-commerce-server \
  -d packageName=com.example.commerce \
  -d javaVersion=17 \
  -o starter.zip
unzip starter.zip
rm starter.zip

echo "server.port=8080
spring.jackson.serialization.write-dates-as-timestamps=false" > src/main/resources/application.properties

# ---------- MODELS, SERVICES, CONTROLLERS ----------
mkdir -p src/main/java/com/example/commerce/{model,service,controller}

# --- Models ---
cat <<'EOM' > src/main/java/com/example/commerce/model/User.java
package com.example.commerce.model;
import lombok.*;
import java.time.OffsetDateTime;
@Data @NoArgsConstructor @AllArgsConstructor
public class User { private String id; private String name; private String email; private OffsetDateTime createdAt; }
EOM

cat <<'EOM' > src/main/java/com/example/commerce/model/Product.java
package com.example.commerce.model;
import lombok.*;
import java.time.OffsetDateTime;
@Data @NoArgsConstructor @AllArgsConstructor
public class Product { private String id; private String name; private String description; private double price; private String currency; private OffsetDateTime createdAt; }
EOM

cat <<'EOM' > src/main/java/com/example/commerce/model/OrderItem.java
package com.example.commerce.model;
import lombok.*;
@Data @NoArgsConstructor @AllArgsConstructor
public class OrderItem { private String productId; private int quantity; private double price; }
EOM

cat <<'EOM' > src/main/java/com/example/commerce/model/Order.java
package com.example.commerce.model;
import lombok.*; import java.time.OffsetDateTime; import java.util.List;
@Data @NoArgsConstructor @AllArgsConstructor
public class Order { private String id; private String userId; private double totalAmount; private String currency; private String status; private OffsetDateTime createdAt; private List<OrderItem> items; }
EOM

cat <<'EOM' > src/main/java/com/example/commerce/model/ErrorResponse.java
package com.example.commerce.model;
import lombok.*; import java.time.OffsetDateTime;
@Data @NoArgsConstructor @AllArgsConstructor
public class ErrorResponse { private int code; private String message; private String path; private OffsetDateTime timestamp; }
EOM

# --- Services ---
mkdir -p src/main/java/com/example/commerce/service

# UserService
cat <<'EOM' > src/main/java/com/example/commerce/service/UserService.java
package com.example.commerce.service;
import com.example.commerce.model.User; import org.springframework.stereotype.Service;
import java.time.OffsetDateTime; import java.util.*; import java.util.concurrent.ConcurrentHashMap;
@Service
public class UserService {
    private final Map<String, User> users = new ConcurrentHashMap<>();
    public List<User> findAll() { return new ArrayList<>(users.values()); }
    public Optional<User> findById(String id) { return Optional.ofNullable(users.get(id)); }
    public User create(User user) { String id = UUID.randomUUID().toString(); user.setId(id); user.setCreatedAt(OffsetDateTime.now()); users.put(id,user); return user; }
    public void clear() { users.clear(); }
}
EOM

# ProductService
cat <<'EOM' > src/main/java/com/example/commerce/service/ProductService.java
package com.example.commerce.service;
import com.example.commerce.model.Product; import org.springframework.stereotype.Service;
import java.time.OffsetDateTime; import java.util.*; import java.util.concurrent.ConcurrentHashMap;
@Service
public class ProductService {
    private final Map<String, Product> products = new ConcurrentHashMap<>();
    public List<Product> findAll() { return new ArrayList<>(products.values()); }
    public Optional<Product> findById(String id) { return Optional.ofNullable(products.get(id)); }
    public Product create(Product p) { String id = UUID.randomUUID().toString(); p.setId(id); p.setCreatedAt(OffsetDateTime.now()); products.put(id,p); return p; }
    public void clear() { products.clear(); }
}
EOM

# OrderService
cat <<'EOM' > src/main/java/com/example/commerce/service/OrderService.java
package com.example.commerce.service;
import com.example.commerce.model.Order; import org.springframework.stereotype.Service;
import java.time.OffsetDateTime; import java.util.*; import java.util.concurrent.ConcurrentHashMap;
@Service
public class OrderService {
    private final Map<String, Order> orders = new ConcurrentHashMap<>();
    public List<Order> findAll() { return new ArrayList<>(orders.values()); }
    public Optional<Order> findById(String id) { return Optional.ofNullable(orders.get(id)); }
    public Order create(Order o) { String id = UUID.randomUUID().toString(); o.setId(id); o.setCreatedAt(OffsetDateTime.now()); orders.put(id,o); return o; }
    public void clear() { orders.clear(); }
}
EOM

# --- Controllers ---
mkdir -p src/main/java/com/example/commerce/controller

# UserController
cat <<'EOM' > src/main/java/com/example/commerce/controller/UserController.java
package com.example.commerce.controller;
import com.example.commerce.model.*; import com.example.commerce.service.UserService;
import org.springframework.http.*; import org.springframework.web.bind.annotation.*; import jakarta.servlet.http.HttpServletRequest;
import java.time.OffsetDateTime; import java.util.List;
@RestController @RequestMapping("/v1/users")
public class UserController {
    private final UserService userService; public UserController(UserService userService) { this.userService = userService; }
    @GetMapping public List<User> getAll() { return userService.findAll(); }
    @PostMapping public ResponseEntity<?> create(@RequestBody User u, HttpServletRequest req) {
        if(u.getName()==null||u.getEmail()==null) return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new ErrorResponse(400,"Name/Email required",req.getRequestURI(),OffsetDateTime.now()));
        return ResponseEntity.status(HttpStatus.CREATED).body(userService.create(u));
    }
    @GetMapping("/{id}") public ResponseEntity<?> getById(@PathVariable String id,HttpServletRequest req){
        return userService.findById(id).<ResponseEntity<?>>map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).body(new ErrorResponse(404,"User not found",req.getRequestURI(),OffsetDateTime.now())));
    }
}
EOM

# ProductController
cat <<'EOM' > src/main/java/com/example/commerce/controller/ProductController.java
package com.example.commerce.controller;
import com.example.commerce.model.*; import com.example.commerce.service.ProductService;
import org.springframework.http.*; import org.springframework.web.bind.annotation.*; import jakarta.servlet.http.HttpServletRequest;
import java.time.OffsetDateTime; import java.util.List;
@RestController @RequestMapping("/v1/products")
public class ProductController {
    private final ProductService productService; public ProductController(ProductService ps){this.productService=ps;}
    @GetMapping public List<Product> getAll(){return productService.findAll();}
    @PostMapping public ResponseEntity<?> create(@RequestBody Product p,HttpServletRequest req){
        if(p.getName()==null||p.getPrice()<=0) return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new ErrorResponse(400,"Name/Price required",req.getRequestURI(),OffsetDateTime.now()));
        return ResponseEntity.status(HttpStatus.CREATED).body(productService.create(p));
    }
}
EOM

# OrderController
cat <<'EOM' > src/main/java/com/example/commerce/controller/OrderController.java
package com.example.commerce.controller;
import com.example.commerce.model.*; import com.example.commerce.service.OrderService;
import org.springframework.http.*; import org.springframework.web.bind.annotation.*; import jakarta.servlet.http.HttpServletRequest;
import java.time.OffsetDateTime; import java.util.List;
@RestController @RequestMapping("/v1/orders")
public class OrderController {
    private final OrderService orderService; public OrderController(OrderService os){this.orderService=os;}
    @GetMapping public List<Order> getAll(){return orderService.findAll();}
    @PostMapping public ResponseEntity<?> create(@RequestBody Order o,HttpServletRequest req){
        if(o.getUserId()==null||o.getItems()==null||o.getItems().isEmpty()) return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new ErrorResponse(400,"userId/items required",req.getRequestURI(),OffsetDateTime.now()));
        return ResponseEntity.status(HttpStatus.CREATED).body(orderService.create(o));
    }
}
EOM

# ---------- Integration Tests ----------
mkdir -p src/test/java/com/example/commerce
cat <<'EOM' > src/test/java/com/example/commerce/UserControllerIntegrationTest.java
package com.example.commerce;
import com.example.commerce.model.User; import org.junit.jupiter.api.Test; import org.springframework.beans.factory.annotation.Autowired; import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc; import org.springframework.boot.test.context.SpringBootTest; import org.springframework.http.MediaType; import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*; import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
@SpringBootTest @AutoConfigureMockMvc
public class UserControllerIntegrationTest {
    @Autowired MockMvc mockMvc;
    @Test void testCreateAndGetUser() throws Exception {
        String json="{\"name\":\"Alice\",\"email\":\"alice@example.com\"}";
        mockMvc.perform(post("/v1/users").contentType(MediaType.APPLICATION_JSON).content(json)).andExpect(status().isCreated());
        mockMvc.perform(get("/v1/users")).andExpect(status().isOk());
    }
}
EOM

# ---------- ANGULAR CLIENT ----------
npm install -g @angular/cli
ng new angular-client --routing=true --style=css --skip-git
cd angular-client

# Proxy config
cat <<EOF > proxy.conf.json
{
  "/v1/*": { "target": "http://localhost:8080", "secure": false, "changeOrigin": true }
}
EOF

# Angular services & components
ng g service services/user
ng g service services/product
ng g service services/order
ng g component components/users
ng g component components/products
ng g component components/orders

# ---------- FINAL GIT COMMIT ----------
cd "$PROJECT_DIR"
git add .
git commit -m "Full Spring Boot + Angular project with integration tests and components"
echo "Project ready! Now push to GitHub:"
echo "git push -u origin main"
