//
//  TKVideoVerticalFunctionView.h
//  EduClass
//
//  Created by lyy on 2018/5/10.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKVideoPopupMenu.h"


@protocol VideoVlistProtocol <NSObject>


-(void)videoSmallbutton1:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole;
-(void)videoSmallButton2:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole;
-(void)videoSmallButton3:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole;
-(void)videoSmallButton4:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole;
-(void)videoSmallButton5:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole;
-(void)videoSmallButton6:(UIButton *)aButton aVideoRole:(TKEVideoRole)aVideoRole;


@end
@interface TKVideoVerticalFunctionView : UIView

@property (nonatomic, assign) BOOL isSplitScreen;//分屏标识
@property (nonatomic,weak)id<VideoVlistProtocol>iDelegate;
@property (nonatomic,strong)TKRoomUser *iRoomUer;

-(instancetype)initWithFrame:(CGRect)frame aVideoRole:(TKEVideoRole)aVideoRole aRoomUer:(TKRoomUser*)aRoomUer isSplit:(BOOL)isSplit count:(CGFloat)count;


@end
