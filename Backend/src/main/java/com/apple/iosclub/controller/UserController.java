package com.apple.iosclub.controller;

import com.apple.iosclub.FormatModel.FormatUser;
import com.apple.iosclub.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserMapper userMapper;

    @GetMapping("/getInfoByEmail")
    public Object getByEmail(String email){
        return new FormatUser(userMapper.getByEmail(email));
    }

}
