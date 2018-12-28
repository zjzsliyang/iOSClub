package com.apple.iosclub.service.myimplement;

import com.apple.iosclub.model.EventModel;
import com.apple.iosclub.mapper.EventMapper;
import com.apple.iosclub.service.myinterface.EventInterface;
import com.apple.iosclub.utils.Common;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

@Service
public class EventService implements EventInterface{

    @Autowired
    public EventMapper eventMapper;

    @Override
    public Object getAll() {
        HashMap<String, Object> res = new HashMap<>();
        try {
            List<EventModel> data = eventMapper.getAll();
            res.put("code", 0);
            res.put("msg", "成功");
            res.put("data", data);
            for(EventModel eventModel : data){
                eventModel.alertsList = Arrays.asList(eventModel.alerts.substring(1,eventModel.alerts.length()-1).split(","));
            }
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e);
        }
        return res;
    }

    @Override
    public Object getEvents(int code) {
        HashMap<String, Object> res = new HashMap<>();
        try {
            List<EventModel> data = eventMapper.getEvents(code);
            res.put("code", 0);
            res.put("msg", "成功");
            res.put("data", data);
            for(EventModel eventModel : data){
                eventModel.alertsList = Arrays.asList(eventModel.alerts.substring(1,eventModel.alerts.length()-1).split(","));
            }
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e);
        }
        return res;
    }

    @Override
    public Object getById(int id) {
        HashMap<String, Object> res = new HashMap<>();
        try {
            EventModel data = eventMapper.getById(id);
            if (data != null) {
                res.put("code", 0);
                res.put("msg", "成功");
            } else {
                res.put("code", 1);
                res.put("msg", "未找到结果");
            }
            res.put("data", data);
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e);
        }
        return res;
    }

    @Override
    public Object createEvent(HashMap<String, Object> req) {
        HashMap<String, Object> res = new HashMap<>();
        try {

            int user_privilege = Integer.parseInt(req.get("user_privilege").toString());
            if(user_privilege < Common.level2){
                res.put("code", 2);
                res.put("msg", "权限不足");
                return res;
            }

            int event_privilege = Integer.parseInt(req.get("event_privilege").toString());
            int u_code = Integer.parseInt(req.get("u_code").toString());

            String title = req.get("title").toString();
            String location = req.get("location").toString();

            int allDay = Integer.parseInt(req.get("allDay").toString());
            String startTime = req.get("startTime").toString();
            String endTime = req.get("endTime").toString();
            String timeZone = req.get("timeZone").toString();

            String repeatTime = req.get("repeatTime").toString();
            String invitees = req.get("invitees").toString();
            String alerts = req.get("alerts").toString();
            String showAs = req.get("showAs").toString();
            String calendar = req.get("calendar").toString();

            String url = req.get("url").toString();
            String notes = req.get("notes").toString();

            EventModel eventModel = new EventModel();

            eventModel.setTitle(title);
            eventModel.setLocation(location);

            eventModel.setAllDay(allDay);
            eventModel.setStartTime(startTime);
            eventModel.setEndTime(endTime);
            eventModel.setTimeZone(timeZone);

            eventModel.setRepeatTime(repeatTime);
            eventModel.setInvitees(invitees);
            eventModel.setAlerts(alerts);
            eventModel.setShowAs(showAs);
            eventModel.setCalendar(calendar);

            eventModel.setUrl(url);
            eventModel.setNotes(notes);

            eventModel.setU_code(u_code);
            eventModel.setUser_privilege(user_privilege);
            eventModel.setEvent_privilege(event_privilege);

            eventMapper.insertEvent(eventModel);
            res.put("code", 0);
            res.put("msg", "添加成功");
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", "垃圾前端");
            res.put("msg", e.getMessage());
        }
        return res;
    }

    @Override
    public Object updateEvent(int id, String title, String location, String alarms, String startTime, String endTime, String url, String lastModified, String startTimeZone) {
        HashMap<String, Object> res = new HashMap<>();
//        try {
//            EventModel eventModel = new EventModel();
//            eventModel.setId(id);
//            eventModel.setTitle(title);
//            eventModel.setAlarms(alarms);
//            eventModel.setStartTime(startTime);
//            eventModel.setEndTime(endTime);
//            eventModel.setLocation(location);
//            eventModel.setUrl(url);
//            eventModel.setLastModified(lastModified);
//            eventModel.setStartTimeZone(startTimeZone);
//            eventMapper.updateById(eventModel);
//            res.put("code", 0);
//            res.put("msg", "修改成功");
//        } catch (Exception e) {
//            res.put("code", 1);
//            res.put("msg", e);
//        }
        return res;
    }

    @Override
    public Object deleteById(int id) {
        HashMap<String, Object> res = new HashMap<>();
        try {
            eventMapper.deleteById(id);
            res.put("code", 0);
            res.put("msg", "删除成功");
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e);
        }
        return res;
    }
}
