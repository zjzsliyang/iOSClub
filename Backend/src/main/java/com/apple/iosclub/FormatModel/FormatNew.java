//package com.apple.iosclub.FormatModel;
//
//import com.apple.iosclub.entity.MyNew;
//import com.apple.iosclub.entity.MyUser;
//import com.apple.iosclub.utils.Common;
//
//import java.net.UnknownHostException;
//import java.util.ArrayList;
//import java.util.Arrays;
//import java.util.List;
//
//public class FormatNew {
//
//
//
//    public User user;
//    public String time;
//    public String title;
//    public String content;
//    public String video;
//    public List<String> images;
//    public List<String> tags;
//    public int news_privilege;
//
//    public FormatNew(MyNew myNew) throws UnknownHostException {
//
//        this.time = myNew.time;
//        this.title = myNew.title;
//        this.content = myNew.content;
//        if(myNew.video.equals("1")){
//            this.video = "http://" + Common.ip + ":" + Common.port + "/news_videos/1.mp4";//myNew.video;
//        }else {
//            this.video = "";
//        }
//
//        if(myNew.video.equals("3")){
//            String[] temp = {};
//            this.images = Arrays.asList(temp);
//        }else {
//            String[] temp = {"http://" + Common.ip + ":" + Common.port  +"/news_images/1.png","http://" + Common.ip + ":" + Common.port + "/news_images/2.png","http://" + Common.ip + ":" + Common.port + "/news_images/3.png"};
//            this.images = Arrays.asList(temp);
//        }
//
////        this.tags = myNew.tags;
//        this.tags = new ArrayList<>();
//        this.news_privilege = myNew.news_privilege;
//
//
//        MyUser myUser = new MyUser();
//        myUser.u_code = myNew.u_code;
//        myUser.username = myNew.username;
//        myUser.user_privilege = myNew.news_privilege;
//        myUser.email = myNew.email;
//        myUser.password = myNew.password;
//        myUser.position = myNew.position;
//        myUser.description = myNew.description;
//        myUser.avatar = myNew.avatar;
//        myUser.u_name = myNew.u_name;
//        myUser.u_description = myNew.u_description;
//        myUser.u_icon = "http://" + Common.ip + ":" + Common.port + myNew.u_icon;
//        myUser.u_email = myNew.u_email;
//        this.user = new User(myUser);
//
//    }
//
//
//}
