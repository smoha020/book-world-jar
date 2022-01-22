package com.bookworld.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class BookWorldController {

    @RequestMapping("/")
    public String Hello() {
        return "this is Book World!";
    }
}
