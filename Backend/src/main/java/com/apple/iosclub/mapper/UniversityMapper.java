package com.apple.iosclub.mapper;

import com.apple.iosclub.Entity.University;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface UniversityMapper {

    @Select("select * from university")
    List<University> getAll();

}
