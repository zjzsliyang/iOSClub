package com.apple.iosclub.controller;

import com.apple.iosclub.mapper.ClubInfoMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/club/info")
public class ClubInfoController {

    @Autowired
    private ClubInfoMapper clubInfoMapper;

    @GetMapping("/getAll")
    public Object getAllInfo(){
        return clubInfoMapper.getAll();
    }

}
