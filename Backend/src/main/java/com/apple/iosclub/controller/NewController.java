package com.apple.iosclub.controller;

import com.apple.iosclub.entity.DBNew;

import com.apple.iosclub.mapper.NewMapper;
import com.apple.iosclub.service.myimplement.NewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
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

//    @GetMapping("/getAll")
//    public Object getAll() throws UnknownHostException {
//
//        ArrayList<FormatNew> list = new ArrayList<>();
//
//        for(MyNew myNew : newMapper.getAll()){
//            list.add(new FormatNew(myNew));
//        }
//
//        return list;
//    }
    @GetMapping("/getAll")
    public Object getAll() {
        return newService.getAllNews();
    }


//    @GetMapping("/getByPrivilege")
//    public Object getByPrivilege(int u_privilege) throws UnknownHostException {
//        ArrayList<FormatNew> list = new ArrayList<>();
//
//        for(MyNew myNew : newMapper.getByPrivilege(u_privilege)){
//            list.add(new FormatNew(myNew));
//        }
//
//        return list;
//    }
    @GetMapping("/getByPrivilege")
    public Object getByPrivilege(int u_privilege){

        return newService.getNewsByPrivilege(u_privilege);
    }



    @PostMapping("/publish")
    public Object publish(@RequestBody HashMap<String, Object> req){

        DBNew dbNew = new DBNew();

        try {
            dbNew.postemail = (String) ((HashMap<String, Object>)req.get("user")).get("email");
        }catch (Exception e){
            dbNew.postemail = (String)req.get("email");
        }


        dbNew.time =  (String)req.get("time");
        dbNew.title =  (String)req.get("title");
        dbNew.content = (String)req.get("content");
        dbNew.video = (String)req.get("video");
        dbNew.images = (String)req.get("images");
        dbNew.tags = (String)req.get("tags");
        dbNew.news_privilege = (int)req.get("news_privilege");

        newMapper.insertNew(dbNew);

        return dbNew;

    }


    public static final String uploadingdir = System.getProperty("user.dir") + "/src/main/resources/static/news_images/";
    @RequestMapping(value = "/upload", method = RequestMethod.POST)
    public Object uploadingPost(@RequestPart("file") MultipartFile[] uploadingFiles, @RequestPart HashMap<String,Object> req) throws IOException {


        for(MultipartFile uploadedFile : uploadingFiles) {
            File file = new File(uploadingdir + uploadedFile.getOriginalFilename());
            uploadedFile.transferTo(file);
            System.out.println("hahah");
        }

        System.out.println("垃圾");

        return req;
    }


}
