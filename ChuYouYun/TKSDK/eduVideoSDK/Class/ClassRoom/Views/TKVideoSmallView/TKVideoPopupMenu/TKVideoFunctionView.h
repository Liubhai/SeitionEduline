//
//  TKVideoFunctionView.h
//  EduClassPad
//
//  Created by ifeng on 2017/6/15.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYG.h"


@protocol VideolistProtocol <NSObject>

-(void)videoSmallbutton1:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole;
-(void)videoSmallButton2:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole;
-(void)videoSmallButton3:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole;
-(void)videoSmallButton4:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole;
-(void)videoSmallButton5:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole;
-(void)videoSmallButton6:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole;
-(void)videoSmallButton7:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole;
-(void)videoSmallButton8:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole;


@end
@interface TKVideoFunctionView : UIView

@property (nonatomic, assign) BOOL isSplitScreen;//分屏标识
@property (nonatomic,weak)id<VideolistProtocol>iDelegate;
@property (nonatomic,strong)TKRoomUser *iRoomUer;

-(instancetype)initWithFrame:(CGRect)frame aVideoRole:(TKEVideoRole)aVideoRole aRoomUer:(TKRoomUser*)aRoomUer isSplit:(BOOL)isSplit count:(CGFloat)count;


@end
