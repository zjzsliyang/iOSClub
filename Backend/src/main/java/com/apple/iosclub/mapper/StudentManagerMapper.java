package com.apple.iosclub.mapper;

import com.apple.iosclub.Model.StudentManagerModel;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface StudentManagerMapper {

    @Select("select * from club_student_manager")
    List<StudentManagerModel> getAll();

    @Select("select * from club_student_manager where code=#{code}")
    List<StudentManagerModel> getByCode(int code);
}
