package com.apple.iosclub.Entity;

public class DBUser {

    public DBUser(int u_code, String username, int privilege, String email, String password, String position, String description, String avatar) {
        this.u_code = u_code;
        this.username = username;
        this.privilege = privilege;
        this.email = email;
        this.password = password;
        this.position = position;
        this.description = description;
        this.avatar = avatar;
    }

    public int u_code;
    public String username;
    public int privilege;
    public String email;
    public String password;
    public String position;
    public String description;
    public String avatar;

}
