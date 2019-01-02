package com.apple.iosclub.controller;

import com.apple.iosclub.mapper.EventMapper;
import com.apple.iosclub.service.myimplement.EventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

@RestController
@RequestMapping("/events")
public class EventController {


    @Autowired
    public EventMapper eventMapper;

    private EventService eventService;

    @Autowired
    public EventController(EventService eventService){
        this.eventService = eventService;
    }

    @GetMapping("/getEvents")
    public Object getEvents(int code) {

//        System.out.println(code);

        if(code == -1){
            return eventService.getAll();
        }

        return eventService.getEvents(code);
    }

    @GetMapping("/getAll")
    public Object getAll() {
        return eventService.getAll();
    }

    @GetMapping("/getById")
    public Object getById(int id) {
        return eventService.getById(id);
    }

    @PostMapping("/create")
    public Object create(@RequestBody HashMap<String, Object> req) {

//        String title = req.get("title").toString();
//        String location = req.get("location").toString();
//
//        int allDay = Integer.parseInt(req.get("allDay").toString());
//        String startTime = req.get("startTime").toString();
//        String endTime = req.get("endTime").toString();
//        String timeZone = req.get("timeZone").toString();
//
//        String repeatTime = req.get("repeatTime").toString();
//        String invitees = req.get("invitees").toString();
//        String alerts = req.get("alerts").toString();
//        String showAs = req.get("showAs").toString();
//        String calendar = req.get("calendar").toString();

        return eventService.createEvent(req);
    }

    @PostMapping("/update")
    public Object update(@RequestBody HashMap<String, Object> req) {

        int id = Integer.parseInt(req.get("id").toString());
        String title = req.get("title").toString();
        String location = req.get("location").toString();
        String alarms = req.get("alarms").toString();
        String startTime = req.get("startTime").toString();
        String endTime = req.get("endTime").toString();
        String url = req.get("url").toString();
        String startTimeZone = req.get("startTimeZone").toString();
        Date d = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String lastModified = sdf.format(d).toString();

        return eventService.updateEvent(id, title, location, alarms, startTime, endTime, url, lastModified, startTimeZone);
    }


    @PostMapping("/delete")
    public Object delete(@RequestBody HashMap<String, Object> req) {
        HashMap<String, Object> res = new HashMap<>();
        try {
            int id = Integer.parseInt(req.get("id").toString());
            int event_privilege = Integer.parseInt(req.get("event_privilege").toString());
            int user_privilege = Integer.parseInt(req.get("user_privilege").toString());
            int code = Integer.parseInt(req.get("code").toString());
            if(user_privilege >= event_privilege && eventService.selectById(id) == code){
                return eventService.deleteById(id);
            }
            else{
                res.put("code", 2);
                res.put("msg", "权限不足");
            }
        }catch (Exception e){
            res.put("code", 1);
            res.put("msg", e);
        }
        return res;
    }
}
