package com.apple.iosclub.service.myimplement;

import com.apple.iosclub.mapper.BlogMapper;
import com.apple.iosclub.model.BlogModel;
import com.apple.iosclub.model.NewModel;
import com.apple.iosclub.service.myinterface.BlogInterface;
import com.apple.iosclub.utils.Common;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Service
public class BlogService implements BlogInterface {

    @Autowired
    public BlogMapper blogMapper;

    @Override
    public Object getAll() {
        return pack(blogMapper.getAll());
    }

    @Override
    public Object insertBlog(String sharemail, String url, String time) {

        HashMap<String, Object> res = new HashMap<>();

        blogMapper.insertBlog(sharemail, url, time);

        res.put("code", 0);
        res.put("msg", "分享成功");

        return res;
    }

    public static ArrayList<HashMap<String, Object>> pack(List<BlogModel> list){
        ArrayList<HashMap<String,Object>> resultList = new ArrayList<>();

        for(BlogModel blogModel : list){
            HashMap<String, Object> blogObject = new HashMap<>();
            HashMap<String, Object> userObject = new HashMap<>();
            HashMap<String, Object> universityObject = new HashMap<>();

            universityObject.put("code", blogModel.u_code);
            universityObject.put("name", blogModel.u_name);
            universityObject.put("description", blogModel.u_description);
            universityObject.put("icon", Common.backendUrl + blogModel.u_icon);
            universityObject.put("email", blogModel.u_email);

            userObject.put("university", universityObject);
            userObject.put("username", blogModel.username);
            userObject.put("user_privilege", blogModel.privilege);
            userObject.put("email", blogModel.email);
            userObject.put("password", "这个值只是逗逗你");
            userObject.put("position", blogModel.position);
            userObject.put("description", blogModel.description);
            userObject.put("avatar", Common.backendUrl + blogModel.avatar);

            blogObject.put("user", userObject);
            blogObject.put("time", blogModel.time);
            blogObject.put("url", blogModel.url);

            resultList.add(blogObject);
        }

        return resultList;
    }
    
}
