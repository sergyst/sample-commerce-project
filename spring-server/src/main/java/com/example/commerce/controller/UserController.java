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
