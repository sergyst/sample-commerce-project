package com.example.commerce.model;
import lombok.AllArgsConstructor; import lombok.Data; import lombok.NoArgsConstructor;
import java.time.OffsetDateTime; import java.util.List;
@Data @NoArgsConstructor @AllArgsConstructor
public class Order { private String id; private String userId; private double totalAmount; private String currency; private String status; private OffsetDateTime createdAt; private List<OrderItem> items; }
