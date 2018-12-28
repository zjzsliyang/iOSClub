package com.apple.iosclub.service.myinterface;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;

public interface NewServiceInterface {

    Object getNewsByPrivilege(int privilege);
    Object getByPrivilegeAndCode(int privilege, int code);
    Object getAllNews();
    Object publish(HashMap<String, Object> req, MultipartFile[] uploadingFiles) throws IOException;
    Object deleteById(int id);
}
