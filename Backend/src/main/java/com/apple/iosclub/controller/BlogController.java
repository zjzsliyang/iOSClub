package com.apple.iosclub.controller;

import com.apple.iosclub.service.myimplement.BlogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

@RestController
@RequestMapping("/blog")
public class BlogController {

    private BlogService blogService;

    @Autowired
    public BlogController(BlogService blogService){
        this.blogService = blogService;
    }

    @GetMapping("/getAll")
    public Object getAll() {
        return blogService.getAll();
    }

    @PostMapping("/shareBlog")
    public Object insertBlog(@RequestBody HashMap<String, Object> req) {

        String sharemail = req.get("sharemail").toString();
        String url = req.get("url").toString();
        Date d = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String time =  sdf.format(d).toString();

        return blogService.insertBlog(sharemail, url, time);
    }

}
