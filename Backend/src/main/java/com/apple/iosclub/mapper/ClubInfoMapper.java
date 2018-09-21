package com.apple.iosclub.mapper;


import com.apple.iosclub.Entity.ClubInfo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ClubInfoMapper {

    @Select("select * from all_clubs")
    List<ClubInfo> getAll();

}
