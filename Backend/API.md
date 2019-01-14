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





#### 发布新闻

```
post localhost:8080/news/publish
```

```
{
    "postmail": "a",
    "title": "这是一条官方测试新闻",
    "content": "这是一条官方测试新闻",
    "video": 二进制,
    "images": 二进制,
    "tags": "[]",
    "news_privilege": 2,
    "user_privilege": 3
}
```



#### 删除新闻

```
post localhost:8080/news/delete
```

```
{
	"id": 41,
	"news_privilege": 0,
	"user_privilege": 3,
	"code": -1
}
```



### 新闻查询

```
get /news/search?text=a&u_privilege=1&code=0
```

```
{
    "msg": "查询成功",
    "code": 0,
    "tag_list": [
        {
            "images": [],
            "id": 19,
            "time": "2018-02-07 10:59:32",
            "video": "",
            "title": "深圳科技大学 -- 文章权限1",
            "user": {
                "password": "这个值只是逗逗你",
                "university": {
                    "code": 0,
                    "name": "同济大学",
                    "icon": "http://121.196.192.132:80/files/university_icon/0.png",
                    "description": "同济大学苹果俱乐部是苹果公司在中国成立的第一个学生俱乐部，每年不但组织多名获奖学生赴美参加 WWDC( 全球苹果开发者大会 )，而且总能摘得中国苹果高校技术开发者大赛桂冠。苹果技术实验室配有 iMac、iPhone、iPod Touch、iPad 与Apple Watch 等最新的苹果设备，常年面向会员免费开放。更有俱乐部学长亲身向您传授苹果技术与实习经验。",
                    "email": "tac@tongji.edu.cn"
                },
                "description": "t1",
                "position": "t1",
                "avatar": "http://121.196.192.132:80",
                "email": "t1",
                "username": "t1",
                "user_privilege": 1
            },
            "content": "深圳科技大学",
            "tags": "a",
            "news_privilege": 1
        },
        {
            "images": [],
            "id": 21,
            "time": "2018-04-07 10:59:32",
            "video": "",
            "title": "深圳科技大学 -- 文章权限0",
            "user": {
                "password": "这个值只是逗逗你",
                "university": {
                    "code": 0,
                    "name": "同济大学",
                    "icon": "http://121.196.192.132:80/files/university_icon/0.png",
                    "description": "同济大学苹果俱乐部是苹果公司在中国成立的第一个学生俱乐部，每年不但组织多名获奖学生赴美参加 WWDC( 全球苹果开发者大会 )，而且总能摘得中国苹果高校技术开发者大赛桂冠。苹果技术实验室配有 iMac、iPhone、iPod Touch、iPad 与Apple Watch 等最新的苹果设备，常年面向会员免费开放。更有俱乐部学长亲身向您传授苹果技术与实习经验。",
                    "email": "tac@tongji.edu.cn"
                },
                "description": "t1",
                "position": "t1",
                "avatar": "http://121.196.192.132:80",
                "email": "t1",
                "username": "t1",
                "user_privilege": 1
            },
            "content": "深圳科技大学",
            "tags": "a",
            "news_privilege": 0
        }
    ],
    "title_list": []
}
```



#### 根据学校获取分享

```
get localhost:8080/blog/getByCode?code=29
```

#### 根据权限分享

```
post localhost:8080/blog/shareBlog
```

```
{
	"sharemail": "zhuhongming.tongji.edu.cn",
	"url": "https://cn.bing.com/",
	"user_privilege": 2,
	"code":29
}
```



#### 获取事件

```
get localhost:8080/events/getAll
```

```
get /events/getEvents?code=29
```

```
//response
{
    "msg": "成功",
    "code": 0,
    "data": [
        {
            "id": 28,
            "title": "同济主席请吃饭",
            "location": "同济大学嘉定校区",
            "allDay": 1,
            "startTime": "2018-12-30 11:00",
            "endTime": "2018-12-30 18:00",
            "timeZone": "Beijing",
            "repeatTime": "每周三顿",
            "invitees": "[小金,小金,小金]",
            "inviteesList": [
                "小金",
                "小金",
                "小金"
            ],
            "alerts": "[a,b,c]",
            "alertsList": [
                "a",
                "b",
                "c"
            ],
            "showAs": "busy",
            "calendar": "",
            "url": "",
            "notes": "",
            "u_code": 1,
            "event_privilege": 1,
            "user_privilege": 3
        }
    ]
}
```



#### 发布事件

```
post localhost:8080/events/create
```

```
{
    "title": "同济主席请吃饭",
    "location": "同济大学嘉定校区",
    
    "allDay": 1,
    "startTime": "2018-12-30 11:00",
    "endTime": "2018-12-30 18:00",
    "timeZone": "Beijing",
    
    "repeatTime": "每周三顿",
    "invitees": ["小金", "小金", "小金"],
    "alerts": ["a","b","c"],
    "showAs": "busy",
    "calendar": "",
    
    "url":"",
    "notes":"",
    
    "u_code": 1,
    "user_privilege":3,
    "event_privilege": 1
}
```

#### 删除事件

```
post /events/delete
```

```
{
	"id": 38,
	"event_privilege": 1,
	"user_privilege": 2,
	"code": -1
}
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









