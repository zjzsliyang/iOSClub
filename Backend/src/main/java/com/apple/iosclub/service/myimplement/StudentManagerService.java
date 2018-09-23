package com.apple.iosclub.service.myimplement;

import com.apple.iosclub.Model.StudentManagerModel;
import com.apple.iosclub.Utils.Common;
import com.apple.iosclub.mapper.StudentManagerMapper;
import com.apple.iosclub.service.myinterface.StudentManagerInterface;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StudentManagerService implements StudentManagerInterface {

    @Autowired
    private StudentManagerMapper studentManagerMapper;

    @Override
    public Object getByCode(int code) {

        List<StudentManagerModel> list = studentManagerMapper.getByCode(code);

        for(StudentManagerModel studentManagerModel : list){
            studentManagerModel.avatar = Common.backendUrl + studentManagerModel.avatar;
        }

        return list;
    }

    @Override
    public Object getAll() {

        List<StudentManagerModel> list = studentManagerMapper.getAll();

        for(StudentManagerModel studentManagerModel : list){
            studentManagerModel.avatar = Common.backendUrl + studentManagerModel.avatar;
        }
        return list;
    }
}
