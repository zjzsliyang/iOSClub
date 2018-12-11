package com.apple.iosclub.service.myinterface;

public interface EventInterface {

    Object getAll();
    Object getById(int id);
    Object createEvent(String title, String location, String alarms, String url, String lastModified, String startTimeZone);
    Object updateEvent(int id, String title, String location, String alarms, String url, String lastModified, String startTimeZone);
    Object deleteById(int id);
}
