package com.apple.iosclub.controller;

import com.apple.iosclub.service.myimplement.TeacherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/club/teacher")
public class TeacherController {

    private TeacherService teacherService;
    @Autowired
    public TeacherController(TeacherService teacherService){
        this.teacherService = teacherService;
    }

    @GetMapping("/getAll")
    public Object getAll(){
        return teacherService.getAll();
    }


    @GetMapping("/getByCode")
    public Object getByCode(int code){
        return teacherService.getByCode(code);
    }


}
