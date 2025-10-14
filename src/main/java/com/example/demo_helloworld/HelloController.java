package com.example.demo_helloworld;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/")
    public String hello() {
    return " Hello World! TP2 DevOps: Spring Boot + Maven + Docker = CI/CD in action!";
    }
}
