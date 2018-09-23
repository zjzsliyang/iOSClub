//package com.apple.iosclub.FormatModel;
//
//import com.apple.iosclub.Model.UniversityModel;
//
//import com.apple.iosclub.Utils.Common;
//import org.springframework.beans.factory.annotation.Value;
//
//import java.net.InetAddress;
//import java.net.UnknownHostException;
//
//public class User {
//
//    String ip = InetAddress.getLocalHost().getHostAddress();
//
//    public UniversityModel university;
//    public String username;
//    public int user_privilege;
//    public String email;
//    public String password;
//    public String position;
//    public String description;
//    public String avatar;
//
//    public User(MyUser myUser) throws UnknownHostException {
//        this.username = myUser.username;
//        this.user_privilege = myUser.user_privilege;
//        this.email = myUser.email;
//        this.password = myUser.password;
//        this.position = myUser.position;
//        this.description = myUser.description;
//        this.avatar = "http://" + Common.ip + ":" + Common.port + myUser.avatar;
//        this.university = new UniversityModel();
//        this.university.code = myUser.u_code;
//        this.university.description = myUser.u_description;
//        this.university.email = myUser.u_email;
//        this.university.icon = myUser.u_icon;
//        this.university.name = myUser.u_name;
//
//    }
//
//}