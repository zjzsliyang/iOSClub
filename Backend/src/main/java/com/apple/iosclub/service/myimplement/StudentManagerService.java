package com.apple.iosclub.service.myimplement;

import com.apple.iosclub.model.StudentManagerModel;
import com.apple.iosclub.utils.Common;
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

        // 暂时默认每个学校都有主席
        if (list.size() == 0){
            StudentManagerModel studentManagerModel = new StudentManagerModel();
            studentManagerModel.code = code;
            studentManagerModel.position = "俱乐部主席";
            studentManagerModel.avatar = "/files/high_level/avatar.png";
            list.add(studentManagerModel);
        }


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
