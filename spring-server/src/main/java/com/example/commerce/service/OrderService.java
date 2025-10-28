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
