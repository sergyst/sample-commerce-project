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
