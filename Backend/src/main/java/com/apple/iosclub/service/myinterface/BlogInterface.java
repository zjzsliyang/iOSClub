package com.apple.iosclub.service.myinterface;

public interface BlogInterface {

    Object getAll();
    Object insertBlog(String sharemail, String url, String time);

}
