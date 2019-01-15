package com.apple.iosclub.service.myimplement;
import com.apple.iosclub.model.UserModel;
import com.apple.iosclub.utils.Common;
import com.apple.iosclub.mapper.UserMapper;
import com.apple.iosclub.service.myinterface.UserServiceInterface;
import org.apache.commons.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import sun.misc.BASE64Decoder;


import java.io.File;
import java.io.IOException;
import java.util.HashMap;

@Service
public class UserService implements UserServiceInterface {

    @Autowired
    public UserMapper userMapper;


    @Override
    public Object getInfoByEmail(String email) {

        UserModel userModel = userMapper.getInfoByEmail(email);

        return pack(userModel);
    }

    @Override
    public HashMap<String, Object> login(String email, String password) {


        String real = userMapper.getPassWord(email);

        HashMap<String, Object> res = new HashMap<>();

        if (real==null){
            res.put("code", -1);
            res.put("msg", "用户不存在");
            return res;
        }

        if (password.equals(real)){
            res.put("code", 0);
            res.put("msg", "登陆成功");
            res.put("user", getInfoByEmail(email));
        }else {
            res.put("code", 1);
            res.put("msg", "密码错误");
        }
        return res;

    }

    @Override
    public HashMap<String, Object> register(HashMap<String, Object> req) {
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

            // 暂时不用，这里方便扩展
            String position =  "";
            String description =  "";
//            String position =  (String) req.get("position");
//            String description =  (String) req.get("description");

            String avatar =  "/avatar/avatar.png";
            userMapper.insertUser(username, u_code, privilege, email, password, position, description, avatar);
            res.put("user", getInfoByEmail(email));
            res.put("code", 0);
            res.put("msg", "注册成功");

            res.put("user", getInfoByEmail(email));

        }catch (Exception e){
            e.printStackTrace();
            res.put("code", 1);
            res.put("msg", "注册失败");
        }


        return res;
    }

    @Override
    public Object avatarUpdate(MultipartFile image, String email) throws IOException {

        HashMap<String, Object> res = new HashMap<>();
        try {

            String directory = Common.root + "avatar/";

//            System.out.println(directory);

            String fileName = image.getOriginalFilename();
            String suffix = fileName.substring(fileName.lastIndexOf(".") + 1);

            String newName = email.replace(".", "-") + "." + suffix;

            File file = new File(directory + newName);

            image.transferTo(file);

            // 更新数据库
            userMapper.avatarUpdate(Common.virtual + "avatar/" + newName, email);

            res.put("code", 0);
            res.put("msg","修改成功");
        }catch (ExceptionInInitializerError e){
            res.put("code", 1);
            res.put("msg","修改失败");
        }
        
        return res;
    }

    @Override
    public Object changePassword(HashMap<String, Object> req) {
        HashMap<String, Object> res = new HashMap<>();

        try {
            String email = (String) req.get("email");

//            String oldBase = (String) req.get("oldPassword");
//            byte[] oldByte = Base64.decodeBase64(oldBase);
//            String oldPassword = new String(oldByte);
            String oldPassword = (String) req.get("oldPassword");

//            String newBase = (String) req.get("newPassword");
//            byte[] newByte = Base64.decodeBase64(newBase);
//            String newPassword = new String(newByte);
            String newPassword = (String) req.get("newPassword");

            String old = userMapper.getPassWord (email);
            if(!oldPassword.equals(old)){
                res.put("code", 2);
                res.put("msg","原密码错误");
            }else {
                userMapper.changePassword(email, newPassword);
                res.put("code", 0);
                res.put("msg","修改成功");
            }
        }catch (Exception e){
            res.put("code", 1);
            res.put("msg","修改失败");
        }
        return res;
    }


    public static HashMap<String, Object> pack(UserModel userModel){

        HashMap<String, Object> userObject = new HashMap<>();
        HashMap<String, Object> universityObject = new HashMap<>();

        universityObject.put("code", userModel.u_code);
        universityObject.put("name", userModel.u_name);
        universityObject.put("description", userModel.u_description);
        universityObject.put("icon", Common.backendUrl + userModel.u_icon);
        universityObject.put("email", userModel.u_email);

        userObject.put("university", universityObject);
        userObject.put("username", userModel.username);
        userObject.put("user_privilege", userModel.user_privilege);
        userObject.put("email", userModel.email);
        userObject.put("password", "这个值只是逗逗你");
        userObject.put("position", userModel.position);
        userObject.put("description", userModel.description);
        userObject.put("avatar", Common.backendUrl + userModel.avatar);

        return userObject;

    }

}
