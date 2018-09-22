package com.apple.iosclub.controller;

import com.apple.iosclub.Entity.University;
import com.apple.iosclub.Utils.Common;
import com.apple.iosclub.mapper.UniversityMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/club/info")
public class UniversityController {

    @Autowired
    private UniversityMapper universityMapper;

    @GetMapping("/getAll")
    public Object getAllInfo(){
        List<University> universityList =  universityMapper.getAll();
        for(University university : universityList){
            university.icon = "http://" + Common.ip + ":" + Common.port + university.icon;
        }
        return universityList;
    }
}
