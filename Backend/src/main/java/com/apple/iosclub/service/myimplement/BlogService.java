package com.apple.iosclub.service.myimplement;

import com.apple.iosclub.mapper.BlogMapper;
import com.apple.iosclub.service.myinterface.BlogInterface;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;

@Service
public class BlogService implements BlogInterface {

    @Autowired
    public BlogMapper blogMapper;

    @Override
    public Object getAll() {
        return blogMapper.getAll();
    }

    @Override
    public Object insertBlog(String sharemail, String url, String time) {

        HashMap<String, Object> res = new HashMap<>();

        blogMapper.insertBlog(sharemail, url, time);

        res.put("code", 0);
        res.put("msg", "分享成功");

        return res;
    }
}
