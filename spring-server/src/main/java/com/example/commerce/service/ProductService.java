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
