package com.apple.iosclub.controller;

import com.apple.iosclub.Entity.StudentManager;
import com.apple.iosclub.Entity.Teacher;
import com.apple.iosclub.Utils.Common;
import com.apple.iosclub.mapper.StudentManagerMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

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

        List<StudentManager> list = studentManagerMapper.getByCode(code);

        for(StudentManager studentManager : list){
            studentManager.avatar = "http://" + Common.ip + ":" + Common.port + studentManager.avatar;
        }

        return list;

    }
}
