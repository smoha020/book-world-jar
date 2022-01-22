package com.bookworld.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages={"com.bookworld"})
public class BookworldApplication {

	public static void main(String[] args) {
		SpringApplication.run(BookworldApplication.class, args);
	}

}
