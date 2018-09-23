package com.apple.iosclub.service.myinterface;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;

public interface UserServiceInterface {

    Object getInfoByEmail(String email);
    Object login(String email, String password);
    Object register(HashMap<String, Object> req);
    Object avatarUpdate(MultipartFile image, String email)throws IOException;

}
