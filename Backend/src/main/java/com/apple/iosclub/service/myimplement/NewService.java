package com.apple.iosclub.service.myimplement;

import com.apple.iosclub.Model.NewModel;
import com.apple.iosclub.Utils.Common;
import com.apple.iosclub.mapper.NewMapper;
import com.apple.iosclub.service.myinterface.NewServiceInterface;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Service
public class NewService implements NewServiceInterface{

    @Autowired
    public NewMapper newMapper;


    @Override
    public Object getNewsByPrivilege(int privilege) {

        List<NewModel> list = newMapper.getNewsByPrivilege(privilege);

        ArrayList<HashMap<String,Object>> resultList = pack(list);

        return resultList;
    }

    @Override
    public Object getAllNews() {

        List<NewModel> list = newMapper.getAllNews();

        ArrayList<HashMap<String,Object>> resultList = pack(list);

        return resultList;
    }

    public static ArrayList<HashMap<String, Object>> pack(List<NewModel> list){

        ArrayList<HashMap<String,Object>> resultList = new ArrayList<>();

        for(NewModel newModel : list){

            HashMap<String, Object> newsObject = new HashMap<>();
            HashMap<String, Object> userObject = new HashMap<>();
            HashMap<String, Object> universityObject = new HashMap<>();

            universityObject.put("code", newModel.u_code);
            universityObject.put("name", newModel.u_name);
            universityObject.put("description", newModel.u_description);
            universityObject.put("icon", Common.backendUrl + newModel.u_icon);
            universityObject.put("email", newModel.u_email);

            userObject.put("university", universityObject);
            userObject.put("username", newModel.username);
            userObject.put("user_privilege", newModel.privilege);
            userObject.put("email", newModel.email);
            userObject.put("password", "这个值只是逗逗你");
            userObject.put("position", newModel.position);
            userObject.put("description", newModel.description);
            userObject.put("avatar", Common.backendUrl + newModel.avatar);

            newsObject.put("user", userObject);
            newsObject.put("time", newModel.time);
            newsObject.put("title", newModel.title);
            newsObject.put("content", newModel.content);
            newsObject.put("video", Common.backendUrl + newModel.video);
            newsObject.put("images", new ArrayList<>());//newModel.images);
            newsObject.put("tags", new ArrayList<>());//newModel.tags);
            newsObject.put("news_privilege",newModel.news_privilege);

            resultList.add(newsObject);
        }

        return resultList;

    }

}
