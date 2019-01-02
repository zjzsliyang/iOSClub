package com.apple.iosclub.mapper;

import java.util.List;

import com.apple.iosclub.model.EventModel;
import org.apache.ibatis.annotations.*;

@Mapper
public interface EventMapper {

    @Select("select * from event")
    List<EventModel> getAll();

    @Select("select * from event where id=#{id}")
    EventModel getById(int id);


    @Select("select * from event where u_code=#{code}")
    List<EventModel> getEvents(int code);

    @Insert({"insert into event(title, location, allDay, startTime, endTime, timeZone, repeatTime, invitees, alerts, showAs, calendar, url, notes, u_code, user_privilege, event_privilege) values(#{event.title},#{event.location},#{event.allDay}, #{event.startTime}, #{event.endTime}, #{event.timeZone}, #{event.repeatTime}, #{event.invitees}, #{event.alerts}, #{event.showAs}, #{event.calendar}, #{event.url}, #{event.notes}, #{event.u_code}, #{event.user_privilege}, #{event.event_privilege})"})
    void insertEvent(@Param("event") EventModel event);

    @Update("update event set title=#{event.title},location=#{event.location},alarms=#{event.alarms},startTime=#{event.startTime}, endTime=#{event.endTime}, url=#{event.url},lastModified=#{event.lastModified},startTimeZone=#{event.startTimeZone} where id=#{event.id}")
    void updateById(@Param("event") EventModel event);

    @Delete("delete from event where id=#{id}")
    void deleteById(int id);
}
