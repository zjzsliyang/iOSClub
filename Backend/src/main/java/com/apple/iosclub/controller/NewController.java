package com.apple.iosclub.controller;

import com.apple.iosclub.entity.DBNew;
import com.apple.iosclub.mapper.NewMapper;
import com.apple.iosclub.service.myimplement.NewService;
import com.apple.iosclub.utils.Common;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Required;
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

    @GetMapping("/getNews")
    public Object getNews(@RequestParam(required = false)Integer u_privilege, @RequestParam(required = false) Integer code){

        try {
            if (u_privilege == null){
                u_privilege = Common.level0;
                code = -1;
            }
            switch (u_privilege){
                case Common.level0: return newService.getNewsByPrivilege(u_privilege); // visitor get
                case Common.level3: return newService.getAllNews();  // teacher/president get
                default: return newService.getByPrivilegeAndCode(u_privilege, code); // admin get
            }
        }catch (Exception e){
            return null;
        }

    }

    @PostMapping("/publish")
    @Required
    public Object publish(@RequestParam HashMap<String, Object> req, @RequestPart(value = "files", required = false) MultipartFile[] uploadingFiles) throws IOException {

        HashMap<String, Object> res = new HashMap<>();

        try {
            int user_privilege =  Integer.parseInt(req.get("user_privilege").toString());
            int news_privilege =  Integer.parseInt(req.get("news_privilege").toString());
            if(user_privilege < news_privilege){
                res.put("new", null);
                res.put("code", 2);
                res.put("msg", "权限不足");
                return res;
            }
        }catch (Exception e){
            res.put("new", null);
            res.put("code", 2);
            res.put("msg", "发布失败");
            return res;
        }
        try {
            DBNew dbNew =  (DBNew)newService.publish(req, uploadingFiles);
            res.put("new", dbNew);
            res.put("code", 0);
            res.put("msg", "发布成功");
        }catch (Exception e){
            res.put("new", null);
            res.put("code", 1);
            res.put("msg", e.getMessage());
            System.out.println(e.getMessage());
        }

        return res;
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


    @PostMapping("/delete")
    public Object delete(@RequestBody HashMap<String, Object> req) {
        HashMap<String, Object> res = new HashMap<>();
        try {
            int id = Integer.parseInt(req.get("id").toString());
            int news_privilege = Integer.parseInt(req.get("news_privilege").toString());
            int user_privilege = Integer.parseInt(req.get("user_privilege").toString());

            if(user_privilege >= news_privilege){
                return newService.deleteById(id);
            }else{
                res.put("code", 2);
                res.put("msg", "权限不足");
            }
        }catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e);
        }
        return res;
    }


    @PostMapping("/deleteById")
    public Object deleteById(@RequestBody HashMap<String, Object> req) {
        int id = Integer.parseInt(req.get("id").toString());
        return newService.deleteById(id);
    }

}
