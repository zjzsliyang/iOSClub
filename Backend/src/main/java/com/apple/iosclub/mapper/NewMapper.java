package com.apple.iosclub.mapper;

import com.apple.iosclub.entity.DBNew;
import com.apple.iosclub.model.NewModel;
import org.apache.ibatis.annotations.*;

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

    // visitor get
    @Select("select * from news , (user NATURAL JOIN university) where (postemail = email and u_code = -1 and n_privilege <= #{privilege}) or (postemail = email and n_privilege <= #{privilege}) order by time desc")
    List<NewModel> getNewsByPrivilege(int privilege);

    // teacher/president get
    @Select("select * from news , (user NATURAL JOIN university) where (postemail = email and u_code = -1 and n_privilege <= #{privilege}) or (postemail = email and n_privilege <= #{privilege} and u_code = #{code}) order by time desc")
    List<NewModel> getByPrivilegeAndCode(@Param("privilege") int privilege, @Param("code") int code);

    // admin get
    @Select("select * from news , (user NATURAL JOIN university) where postemail = email order by time desc")
    List<NewModel> getAllNews();


    @Delete("delete from news where n_id=#{id}")
    void deleteById(int id);
}
