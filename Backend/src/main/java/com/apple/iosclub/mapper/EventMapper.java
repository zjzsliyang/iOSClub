package com.apple.iosclub.mapper;

import java.util.List;

import com.apple.iosclub.Model.EventModel;
import org.apache.ibatis.annotations.*;

import com.apple.iosclub.entity.DBNew;

@Mapper
public interface EventMapper {

    @Select("select * from event")
    List<EventModel> getAll();

    @Select("select * from event where id=#{id}")
    EventModel getById(int id);

    @Insert({"insert into event(title, location, alarms, url, lastModified, startTimeZone) values(#{event.title},#{event.location},#{event.alarms}, #{event.url}, #{event.lastModified}, #{event.startTimeZone})"})
    void insertEvent(@Param("event") EventModel event);

    @Update("update event set title=#{event.title},location=#{event.location},alarms=#{event.alarms},url=#{event.url},lastModified=#{event.lastModified},startTimeZone=#{event.startTimeZone} where id=#{event.id}")
    void updateById(@Param("event") EventModel event);

    @Delete("delete from event where id=#{id}")
    void deleteById(int id);
}
