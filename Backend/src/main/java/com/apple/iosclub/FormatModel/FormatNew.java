package com.apple.iosclub.FormatModel;

import com.apple.iosclub.Entity.MyNew;
import com.apple.iosclub.Entity.User;

public class FormatNew {



    public FormatUser formatUser;
    public String time;
    public String title;
    public String content;
    public String video;
    public String images;
    public String tags;
    public int news_privilege;

    public FormatNew(MyNew myNew){

        this.time = myNew.time;
        this.title = myNew.title;
        this.content = myNew.content;
        this.video = myNew.video;
        this.images = myNew.images;
        this.tags = myNew.tags;
        this.news_privilege = myNew.news_privilege;


        User user = new User();
        user.u_code = myNew.u_code;
        user.username = myNew.username;
        user.user_privilege = myNew.news_privilege;
        user.email = myNew.email;
        user.password = myNew.password;
        user.position = myNew.position;
        user.description = myNew.description;
        user.avatar = myNew.avatar;
        user.u_name = myNew.u_name;
        user.u_description = myNew.u_description;
        user.u_icon = myNew.u_icon;
        user.u_email = myNew.u_email;
        this.formatUser = new FormatUser(user);

    }


}
