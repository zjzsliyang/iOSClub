package com.apple.iosclub.service.myimplement;

import com.apple.iosclub.model.TeacherModel;
import com.apple.iosclub.utils.Common;
import com.apple.iosclub.mapper.TeacherMapper;
import com.apple.iosclub.service.myinterface.TeacherInterface;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TeacherService implements TeacherInterface {

    @Autowired
    private TeacherMapper teacherMapper;

    @Override
    public Object getAll() {
        List<TeacherModel> list = teacherMapper.getAll();

        for(TeacherModel teacherModel : list){
            teacherModel.avatar = Common.backendUrl + teacherModel.avatar;
        }

        return list;
    }

    @Override
    public Object getByCode(int code) {

        List<TeacherModel> list = teacherMapper.getByCode(code);

        for(TeacherModel teacherModel : list){
            teacherModel.avatar = Common.backendUrl + teacherModel.avatar;
        }

        return list;
    }
}
