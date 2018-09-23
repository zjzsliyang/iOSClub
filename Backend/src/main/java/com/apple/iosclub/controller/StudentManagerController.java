package com.apple.iosclub.controller;

import com.apple.iosclub.service.myimplement.StudentManagerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/club/sm")
public class StudentManagerController {


    private StudentManagerService studentManagerService;

    @Autowired
    public StudentManagerController(StudentManagerService studentManagerService){
        this.studentManagerService = studentManagerService;
    }

    @GetMapping("/getAll")
    public Object getAll(){
        return studentManagerService.getAll();
    }

    @GetMapping("/getByCode")
    public Object getByCode(int code){



        return studentManagerService.getByCode(code);

    }
}
