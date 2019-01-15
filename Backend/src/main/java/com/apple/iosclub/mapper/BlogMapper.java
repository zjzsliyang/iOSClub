package com.apple.iosclub.mapper;

import com.apple.iosclub.model.BlogModel;
import com.apple.iosclub.model.NewModel;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface BlogMapper {

    @Select("select * from blog_share, (user NATURAL JOIN university) WHERE user.email = blog_share.sharemail order by time desc")
    List<BlogModel> getAll();

    @Select("select * from blog_share, (user NATURAL JOIN university) WHERE user.email = blog_share.sharemail and blog_share.u_code = #{code} order by time desc")
    List<BlogModel> getByCode(int code);

    @Insert("insert into blog_share(sharemail, url, time, u_code) values(#{sharemail}, #{url}, #{time}, #{code})")
    void insertBlog(@Param("sharemail") String sharemail, @Param("url") String url, @Param("time") String time,@Param("code") int code);

}
