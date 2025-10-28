package com.example.commerce.model;
import lombok.AllArgsConstructor; import lombok.Data; import lombok.NoArgsConstructor;
import java.time.OffsetDateTime;
@Data @NoArgsConstructor @AllArgsConstructor
public class Product { private String id; private String name; private String description; private double price; private String currency; private OffsetDateTime createdAt; }
