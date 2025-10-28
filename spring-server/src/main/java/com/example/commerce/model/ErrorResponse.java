package com.example.commerce.model;
import lombok.AllArgsConstructor; import lombok.Data; import lombok.NoArgsConstructor;
import java.time.OffsetDateTime;
@Data @NoArgsConstructor @AllArgsConstructor
public class ErrorResponse { private int code; private String message; private String path; private OffsetDateTime timestamp; }
