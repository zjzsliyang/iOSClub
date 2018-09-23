package com.apple.iosclub.controller;

import com.apple.iosclub.Model.StudentManagerModel;
import com.apple.iosclub.Utils.Common;
import com.apple.iosclub.mapper.StudentManagerMapper;
import com.apple.iosclub.service.myimplement.StudentManagerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/club/sm")
public class StudentManagerController {


//    @Autowired
//    private StudentManagerMapper studentManagerMapper;

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

//        List<StudentManagerModel> list = studentManagerMapper.getByCode(code);
//
//        for(StudentManagerModel studentManagerModel : list){
//            studentManagerModel.avatar = "http://" + Common.ip + ":" + Common.port + studentManagerModel.avatar;
//        }

        return studentManagerService.getByCode(code);

    }
}
