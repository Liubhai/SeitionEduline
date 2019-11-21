//
//  Alipay.m
//  iDaoYoo
//
//  Created by ZhiYiForMac on 15/3/14.
//  Copyright (c) 2015年 Johnbenjamin. All rights reserved.
//

#import "Alipay.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
#import "AlixPayResult.h"
#import "AFHTTPRequestOperationManager.h"
#define pKey @"MIICoTAbBgkqhkiG9w0BBQMwDgQIyWaqMoUnJMACAggABIICgAoiwelUqFMAz6mXg7fBucGVBd4JGcK0ryzSUKTIynAog4Vylu1T9XGrfl6k+ckJY/7vxFyIuL3Gfp29W9L4IMyukTkYpueJA7h8c/bHLvIueSKWENNJtov8bD+eWP7ahNMTR+wVcfypYNI2mz7Hmg3sWr5V1kVcyZvWaUiN4lLYRrwcyZitsfz9fqDJInfJnNccvbqgPUd5JPrBAtLM4kFXm7xf8srMzoGFfsmhnVwbtvOoyB4wqZnhl16bonsYdZvWDrSvGQVHC6osQDwMMawyaDaAPmAV9g4fM8pXJSx59w8umzs6/i9PC44qn4wFw87CD/6OhGx/2zrCYsvi6A4dZoJBr0ypaxn+4SOrA7SpTsKbJmrxXrFqfua3T/LLp6Eo0DOEe0vAav9oowkRTlYHkq7yPFdkn4RWe8bUfbrCqNfYuXzPgY+opDbVJScuz1Ujt9jZlGg/RCxPG1kg8p8JtUDhieLC0zVZsHYg84m/rhdpkHOGDot67692QPwWJ0WaDmhjhXxwaoXvNQYQruurCOLF8/YdhL2WPlytW5tSNzqeoVk/msPc+N3J+1gRkNM6Wyi/arovaVMxrPLWDhihCEwv05kj6Gw+5ht8jeQKoABL85ZzAqeba+F3RoWiLtNzuK/zFXdOzKHDHAvK67GvvSs6Pg3bGudlL5iSZJHZ1Umd6FqCTgLx1Rg+KXzAo+v26jxUS+z6IBxESmF3oU2pk5xB59NY776/5G2xNf+++ov5lfiRkLaBWKCSD5uAc1fRV+bVAsJI/amUpSmdvbvgWgGUVz12uomTm4Gjh9txbDerVBJ8JeQCxgBGylRtV4hvI+Rw3SVsqfz7iVdVsRA="

@implementation Alipay

-(id)initWithOrder:(NSString *)order Cname:(NSString *)cname ctitle:(NSString *)ctitle Cprice:(NSString *)cprice
{
    self = [super self];
    if (self) {
        self.sourceStr = order;
        self.orderName = cname;
        self.orderTitle = ctitle;
        self.orderPrice = cprice;
    }
    return self;
}
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [self.sourceStr length];
        NSString *oneStr = [self.sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
-(void)reloadAlipay
{
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088711152676385";
    NSString *seller = @"idaoyoo@gmail.com";
    NSString *privateKey = pKey;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = self.orderTitle; //商品标题
    order.productDescription = self.orderName; //商品描述
    order.amount = [NSString stringWithFormat:@"%@",self.orderPrice]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"iDaoYoo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    

    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
        
    }
}
////wap回调函数
-(void)paymentResult:(NSString *)resultd
{
//    //结果处理
//    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
//    if (result)
//    {
//        NSLog(@"resultd ----------%@",resultd);
//        //        NSLog(@"result.statusCode ---------%d",result.statusCode);
//        
//        
//        
//        
//        
//        if ([resultd intValue] == 9000)
//        {
//            /*
//             *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
//             */
//            
//            //交易成功
//            
//            NSLog(@"交易成功");
//            
//            NSString *loginId = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
//            
//            NSDictionary *dowmCellparameters = @{@"loginid": loginId,@"orderid":_orderId,@"orderstate":@2 };
//            
//            //        NSLog(@"%@",dowmCellparameters);
//            NSLog(@"goodsId ----- %@",_orderId);
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//            
//            NSLog(@"url=====%@",MEMBER_ORDER_FIX_STATE_URL);
//            
//            [manager POST:MEMBER_ORDER_FIX_STATE_URL parameters:dowmCellparameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSLog(@"add2-------%@",responseObject);
//                
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"error----------%@",error);
//                
//            }];
//            
//            
//            
//            
//        }
//        else
//        {
//            //交易失败
//            
//            NSLog(@"----交易失败");
//            
//            
//        }
//    }
//    else
//    {
//        //失败
//    }
//    
}
@end
