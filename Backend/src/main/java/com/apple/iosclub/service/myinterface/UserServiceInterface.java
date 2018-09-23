package com.apple.iosclub.service.myinterface;

import org.springframework.web.bind.annotation.RequestBody;

import java.util.HashMap;

public interface UserServiceInterface {

    Object getInfoByEmail(String email);
    Object login(String email, String password);
    Object register(HashMap<String, Object> req);

}
