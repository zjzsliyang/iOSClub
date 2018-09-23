package com.apple.iosclub.controller;

import com.apple.iosclub.FormatModel.User;
import com.apple.iosclub.Model.UserModel;
import com.apple.iosclub.mapper.UserMapper;
import com.apple.iosclub.service.myimplement.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.net.UnknownHostException;
import java.util.HashMap;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserMapper userMapper;

    private UserService userService;
    @Autowired
    public UserController(UserService userService){
        this.userService = userService;
    }


//    @GetMapping("/getInfoByEmail")
//    public Object getInfoByEmail(String email) throws UnknownHostException {
//        return new User(userMapper.getByEmail(email));
//    }


    @GetMapping("/getInfoByEmail")
    public Object getInfoByEmail(String email){

        return userService.getInfoByEmail(email);

    }


    @PostMapping("/login")
    public Object login(@RequestBody HashMap<String, Object> req){

        String email = (String) req.get("email");
        String password = (String) req.get("password");

        return userService.login(email, password);

    }

    @PostMapping("/register")
    public Object register(@RequestBody HashMap<String, Object> req){

        return userService.register(req);

    }

}
