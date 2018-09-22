package com.apple.iosclub.FormatModel;

import com.apple.iosclub.Entity.University;
import com.apple.iosclub.Entity.User;

public class FormatUser {

    public University university;
    public String username;
    public int user_privilege;
    public String email;
    public String password;
    public String position;
    public String description;
    public String avatar;

    public FormatUser(User user){
        this.username = user.username;
        this.user_privilege = user.user_privilege;
        this.email = user.email;
        this.password = user.password;
        this.position = user.position;
        this.description = user.description;
        this.avatar = user.avatar;
        this.university = new University();
        this.university.code = user.u_code;
        this.university.description = user.u_description;
        this.university.email = user.u_email;
        this.university.icon = user.u_icon;
        this.university.name = user.u_name;

    }

}