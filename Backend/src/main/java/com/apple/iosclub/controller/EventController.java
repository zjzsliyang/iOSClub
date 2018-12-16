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

        return eventService.createEvent(title, location, alarms, startTime, endTime, url, lastModified, startTimeZone);
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
        int id = Integer.parseInt(req.get("id").toString());
        return eventService.deleteById(id);
    }
}
