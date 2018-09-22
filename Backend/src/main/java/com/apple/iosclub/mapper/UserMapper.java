package com.apple.iosclub.mapper;

import com.apple.iosclub.Entity.MyUser;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface UserMapper {


    @Select("select * from user natural join university where email=#{email}")
    MyUser getByEmail(String email);

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



}
