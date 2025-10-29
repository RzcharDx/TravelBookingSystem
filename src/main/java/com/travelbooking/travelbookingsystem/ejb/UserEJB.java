package com.travelbooking.travelbookingsystem.ejb;

import com.travelbooking.travelbookingsystem.model.User;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;

@Stateless
public class UserEJB {

    @PersistenceContext(unitName = "travelDB")
    private EntityManager em;

    // 注册新用户
    public void registerUser(String username, String password) {
        User user = new User();
        user.setUsername(username);
        // !! 安全提示：在真实项目中，密码必须哈希处理 !!
        // 例如: user.setPassword(PasswordHashingUtil.hash(password));
        user.setPassword(password);
        user.setRole("USER"); // 默认角色
        em.persist(user);
    }

    // 验证用户登录
    public User loginUser(String username, String password) {
        TypedQuery<User> query = em.createQuery(
                "SELECT u FROM User u WHERE u.username = :username AND u.password = :password", User.class);
        query.setParameter("username", username);
        query.setParameter("password", password); // 同样，这里应该比较哈希值

        try {
            return query.getSingleResult();
        } catch (Exception e) {
            return null; // 用户名或密码错误
        }
    }
}