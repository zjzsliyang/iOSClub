package com.apple.iosclub.controller;

import com.apple.iosclub.mapper.TeacherMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/club/teacher")
public class TeacherController {

    @Autowired
    private TeacherMapper teacherMapper;

    @GetMapping("/getAll")
    public Object getAll(){
        return teacherMapper.getAll();
    }


    @GetMapping("/getByCode")
    public Object getByCode(int code){
        return teacherMapper.getByCode(code);
    }


}
