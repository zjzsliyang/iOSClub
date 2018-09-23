#### 获取所有学校信息

```
GET /club/info/getAll
```



#### 获取所有老师

```
GET /club/teacherModel/getAll
```

#### 获取某个学校所有老师

```
GET /club/teacherModel/getByCode?code=10247
```



#### 获取所有学生干部

```
GET /club/sm/getAll
```

#### 获取某个学校所有学生干部

```
GET /club/sm/getByCode?code=10247
```





#### 根据权限获取新闻

```
10.0.1.13:8888/news/getByPrivilege?u_privilege=5
```

返回实例

```
[
    {
        "formatUser": {
            "universityModel": {
                "code": 10247,
                "name": "同济大学",
                "description": "同济大学苹果俱乐部建立于2003年9月24日，是同济大学软件学院创新基地支撑的七个俱乐部之一，是亚太地区较早和Apple 相关团队展开协作的学生俱乐部，旨在体现和落实同济大学创新创业人才培养的理念，传播Apple的先进技术以及培养学生的创新创业意识。",
                "icon": "/university_icon/10247.jpeg",
                "email": "tongji@tongji.edu.cn"
            },
            "username": "罗忠金",
            "user_privilege": 5,
            "email": "luozhongjin@tongji.edu.cn",
            "password": "cdfasfas",
            "position": "前端",
            "description": "发大水发",
            "avatar": "////"
        },
        "time": "2018-09-09",
        "title": "爱李阳哦",
        "content": "爱李阳哦",
        "video": "",
        "images": "",
        "tags": "",
        "news_privilege": 5
    },
    {
        "formatUser": {
            "universityModel": {
                "code": 10247,
                "name": "同济大学",
                "description": "同济大学苹果俱乐部建立于2003年9月24日，是同济大学软件学院创新基地支撑的七个俱乐部之一，是亚太地区较早和Apple 相关团队展开协作的学生俱乐部，旨在体现和落实同济大学创新创业人才培养的理念，传播Apple的先进技术以及培养学生的创新创业意识。",
                "icon": "/university_icon/10247.jpeg",
                "email": "tongji@tongji.edu.cn"
            },
            "username": "罗忠金",
            "user_privilege": 5,
            "email": "luozhongjin@tongji.edu.cn",
            "password": "cdfasfas",
            "position": "前端",
            "description": "发大水发",
            "avatar": "////"
        },
        "time": "2018-09-09",
        "title": "白头山",
        "content": "白头山，即长白山，广义的长白山是中国辽宁、吉林、黑龙江三省东部山地以及俄罗斯远东和朝鲜半岛诸多余脉的总称；狭义的长白山是指位于白山市东南部地区，东经127°40‘~128°16’，北纬41°35‘~42°25’之间的地带，是中朝两国界山。朝韩两国均把白头山认定为其民族发源地，朝鲜方面还有“白头山血统”等说法",
        "video": "",
        "images": "",
        "tags": "",
        "news_privilege": 5
    }
]
```

































用户

```
邮箱
姓名
学校: {名字:,代码:,邮箱,头像，描述}
密码
头像
座右铭
权限
方向
```





新闻

```
用户
时间
标题
内容
视频
图片
标签
权限
```









