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
