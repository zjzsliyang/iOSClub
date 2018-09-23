package com.apple.iosclub.controller;

import com.apple.iosclub.Entity.Teacher;
import com.apple.iosclub.Utils.Common;
import com.apple.iosclub.mapper.TeacherMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;


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

        List<Teacher> list = teacherMapper.getByCode(code);

        for(Teacher teacher : list){
            teacher.avatar = "http://" + Common.ip + ":" + Common.port + teacher.avatar;
        }

        return list;
    }


}
