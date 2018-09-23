package com.apple.iosclub.service.myimplement;

import com.apple.iosclub.entity.DBNew;
import com.apple.iosclub.model.NewModel;
import com.apple.iosclub.utils.Common;
import com.apple.iosclub.mapper.NewMapper;
import com.apple.iosclub.service.myinterface.NewServiceInterface;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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

    @Override
    public Object publish(HashMap<String, Object> req, MultipartFile[] files) throws IOException {

        DBNew dbNew = new DBNew();
        try {
            dbNew.postemail = (String) ((HashMap<String, Object>)req.get("user")).get("postmail");
        }catch (Exception e){
            dbNew.postemail = (String)req.get("postmail");
        }

        Date d = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        dbNew.time =  sdf.format(d).toString();
        dbNew.title =  (String)req.get("title");
        dbNew.content = (String)req.get("content");

        dbNew.video = "";

        String images = "";
        String directory = Common.root + "news_images/";
        for (MultipartFile uploadedFile : files) {
            String oldName = uploadedFile.getOriginalFilename();
            String suffix = oldName.substring(oldName.lastIndexOf(".") + 1);
            long timestamp = System.currentTimeMillis();
            String newName = "" + timestamp + "." + suffix;
            images += Common.virtual + "news_images/" + newName + ";";
            File file = new File(directory + newName);
            uploadedFile.transferTo(file);
            System.out.println(newName);
        }
        dbNew.images = images;

        dbNew.tags = (req.get("tags")).toString();
        dbNew.news_privilege =  Integer.parseInt(req.get("news_privilege").toString());

        newMapper.insertNew(dbNew);


        return dbNew;

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

            if(newModel.video.equals("")){
                newsObject.put("video", newModel.video);
                String imagesString = newModel.images;
                String[] images = imagesString.split(";");
                ArrayList<String> imageList = new ArrayList<>();
                for(String i : images){
                    imageList.add(Common.backendUrl + i);
                }
                newsObject.put("images", imageList);
            }else {
                newsObject.put("video", Common.backendUrl + newModel.video);
                newsObject.put("images", new ArrayList<>());
            }


            newsObject.put("tags", new ArrayList<>());//newModel.tags);
            newsObject.put("news_privilege",newModel.news_privilege);

            resultList.add(newsObject);
        }

        return resultList;

    }

}
