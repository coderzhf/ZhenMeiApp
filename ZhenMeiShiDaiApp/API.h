//
//  API.h
//  ZhenMeiShiDaiApp
//
//  Created by zx on 15/6/10.
//  Copyright (c) 2015年 zxl－mac1. All rights reserved.
//

#ifndef ZhenMeiShiDaiApp_API_h
#define ZhenMeiShiDaiApp_API_h

//192.168.100.152:8080 115.28.178.117:8980  chuangyes.cn
#define kCommon @"http://chuangyes.cn/audioCourse/front/"
//显示图像
#define KShowPhoto @"http://chuangyes.cn/audioCourse/"

#define kCommomAction(args) [kCommon stringByAppendingString: args]

//做讲师
#define KShowByType   kCommomAction(@"helpAct.htm?&operate=showByType")
//关于我们
#define KAbout        [KShowPhoto stringByAppendingString: @"admin/helpAct.htm?operate=about"]
//注册协议
#define KProcol       [KShowPhoto stringByAppendingString: @"admin/helpAct.htm?operate=help"]
//获取验证码
#define KGetCode      kCommomAction(@"sendTemplateSmsAct.htm?&")
//注册验证
#define KIdentify     kCommomAction(@"userAct.htm?&operate=showLoginName")
//修改密码验证
#define KIdentifier   kCommomAction(@"userAct.htm?&operate=yzUser")
//注册
#define KRegister     kCommomAction(@"userAct.htm?&operate=reg")
//修改密码
#define KUpdatePsw    kCommomAction(@"userAct.htm?&operate=updatePwd")
//找回密码
#define KFindPsw      kCommomAction(@"userAct.htm?&operate=findPwd")
//登录
#define KLogin        kCommomAction(@"userAct.htm?&operate=login")
//微信登录
#define KWXLogin      kCommomAction(@"userAct.htm?&operate=loginWx")
//首页
#define KShowArticle  kCommomAction(@"userAct.htm?&operate=showArticle")
//更改信息
#define KUpdateUser   kCommomAction(@"userAct.htm?&operate=updateUser")
//关注
#define KAddUserAttention  kCommomAction(@"userAttentionAct.htm?&operate=addUserAttention")
//添加评论（回复）
#define KAddComment   kCommomAction(@"commentAct.htm?&operate=addComment")
//私信
#define KAddPrivateMessage   kCommomAction(@"privateMessageAct.htm?&operate=addPrivateMessage")
//版本信息
#define KShowParams   kCommomAction(@"helpAct.htm?&operate=showParams")
//显示项目类型
#define KShowAll      kCommomAction(@"helpAct.htm?&operate=showAll")
//意见反馈
#define KfeedBack_url kCommomAction(@"helpAct.htm?&operate=addFeedback")
//发说说
#define KAddTopicInfo kCommomAction(@"topicInfoAct.htm?&operate=addTopicInfo")
//附近的帖子
#define KNearTopicInfo kCommomAction(@"topicInfoAct.htm?&operate=nearTopicInfo")
//最新的帖子(我发布的帖子)
#define KNewTopicInfo  kCommomAction(@"topicInfoAct.htm?&operate=newTopicInfo")
//我的关注
#define KShowMyAttention   kCommomAction(@"userAttentionAct.htm?&operate=showMyAttention")
//我的跟帖
#define KMyCommentTopic    kCommomAction(@"topicInfoAct.htm?&operate=myCommentTopic")
//筛选帖子
#define KShowByOther       kCommomAction(@"topicInfoAct.htm?&operate=showByOther")
//删帖子
#define KDeleteMyTopic     kCommomAction(@"topicInfoAct.htm?&operate=deleteMyTopic")
//传图片
#define KIMAGEURL          kCommomAction(@"uploadAct.htm")
//热播
#define KHomeHotPlay       kCommomAction(@"articleAct.htm?&operate=showArticle&tag=1")
//干货
#define KHomeGood          kCommomAction(@"articleAct.htm?&operate=showArticle&tag=2")
//活动
#define KHomeActivity      kCommomAction(@"articleAct.htm?&operate=showArticle&tag=3")
//广告
#define KHomeAd            kCommomAction(@"articleAct.htm?&operate=showArticle&tag=4")
//推荐
#define KHomeRecom         kCommomAction(@"articleAct.htm?&operate=showArticle&tag=5")
//猜你想听
#define KAudioLove         kCommomAction(@"articleAct.htm?&operate=showMyLike")
//搜索
#define KHomeSearch        kCommomAction(@"articleAct.htm?&operate=showArticle")
//标签类别
#define KHomeRecLabelDetail kCommomAction(@"articleAct.htm?&operate=showArticle&tag=8")
//推荐类别展示
#define KHomeRecLabel      kCommomAction(@"helpAct.htm?&operate=showCategory")
//音乐详情
#define KAudioDetail       kCommomAction(@"articleAct.htm?&operate=showById")
//查看私信列表
#define KPrivateMessageList kCommomAction(@"privateMessageAct.htm?&operate=showPrivateMessageList")
//私信详情显示
#define KPrivateMessageShow kCommomAction(@"privateMessageAct.htm?&operate=showMessage")
//删除私信
#define KPrivateMessageDelete kCommomAction(@"privateMessageAct.htm?&operate=deletePrivateMessage")
//添加私信
#define KPrivateMessageAdd  kCommomAction(@"privateMessageAct.htm?&operate=addPrivateMessage")
//查看系统信息
#define KSystemMessageList  kCommomAction(@"bulletinAct.htm?&operate=showBulletin")
//查看具体信息
#define KReadBulletin       kCommomAction(@"bulletinAct.htm?&operate=readBulletin")
//删除系统信息
#define KSystemMessageDelete kCommomAction(@"bulletinAct.htm?&operate=deleteBulletin")
//收藏
#define KAddCollectionsAct   kCommomAction(@"userCollectionsAct.htm?&operate=addCollectionsAct")
//显示收藏列表
#define KShowCollectionAct   kCommomAction(@"userCollectionsAct.htm?&operate=showCollectionsAct")
//干货 活动 详情
#define  KActivityDetail     kCommomAction(@"articleAct.htm?&operate=joinArticle")
//增加点播
#define KAddAudio            kCommomAction(@"userAudioAct.htm?&operate=addUserAudio")
//查看点播
#define KShowAudio           kCommomAction(@"userAudioAct.htm?&operate=showUserAudio")
#endif
