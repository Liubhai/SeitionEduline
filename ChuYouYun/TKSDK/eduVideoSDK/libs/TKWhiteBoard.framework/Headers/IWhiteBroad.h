//
//  IWhiteBroad.h
//  emmsdk
//
//  Created by macmini on 16/5/16.
//  Copyright © 2016年 ybx. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol wb_cb < NSObject>
///**
// *  添加文档
// *
// *  @param fileid   文档id
// *  @param filename 文档名
// *  @param url      文档url
// *  @param count    文档页数
// */
//-(void) on_file_add:(int)fileid filename:(NSString*)filename fileurl:(NSString*)url pagecout:(int)count;
///**
// *  删除文档
// *
// *  @param fileid 文档id
// */
//-(void) on_file_del:(int)fileid;
///**
// *  添加Sharp（画笔）
// *
// *  @param fileid 文档id
// *  @param sid    画笔内容id
// *  @param data   画笔内容
// */
//-(void) on_shape_add:(int)fileid shapeid:(NSString*)sid shapedata:(NSData*)data;
///**
// *  删除Sharp（画笔）
// *
// *  @param fileid 文档id
// *  @param sid    画笔内容id
// */
//-(void) on_shape_del:(int)fileid shapeid:(NSString*)sid;
///**
// *  翻页（同步翻页）
// *
// *  @param fileid 文档id
// *  @param page   文档页数
// */
//-(void) on_showpage:(int)fileid pageid:(int)page;
//
//@end
//
//@protocol IWhiteBroad <NSObject>
//@required
///**
// *  设置文档服务器地址url
// *  请在调用 上传文档接口 和 删除文档接口 之前调用此接口 （重要）
// *
// *  @param server   文档服务器地址url
// *  @param meetingID 会议id
// */
//- (void) setdocserver:(NSString *)server meetignID:(int)meetingID;
///**
// *  共享文档, 添加文档
// *
// *  @param fileID   传服务器生成的fileid
// *  @param name     文件名
// *  @param url      服务器地址
// *  @param count    页数
// */
//- (void) addfile:(int)fileid filename:(NSString *)name fileurl:(NSString *)url pagecount:(int)count;
///**
// *  删除文档
// *
// *  @param fileid   传服务器生成的fileid
// */
//- (void) delfile:(int)fileid;
///**
// *  增加sharp（画笔）
// *
// *  @param fileid   文档id  白板为0  具体文档时传服务器生成的fileid
// *  @param sid      描述shapeidid
// *  @param data     打包的数据
// */
//- (void) addshape:(int)fileid shapeid:(NSString *)sid shapedata:(NSData *)data;
///**
// *  删除sharp（画笔）
// *
// *  @param fileid   文档id  白板为0  具体文档时传服务器生成的fileid
// *  @param sid      描述shapeid
// */
//- (void) delshape:(int)fileid shapeid:(NSString *)sid;
///**
// *  同步翻页
// *
// *  @param fileid   传服务器生成的fileid
// *  @param page     显示page的id
// */
//- (void) showpage:(int)fileid pageid:(int)page Local:(BOOL)islocal;
///**
// *  设置 wb_cb 代理对象
// *
// *  @param block    id<wb_cb>的代理对象
// */
//- (void) setcallback:(id<wb_cb>)block;
//
//@end
