package com.apple.iosclub.controller;

import com.apple.iosclub.mapper.StudentManagerMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/club/sm")
public class StudentManagerController {


    @Autowired
    private StudentManagerMapper studentManagerMapper;

    @GetMapping("/getAll")
    public Object getAll(){
        return studentManagerMapper.getAll();
    }

    @GetMapping("/getByCode")
    public Object getByCode(int code){
        return studentManagerMapper.getByCode(code);
    }
}
