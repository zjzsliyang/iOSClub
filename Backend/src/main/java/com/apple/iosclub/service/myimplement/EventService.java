package com.apple.iosclub.service.myimplement;

import com.apple.iosclub.Model.EventModel;
import com.apple.iosclub.mapper.EventMapper;
import com.apple.iosclub.service.myinterface.EventInterface;
import org.apache.ibatis.jdbc.Null;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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
    public Object createEvent(String title, String location, String alarms, String url, String lastModified, String startTimeZone) {
        HashMap<String, Object> res = new HashMap<>();
        try {
            EventModel eventModel = new EventModel();
            eventModel.setTitle(title);
            eventModel.setAlarms(alarms);
            eventModel.setLocation(location);
            eventModel.setUrl(url);
            eventModel.setLastModified(lastModified);
            eventModel.setStartTimeZone(startTimeZone);
            eventMapper.insertEvent(eventModel);
            res.put("code", 0);
            res.put("msg", "添加成功");
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e);
        }
        return res;
    }

    @Override
    public Object updateEvent(int id, String title, String location, String alarms, String url, String lastModified, String startTimeZone) {
        HashMap<String, Object> res = new HashMap<>();
        try {
            EventModel eventModel = new EventModel();
            eventModel.setId(id);
            eventModel.setTitle(title);
            eventModel.setAlarms(alarms);
            eventModel.setLocation(location);
            eventModel.setUrl(url);
            eventModel.setLastModified(lastModified);
            eventModel.setStartTimeZone(startTimeZone);
            eventMapper.updateById(eventModel);
            res.put("code", 0);
            res.put("msg", "修改成功");
        } catch (Exception e) {
            res.put("code", 1);
            res.put("msg", e);
        }
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
