package com.apple.iosclub.model;

public class TeacherModel {

    public int id;
    public int code;
    public String name;
    public String position;
    public String email;
    public String department;
    public String avatar;

    public TeacherModel() {
        this.id = -1;
        this.code = -2;
        this.name = "";
        this.position = "";
        this.email = "";
        this.department = "";
        this.avatar = "";
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }



    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }


}
