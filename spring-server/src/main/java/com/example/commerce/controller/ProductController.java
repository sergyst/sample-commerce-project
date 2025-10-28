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
