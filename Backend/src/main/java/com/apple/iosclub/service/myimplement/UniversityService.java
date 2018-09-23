package com.apple.iosclub.service.myimplement;

import com.apple.iosclub.model.UniversityModel;
import com.apple.iosclub.utils.Common;
import com.apple.iosclub.mapper.UniversityMapper;
import com.apple.iosclub.service.myinterface.UniversityInterface;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UniversityService implements UniversityInterface{

    @Autowired
    public UniversityMapper universityMapper;

    public Object getAll(){
        List<UniversityModel> universityModelList =  universityMapper.getAll();
        for(UniversityModel universityModel : universityModelList){
            universityModel.icon = Common.backendUrl  + universityModel.icon;
        }
        return universityModelList;
    }

}
