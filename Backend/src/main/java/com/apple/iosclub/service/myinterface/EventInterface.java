package com.apple.iosclub.service.myinterface;

import java.util.HashMap;

public interface EventInterface {

    Object getAll();
    Object getEvents(int code);
    Object getById(int id);
    Object createEvent(HashMap<String, Object> req);
    Object updateEvent(int id, String title, String location, String alarms, String startTime, String endTime, String url, String lastModified, String startTimeZone);
    Object deleteById(int id);
}
