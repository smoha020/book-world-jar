package com.bookworld.demo.repository;
import com.bookworld.demo.model.Book;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BookRepository
        extends JpaRepository<Book, Integer> {
}
