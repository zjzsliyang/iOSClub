package com.apple.iosclub.service.myinterface;

public interface BlogInterface {

    Object getAll();
    Object getByCode(int code);
    Object insertBlog(String sharemail, String url, String time, int code);

}
