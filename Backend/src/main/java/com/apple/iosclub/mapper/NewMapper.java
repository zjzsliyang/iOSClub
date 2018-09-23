package com.apple.iosclub.mapper;

import com.apple.iosclub.Entity.DBNew;
import com.apple.iosclub.Model.NewModel;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface NewMapper {

//    @Select("select * from news , (user NATURAL JOIN university) where postemail = email")
//    List<MyNew> getAll();
//
//    @Select("select * from news , (user NATURAL JOIN university) where postemail = email and n_privilege <= #{privilege}")
//    List<MyNew> getByPrivilege(int privilege);


    @Insert("insert into news(postemail,time,title,content,video,images,tags,n_privilege) values(#{dbNew.postemail},#{dbNew.time},#{dbNew.title},#{dbNew.content},#{dbNew.video},#{dbNew.images},#{dbNew.tags},${dbNew.news_privilege})")
    void insertNew(@Param("dbNew") DBNew dbNew);

    @Select("select * from news , (user NATURAL JOIN university) where postemail = email and n_privilege <= #{privilege}")
    List<NewModel> getNewsByPrivilege(int privilege);

    @Select("select * from news , (user NATURAL JOIN university) where postemail = email")
    List<NewModel> getAllNews();



}
