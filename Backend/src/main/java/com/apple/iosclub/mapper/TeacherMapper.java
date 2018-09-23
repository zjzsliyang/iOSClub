package com.apple.iosclub.mapper;

import com.apple.iosclub.Model.TeacherModel;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface TeacherMapper {

    @Select("select * from club_teacher")
    List<TeacherModel> getAll();

    @Select("select * from club_teacher where code=#{code}")
    List<TeacherModel> getByCode(int code);
}
