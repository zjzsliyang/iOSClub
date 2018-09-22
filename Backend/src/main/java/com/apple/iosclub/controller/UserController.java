package com.apple.iosclub.controller;

import com.apple.iosclub.FormatModel.User;
import com.apple.iosclub.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.net.UnknownHostException;
import java.util.HashMap;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserMapper userMapper;

    @GetMapping("/getInfoByEmail")
    public Object getByEmail(String email) throws UnknownHostException {
        return new User(userMapper.getByEmail(email));
    }

    @PostMapping("/login")
    public Object login(@RequestBody HashMap<String, Object> req){

        String email = (String) req.get("email");
        String password = (String) req.get("password");

        String real = (String)userMapper.getPassWord(email);



        HashMap<String, Object> res = new HashMap<>();

        if (real==null){
            res.put("code", -1);
            res.put("msg", "用户不存在");
            return res;
        }

        if (password.equals(real)){
            res.put("code", 0);
            res.put("msg", "登陆成功");
        }else {
            res.put("code", 1);
            res.put("msg", "密码错误");
        }
        return res;

    }

    @PostMapping("/register")
    public Object register(@RequestBody HashMap<String, Object> req){
        HashMap<String, Object> res = new HashMap<>();
        try {

            String username =  (String)req.get("username");
            int u_code = (int) req.get("u_code");
            int privilege = (int) req.get("user_privilege");
            String email = (String) req.get("email");
            String real = (String)userMapper.getPassWord(email);
            if (real!=null){
                res.put("code", -1);
                res.put("msg", "邮箱已经注册");
                return res;
            }
            String password = (String) req.get("password");
            String position =  (String) req.get("position");
            String description =  (String) req.get("description");
            String avatar =  "";
            userMapper.insertUser(username, u_code, privilege, email, password, position, description, avatar);

            res.put("code", 0);
            res.put("msg", "注册成功");

        }catch (Exception e){
            e.printStackTrace();
            res.put("code", 1);
            res.put("msg", "注册失败");
        }


        return res;


    }

}
