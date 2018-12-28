package com.apple.iosclub.model;

import java.util.List;

public class EventModel {

    public int id;

    public String title;
    public String location;

    public int allDay;
    public String startTime;
    public String endTime;
    public String timeZone;

    public String repeatTime;
    public String invitees;
    public String alerts;
    public List<String> alertsList;
    public String showAs;
    public String calendar;

    public String url;
    public String notes;


    public int u_code;
    public int event_privilege;
    public int user_privilege;

    public int getU_code() {
        return u_code;
    }

    public void setU_code(int u_code) {
        this.u_code = u_code;
    }

    public int getEvent_privilege() {
        return event_privilege;
    }

    public void setEvent_privilege(int event_privilege) {
        this.event_privilege = event_privilege;
    }

    public int getUser_privilege() {
        return user_privilege;
    }

    public void setUser_privilege(int user_privilege) {
        this.user_privilege = user_privilege;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public int getAllDay() {
        return allDay;
    }

    public void setAllDay(int allDay) {
        this.allDay = allDay;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getTimeZone() {
        return timeZone;
    }

    public void setTimeZone(String timeZone) {
        this.timeZone = timeZone;
    }

    public String getRepeatTime() {
        return repeatTime;
    }

    public void setRepeatTime(String repeatTime) {
        this.repeatTime = repeatTime;
    }

    public String getInvitees() {
        return invitees;
    }

    public void setInvitees(String invitees) {
        this.invitees = invitees;
    }

    public String getAlerts() {
        return alerts;
    }

    public void setAlerts(String alerts) {
        this.alerts = alerts;
    }

    public String getShowAs() {
        return showAs;
    }

    public void setShowAs(String showAs) {
        this.showAs = showAs;
    }

    public String getCalendar() {
        return calendar;
    }

    public void setCalendar(String calendar) {
        this.calendar = calendar;
    }
}
