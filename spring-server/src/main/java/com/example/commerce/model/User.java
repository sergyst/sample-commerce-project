package com.example.commerce.model;
import lombok.AllArgsConstructor; import lombok.Data; import lombok.NoArgsConstructor;
import java.time.OffsetDateTime;
@Data @NoArgsConstructor @AllArgsConstructor
public class User { private String id; private String name; private String email; private OffsetDateTime createdAt; }
