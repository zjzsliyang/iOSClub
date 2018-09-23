package com.apple.iosclub.mapper;

import com.apple.iosclub.model.UniversityModel;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface UniversityMapper {

    @Select("select * from university")
    @Results({
            @Result(property = "code", column = "u_code"),
            @Result(property = "name", column = "u_name"),
            @Result(property = "description", column = "u_description"),
            @Result(property = "icon", column = "u_icon"),
            @Result(property = "email", column = "u_email")
    })
    List<UniversityModel> getAll();

}
