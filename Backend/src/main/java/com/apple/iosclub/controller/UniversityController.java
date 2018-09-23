package com.apple.iosclub.controller;

import com.apple.iosclub.Model.UniversityModel;
import com.apple.iosclub.Utils.Common;
import com.apple.iosclub.mapper.UniversityMapper;
import com.apple.iosclub.service.myimplement.UniversityService;
import com.apple.iosclub.service.myimplement.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

@RestController
@RequestMapping("/club/info")
public class UniversityController {

    private UniversityService universityService;

    @Autowired
    public UniversityController(UniversityService universityService){
        this.universityService = universityService;
    }


    @GetMapping("/getAll")
    public Object getAll(){
        return universityService.getAll();
    }



}
