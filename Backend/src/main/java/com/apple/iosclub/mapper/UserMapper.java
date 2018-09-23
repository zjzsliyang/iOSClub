package com.apple.iosclub.mapper;

import com.apple.iosclub.model.UserModel;
import org.apache.ibatis.annotations.*;

@Mapper
public interface UserMapper {


//    @Select("select * from user natural join university where email=#{email}")
//    MyUser getByEmail(String email);

    @Select("select password from user where email=#{email}")
    String getPassWord(String email);

    @Insert({"insert into user(username, u_code, privilege, email, password, position, description, avatar) values(#{username},#{u_code},#{privilege}, #{email}, #{password}, #{position}, #{description}, #{avatar})"})
    void insertUser(@Param("username") String username,
                    @Param("u_code") int u_code,
                    @Param("privilege") int privilege,
                    @Param("email") String email,
                    @Param("password") String password,
                    @Param("position") String position,
                    @Param("description") String description,
                    @Param("avatar") String avatar);


    @Select("select * from user natural join university where email=#{email}")
    UserModel getInfoByEmail(String email);

    @Update("update user set avatar=#{avatar} where email=#{email}")
    void avatarUpdate(@Param("avatar") String avatar, @Param("email") String email);


}
