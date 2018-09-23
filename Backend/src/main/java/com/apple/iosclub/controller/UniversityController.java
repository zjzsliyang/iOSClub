package com.apple.iosclub.controller;

import com.apple.iosclub.service.myimplement.UniversityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

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
