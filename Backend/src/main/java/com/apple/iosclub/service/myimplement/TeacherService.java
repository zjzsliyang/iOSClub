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


        // 暂时默认每个学校都有老师，若没有，则置空
        if(list.size() == 0){
            TeacherModel teacherModel = new TeacherModel();
            teacherModel.code = code;
            teacherModel.name = "俱乐部老师";
            teacherModel.avatar = "/files/high_level/avatar.png";
            list.add(teacherModel);
        }

        for(TeacherModel teacherModel : list){
            teacherModel.avatar = Common.backendUrl + teacherModel.avatar;
        }

        return list;
    }
}
