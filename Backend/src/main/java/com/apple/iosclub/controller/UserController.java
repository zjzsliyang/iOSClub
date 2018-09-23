package com.apple.iosclub.controller;


import com.apple.iosclub.mapper.UserMapper;
import com.apple.iosclub.service.myimplement.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;

@RestController
@RequestMapping("/user")
public class UserController {


    private UserService userService;
    @Autowired
    public UserController(UserService userService){
        this.userService = userService;
    }


    @GetMapping("/getInfoByEmail")
    public Object getInfoByEmail(String email){

        return userService.getInfoByEmail(email);

    }


    @PostMapping("/login")
    public Object login(@RequestBody HashMap<String, Object> req) throws InterruptedException {

        String email = (String) req.get("email");
        String password = (String) req.get("password");

        return userService.login(email, password);

    }

    @PostMapping("/register")
    public Object register(@RequestBody HashMap<String, Object> req){

        return userService.register(req);

    }


    @RequestMapping(value = "/upload", method = RequestMethod.POST)
    public Object avatarUpdate(@RequestPart("file") MultipartFile image, @RequestParam HashMap<String, Object> req) throws IOException {


        return userService.avatarUpdate(image, (String) req.get("email"));

    }

}
