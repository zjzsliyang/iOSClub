package com.apple.iosclub.mapper;

import com.apple.iosclub.Entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.beans.factory.annotation.Autowired;

@Mapper
public interface UserMapper {


    @Select("select * from user natural join university where email=#{email}")
    User getByEmail(String email);




}
