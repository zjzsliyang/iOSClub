package com.apple.iosclub.controller;

import com.apple.iosclub.entity.DBNew;
import com.apple.iosclub.mapper.NewMapper;
import com.apple.iosclub.service.myimplement.NewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.*;
import java.util.Date;
import java.util.HashMap;

@RestController
@RequestMapping("/news")
public class NewController {

    @Autowired
    public NewMapper newMapper;

    private NewService newService;

    @Autowired
    public NewController(NewService newService){
        this.newService = newService;
    }

    @GetMapping("/getAll")
    public Object getAll() {
        return newService.getAllNews();
    }

    @GetMapping("/getByPrivilege")
    public Object getByPrivilege(int u_privilege){

        return newService.getNewsByPrivilege(u_privilege);
    }

    @PostMapping("/publish")
    public Object publish(@RequestParam HashMap<String, Object> req, @RequestPart("files") MultipartFile[] uploadingFiles) throws IOException {

        return newService.publish(req, uploadingFiles);

    }


    public static final String uploadingdir = System.getProperty("user.dir") + "/src/main/resources/static/news_images/";
    @RequestMapping(value = "/upload", method = RequestMethod.POST)
    public Object uploadingPost(@RequestPart("files") MultipartFile[] uploadingFiles, @RequestParam HashMap<String,Object> req) throws IOException {

        for (MultipartFile uploadedFile : uploadingFiles) {
            File file = new File(uploadingdir + uploadedFile.getOriginalFilename());
            uploadedFile.transferTo(file);
        }
        return req;
    }




}
