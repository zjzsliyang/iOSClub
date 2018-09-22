package com.apple.iosclub.controller;

import com.apple.iosclub.Entity.DBNew;
import com.apple.iosclub.Entity.MyNew;
import com.apple.iosclub.FormatModel.FormatNew;
import com.apple.iosclub.mapper.NewMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;

@RestController
@RequestMapping("/news")
public class NewsController {

    @Autowired
    public NewMapper newMapper;

    @GetMapping("/getAll")
    public Object getAll(){

        ArrayList<FormatNew> list = new ArrayList<>();

        for(MyNew myNew : newMapper.getAll()){
            list.add(new FormatNew(myNew));
        }

        return list;
    }
    @GetMapping("/getByPrivilege")
    public Object getByPrivilege(int u_privilege){
        ArrayList<FormatNew> list = new ArrayList<>();

        for(MyNew myNew : newMapper.getByPrivilege(u_privilege)){
            list.add(new FormatNew(myNew));
        }

        return list;
    }

    @PostMapping("/publish")
    public Object getByPrivilege(@RequestBody HashMap<String, Object> req){

        DBNew dbNew = new DBNew();

        try {
            dbNew.postemail = (String) ((HashMap<String, Object>)req.get("formatUser")).get("email");
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


}
