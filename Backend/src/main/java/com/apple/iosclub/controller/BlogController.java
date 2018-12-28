package com.apple.iosclub.controller;

import com.apple.iosclub.entity.DBNew;
import com.apple.iosclub.service.myimplement.BlogService;
import com.apple.iosclub.utils.Common;
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

    @GetMapping("/getByCode")
    public Object getByCode(int code) {
        return blogService.getByCode(code);
    }

    @PostMapping("/shareBlog")
    public Object insertBlog(@RequestBody HashMap<String, Object> req) {

        HashMap<String, Object> res = new HashMap<>();

        try {


            int code = Integer.parseInt(req.get("code").toString());
            int user_privilege = Integer.parseInt(req.get("user_privilege").toString());

            if(user_privilege < Common.level2){
                res.put("code", 2);
                res.put("msg", "权限不足");
                return res;
            }


            String sharemail = req.get("sharemail").toString();
            String url = req.get("url").toString();
            Date d = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String time =  sdf.format(d).toString();

            return blogService.insertBlog(sharemail, url, time, code);

        }catch (Exception e){
            res.put("code", 1);
            res.put("msg", e.getMessage());
        }

        return res;

    }

}
