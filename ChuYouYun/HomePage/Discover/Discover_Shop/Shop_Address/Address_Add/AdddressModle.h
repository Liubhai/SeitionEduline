//
//  AdddressModle.h
//  dafengche
//
//  Created by IOS on 16/11/9.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdddressModle : NSObject

//收货地址信息编号
@property (nonatomic, copy) NSString *uid;

//用户UID
@property (nonatomic, copy) NSString *address_id;

//添加时间
@property (nonatomic, copy) NSString *ctime;
//是否设置为默认收货地址  1：是 0：否
@property (nonatomic, copy) NSString *is_default;
//选择的省
@property (nonatomic, copy) NSString *province;
//选择的市
@property (nonatomic, copy) NSString *city;

//选择的地区
@property (nonatomic, copy) NSString *area;
//收货人姓名
@property (nonatomic, copy) NSString *nanme;
//收货人联系电话
@property (nonatomic, copy) NSString *phone;
//详细的地址
@property (nonatomic, copy) NSString *address;


@end
