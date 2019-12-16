//
//  Header.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/3/28.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#ifndef Header_h
#define Header_h

#pragma mark --- 基本配置
#define NetWay @"POST"
#define OAUTH_TOKEN @"OAUTH-TOKEN"


//首页
#define YunKeTang_App_Home @"Home"
#define YunKeTang_Home_home_search @"home.search"
#define YunKeTang_App_getAdvert @"getAdvert"
#define YunKeTang_App_getRecCateList @"getRecCateList"
#define YunKeTang_App_indexHotCourse @"indexHotCourse"
#define YunKeTang_App_indexNewCourse @"indexNewCourse"
#define YunKeTang_App_indexNewLive @"indexNewLive"
#define YunKeTang_App_indexReTeacher @"indexReTeacher"
#define YunKeTang_App_indexReSchool @"indexReSchool"
#define YunKeTang_App_indexAllReCate @"indexAllReCate"
#define YunKeTang_App_lineClassList @"lineClassList"
#define YunKeTang_App_Home_home_advert @"home.advert"
#define YunKeTang_App_Home_home_cate @"home.cate"
#define YunKeTang_App_Home_home_getCateList @"home.getCateList"
#define YunKeTang_App_Home_home_live @"home.live"
#define YunKeTang_App_Home_home_hotVideo @"home.hotVideo"
#define YunKeTang_App_Home_home_newVideo @"home.newVideo"
#define YunKeTang_App_Home_home_lineVideo @"home.lineVideo"
#define YunKeTang_App_Home_home_teacher @"home.teacher"
#define YunKeTang_App_Home_home_school @"home.school"
// 首页新增全部数据接口 此接口返回首页所需所有数据
#define YunKeTang_App_Home_allData @"home.index"


//课程
#define YunKeTang_App_Video @"Video"
#define YunKeTang_Video_videogetList @"video.getList"
#define YunKeTang_Video_video_getInfo @"video.getInfo"
#define YunKeTang_Video_video_getCatalog @"video.getCatalog"
#define YunKeTang_Video_video_render @"video.render"
#define YunKeTang_Video_video_addReview @"video.addReview"
#define YunKeTang_Video_video_collect @"video.collect"
#define YunKeTang_Video_video_getShareUrl @"video.getShareUrl"
#define YunKeTang_Video_video_getFreeTime @"video.getFreeTime"
#define YunKeTang_Video_video_getCanUseCouponList @"video.getCanUseCouponList"
#define YunKeTang_Video_video_getTeacherList @"video.getTeacherList"
#define YunKeTang_Video_video_getPopup @"video.getPopup"
#define YunKeTang_Video_video_getMarquee @"video.getMarquee"
#define YunKeTang_Video_video_addQuestion @"video.addQuestion"
#define YunKeTang_Video_video_addNote @"video.addNote"
#define YunKeTang_Video_video_getBaiduDocReadToken @"video.getBaiduDocReadToken"
#define YunKeTang_Course_Activity_Info @"course.getEventInfo"









//直播
#define YunKeTang_Live_live_getInfo @"live.getInfo"
#define YunKeTang_Live_live_getList @"live.getList"
#define YunKeTang_Live_live_getScreenTeacher @"live.getScreenTeacher"
#define YunKeTang_Live_live_getCatalog @"live.getCatalog"
#define YunKeTang_Live_live_getCanUseCouponList @"live.getCanUseCouponList"
#define YunKeTang_Live_live_getTeacherList @"live.getTeacherList"



//直播和点播
#define YunKeTang_Course_Course_buyLive @"course.buyLive"
#define YunKeTang_Course_Course_buyVideo @"course.buyVideo"
#define YunKeTang_Course_Course_buyLineCourse @"course.buyLineCourse"
#define YunKeTang_Course_Course_buyCourseHourById @"course.buyCourseHourById"
#define YunKeTang_Course_video_reviewConf @"course.reviewConf"






//线下课
#define YunKeTang_LineVideo_lineVideo_getList @"lineVideo.getList"
#define YunKeTang_LineVideo_lineVideo_getInfo @"lineVideo.getInfo"
#define YunKeTang_LineVideo_lineVideo_screen @"lineVideo.screen"
#define YunKeTang_LineVideo_lineVideo_getMyList @"lineVideo.getMyList"
#define YunKeTang_LineVideo_lineVideo_manageMyList @"lineVideo.manageMyList"
#define YunKeTang_LineVideo_lineVideo_confirm @"lineVideo.confirm"
#define YunKeTang_LineVideo_lineVideo_getTeacherList @"lineVideo.getTeacherList"






//讲师
#define YunKeTang_Teacher_teacher_getInfo @"teacher.getInfo"
#define YunKeTang_Teacher_teacher_getList @"teacher.getList"
#define YunKeTang_Teacher_teacher_getCategory @"teacher.getCategory"
#define YunKeTang_Teacher_teacher_getVideoList @"teacher.getVideoList"
#define YunKeTang_Teacher_teacher_getCommentList @"teacher.getCommentList"
#define YunKeTang_Teacher_teacher_addReview @"teacher.addReview"




//机构
#define YunKeTang_School_school_getInfo @"school.getInfo"
#define YunKeTang_School_school_getList @"school.getList"
#define YunKeTang_School_school_getCategory @"school.getCategory"
#define YunKeTang_School_school_apply @"school.apply"
#define YunKeTang_School_school_getgetCouponList @"school.getgetCouponList"
#define YunKeTang_School_school_getCouponList @"school.getCouponList"
#define YunKeTang_School_school_getOrderList @"school.getOrderList"




//资讯
#define YunKeTang_News_news_getCategory @"news.getCategory"
#define YunKeTang_News_news_getList @"news.getList"

//文库
#define YunKeTang_Doc_doc_getList @"doc.getList"
#define YunKeTang_Doc_doc_exchange @"doc.exchange"
#define YunKeTang_Doc_doc_getCategory @"doc.getCategory"



//问答
#define YunKeTang_WenDa_wenda_getList @"wenda.getList"
#define YunKeTang_WenDa_wenda_getCategory @"wenda.getCategory"
#define YunKeTang_WenDa_wenda_doComment @"wenda.doComment"
#define YunKeTang_WenDa_wenda_getInfo @"wenda.getInfo"
#define YunKeTang_WenDa_wenda_release @"wenda.release"
#define YunKeTang_WenDa_wenda_getCategory @"wenda.getCategory"
#define YunKeTang_WenDa_wenda_weekHot @"wenda.weekHot"
#define YunKeTang_WenDa_wenda_gloryList @"wenda.gloryList"
#define YunKeTang_WenDa_wenda_getCommentList @"wenda.getCommentList"
#define YunKeTang_WenDa_wenda_doComment @"wenda.doComment"
#define YunKeTang_WenDa_wenda_search @"wenda.search"



//商城
#define YunKeTang_Goods_goods_getHomeData @"goods.getHomeData"
#define YunKeTang_Goods_goods_getCategory @"goods.getCategory"

#define YunKeTang_Goods_goods_exchange @"goods.exchange"
#define YunKeTang_Goods_goods_buyGoods @"goods.buyGoods"
#define YunKeTang_Goods_goods_credpayConf @"goods.credpayConf"
#define YunKeTang_Goods_goods_comment @"goods.comment"
#define YunKeTang_Goods_goods_getComment @"goods.getComment"
#define YunKeTang_Goods_goods_getList @"goods.getList"




//地址
#define YunKeTang_Address_address_getMyList @"address.getMyList"
#define YunKeTang_Address_address_add @"address.add"
#define YunKeTang_Address_address_set @"address.set"
#define YunKeTang_Address_address_delete @"address.delete"
#define YunKeTang_Address_address_setDefault @"address.setDefault"

//考试
#define YunKeTang_Exams_exams_getMoudles @"exams.getMoudles"
#define YunKeTang_Exams_exams_getCategory @"exams.getCategory"
#define YunKeTang_Exams_exams_getPaperList @"exams.getPaperList"
#define YunKeTang_Exams_exams_getPaperInfo @"exams.getPaperInfo"
#define YunKeTang_Exams_exams_submitExams @"exams.submitExams"
#define YunKeTang_Exams_exams_saveExams @"exams.saveExams"
#define YunKeTang_Exams_exams_getExamsLog @"exams.getExamsLog"
#define YunKeTang_Exams_exams_getCollectList @"exams.getCollectList"
#define YunKeTang_Exams_exams_collect @"exams.collect"
#define YunKeTang_Exams_exams_deleteExamsLog @"exams.deleteExamsLog"
#define YunKeTang_Exams_exams_wrongExams @"exams.wrongExams"
#define YunKeTang_Exams_exams_result @"exams.result"
#define YunKeTang_Exams_exams_rank @"exams.rank"
#define YunKeTang_Exams_exams_wrongData @"exams.wrongData"
#define BUYEXAMS @"exams.buyExams"




//优惠券
#define YunKeTang_Coupon_coupon_getMyCouponList @"coupon.getMyCouponList"
#define YunKeTang_Coupon_coupon_grant @"coupon.grant"
#define YunKeTang_Coupon_coupon_getExchangeCard @"coupon.getExchangeCard"
#define YunKeTang_Coupon_coupon_cancelExchangeCard @"coupon.cancelExchangeCard"
#define YunKeTang_Coupon_coupon_use @"coupon.use"
#define YunKeTang_Coupon_coupon_useVipCard @"coupon.useVipCard"
#define YunKeTang_Coupon_coupon_getList @"coupon.getList"







//我的
#define YunKeTang_User_user_getInfo @"user.getInfo"
#define YunKeTang_User_user_getCount @"user.getCount"
#define YunKeTang_User_user_getUserVip @"user.getUserVip"
#define YunKeTang_User_user_getUserVipList @"user.getUserVipList"
#define YunKeTang_User_user_getNewVipUser @"user.getNewVipUser"
#define YunKeTang_User_user_vipCourse @"user.vipCourse"
#define YunKeTang_User_user_rechargeVip @"user.rechargeVip"
#define YunKeTang_User_user_spilt @"user.spilt"
#define YunKeTang_User_user_getSpiltList @"user.getSpiltList"

#define YunKeTang_User_user_credit @"user.credit"
#define YunKeTang_User_user_getCreditList @"user.getCreditList"

#define YunKeTang_User_user_account @"user.account"
#define YunKeTang_User_user_spiltConfig @"user.spiltConfig"


#define YunKeTang_User_user_rechargeBalance @"user.rechargeBalance"
#define YunKeTang_User_user_balanceConfig @"user.balanceConfig"
#define YunKeTang_User_user_getBalanceList @"user.getBalanceList"
#define YunKeTang_User_user_applyWithdraw @"user.applyWithdraw"
#define YunKeTang_User_user_creditConfig @"user.creditConfig"
#define YunKeTang_User_user_rechargeScore @"user.rechargeScore"

#define YunKeTang_Home_home_feedback @"home.feedback"


#define YunKeTang_Attach_attach_upload @"attach.upload"

#define YunKeTang_User_user_setFace @"user.setFace"
#define YunKeTang_User_user_setInfo @"user.setInfo"
#define YunKeTang_User_user_verifyIPhoneScore @"user.verifyIPhoneScore"




#define YunKeTang_Order_order_getCourseOrderList @"order.getCourseOrderList"
#define YunKeTang_Order_order_getList @"order.getList"
#define YunKeTang_Order_order_cancel @"order.cancel"
#define YunKeTang_Order_order_delete @"order.delete"
#define YunKeTang_Order_order_addFreeOrder @"order.addFreeOrder"
#define YunKeTang_Order_order_pay @"order.pay"
#define YunKeTang_Order_order_refund @"order.refund"
#define YunKeTang_Order_order_refundInfo @"order.refundInfo"
#define YunKeTang_Order_order_getGoodsOrderList @"order.getGoodsOrderList"
#define YunKeTang_Order_order_cancelRefund @"order.cancelRefund"
#define YunKeTang_Order_order_refundConf @"order.refundConf"



#define YunKeTang_User_live_getMyList @"live.getMyList"
#define YunKeTang_User_video_getMyList @"video.getMyList"
#define YunKeTang_User_lineVideo_getMyList @"lineVideo.getMyList"
#define YunKeTang_User_notes_getMyList @"notes.getMyList"
#define YunKeTang_User_notes_getList @"notes.getList"
#define YunKeTang_User_notes_add @"notes.add"



#define YunKeTang_User_video_getCollectList @"video.getCollectList"
#define YunKeTang_User_lineVideo_getCollectList @"lineVideo.getCollectList"
#define YunKeTang_User_user_getCollect @"user.getCollect"
#define YunKeTang_User_user_getShare @"user.getShare"
#define YunKeTang_User_user_getFollow @"user.getFollow"

#define YunKeTang_User_wenda_getMyQuestionList @"wenda.getMyQuestionList"
#define YunKeTang_User_wenda_getMyAnswerList @"wenda.getMyAnswerList"
#define YunKeTang_User_doc_getMyList @"doc.getMyList"
#define YunKeTang_User_school_getMySchoolStatus @"school.getMySchoolStatus"





#define YunKeTang_Message_message_getList @"message.getList"
#define YunKeTang_Message_message_comment @"message.comment"
#define YunKeTang_Message_message_system @"message.system"
#define YunKeTang_Message_message_getInfo @"message.getInfo"
#define YunKeTang_Message_message_reply @"message.reply"
#define YunKeTang_Message_message_send @"message.send"





#define YunKeTang_User_user_getAccount @"user.getAccount"
#define YunKeTang_User_user_recharge @"user.recharge"
#define YunKeTang_User_user_addRecord @"user.addRecord"
#define YunKeTang_User_member @"user.member"
#define YunKeTang_User_qrCode @"user.qrCode"



#define YunKeTang_User_user_followingList @"user.followingList"
#define YunKeTang_User_user_followersList @"user.followersList"

#define YunKeTang_User_user_bindBankCard @"user.bindBankCard"
#define YunKeTang_User_user_unbindBankCard @"user.unbindBankCard"
#define YunKeTang_User_user_bankCardList @"user.bankCardList"
#define YunKeTang_User_user_getBankList @"user.getBankList"






#define YunKeTang_App_Order @"Order"
#define YunKeTang_User_user_getRecordList @"user.getRecordList"
#define YunKeTang_User_user_deleteRecord @"user.deleteRecord"


#define YunKeTang_User_user_follow @"user.follow"
#define YunKeTang_User_user_unfollow @"user.unfollow"
#define YunKeTang_User_user_bind @"user.bind"
#define YunKeTang_User_user_bindDel @"user.bindDel"
#define YunKeTang_User_user_bindData @"user.bindData"





//登录
#define YunKeTang_passport_login @"passport.login"
#define YunKeTang_passport_getRegphoneCode @"passport.getRegphoneCode"
#define YunKeTang_passport_regist @"passport.regist"
#define YunKeTang_passport_loginSync @"passport.loginSync"
#define YunKeTang_passport_savePwd @"passport.savePwd"
#define YunKeTang_passport_doModifyPassword @"passport.doModifyPassword"
#define YunKeTang_passport_phoneGetPwd @"passport.phoneGetPwd"
#define YunKeTang_passport_doFindPasswordByEmail @"passport.doFindPasswordByEmail"
#define YunKeTang_passport_clickRepwdCode @"passport.clickRepwdCode"
#define YunKeTang_passport_registerConf @"passport.registerConf"


//登录改变

#define YunKeTang_sms_getRegphoneCode @"sms.getRegphoneCode"
#define YunKeTang_sms_phoneGetPwd @"sms.phoneGetPwd"


//配置

#define YunKeTang_config_paySwitch @"config.paySwitch"
#define YunKeTang_config_getFaceScene @"config.getFaceScene"
#define YunKeTang_config_getFaceStatus @"config.getFaceStatus"
#define YunKeTang_config_getArea @"config.getArea"
#define YunKeTang_config_getVideoKey @"config.getVideoKey"
#define YunKeTang_config_getMarketStatus @"config.getMarketStatus"
#define YunKeTang_config_freeCourseLoginSwitch @"config.freeCourseLoginSwitch"
#define YunKeTang_config_getAppVersion @"config.getAppVersion"
#define YunKeTang_config_initApp @"config.initApp"





//youtu
#define YunKeTang_YouTu_youtu_isExist @"face.isExist"//@"youtu.isExist"
#define YunKeTang_YouTu_youtu_faceLogin @"face.login"//@"youtu.faceLogin"
#define YunKeTang_YouTu_youtu_faceverify @"face.verify"//@"youtu.faceverify"
#define YunKeTang_YouTu_youtu_createPerson @"face.bind"//@"youtu.createPerson"


//Basic
#define YunKeTang_Basic_Basic_showAbout @"basic.showAbout"
#define YunKeTang_Basic_Basic_single @"basic.single"
#define YunKeTang_Basic_Basic_getGoodsOrderList @"basic.getGoodsOrderList"
#define YunKeTang_Basic_Basic_getThirdServiceUrl @"basic.getThirdServiceUrl"





// 套餐(school_id 可选 机构 id)
#define TAOCAN_List @"album.getList"
#define ComBo_Detail @"album.getInfo"
#define Pay_Combo @"album.buyAlbum"
#define album_getCollectList @"album.getCollectList"
#define album_getCategory @"album.getCategory"
#define album_getCanUseCouponList @"album.getCanUseCouponList"
#define album_addReview @"album.addReview"
#define album_getCommentList @"album.getCommentList"
#define album_getMyList @"album.getMyList"

// 新增获取课时信息接口
#define course_getSectionHour @"course.getSectionHour"
// 班级课购买
#define course_buyClasses @"course.buyClasses"
// 班级科目或者单课时
#define course_buyClassesHourById @"course.buyClassesHourById"
// 班级课收藏列表
#define classes_getCollectList @"classes.getCollectList"
// 我的课程班级课列表
#define classes_getMyList @"classes.getMyList"


// 机构app是否开启
#define config_indexConfig @"config.indexConfig"
#define home_searchSchool @"home.searchSchool"

// 我的提问 type 1 提问 2 回复
#define user_getQuestionList @"user.getQuestionList"
// 我的点评
#define user_getCommentList @"user.getCommentList"

// 讲师认证信息
#define teacher_authInfo @"teacher.authInfo"
// 通过机构获取讲师分类
#define teacher_getCate @"teacher.getCate"
// 讲师认证
#define teacher_doAuth @"teacher.doAuth"
// 取消认证
#define teacher_cancelAuth @"teacher.cancelAuth"
// 讲师认证多张图片一起上传
#define attach_multipleUploads @"attach.multipleUploads"

// 游客模式
#define touriseLogin @"ios.createAccount"
// 绑定同步用户购买记录
#define syncuUserInfo @"ios.syncOrder"
#endif /* Header_h */
