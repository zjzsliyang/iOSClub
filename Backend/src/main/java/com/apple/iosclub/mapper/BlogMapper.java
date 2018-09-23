package com.apple.iosclub.mapper;

import com.apple.iosclub.model.BlogModel;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface BlogMapper {

    @Select("select * from blog_share")
    List<BlogModel> getAll();

    @Insert("insert into blog_share(sharemail, url, time) values(#{sharemail}, #{url}, #{time})")
    void insertBlog(@Param("sharemail") String sharemail, @Param("url") String url, @Param("time") String time);

}
