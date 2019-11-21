//
//  TKVideoVerticalFunctionView.m
//  EduClass
//
//  Created by lyy on 2018/5/10.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKVideoVerticalFunctionView.h"
#import "TKButton.h"
#import "TKEduSessionHandle.h"


#define ThemeKP(args) [@"ClassRoom.TKVideoView." stringByAppendingString:args]

@interface TKVideoVerticalFunctionView()

@property (nonatomic,retain)TKButton *iButton1;
@property (nonatomic,retain)TKButton *iButton2;
@property (nonatomic,retain)TKButton *iButton3;
@property (nonatomic,retain)TKButton *iButton4;
@property (nonatomic,retain)TKButton *iButton5;
@property (nonatomic,assign)TKEVideoRole iVideoRole;
@end

@implementation TKVideoVerticalFunctionView

//展示从底部向上弹出的UIView（包含遮罩）
-(instancetype)initWithFrame:(CGRect)frame aVideoRole:(TKEVideoRole)aVideoRole aRoomUer:(TKRoomUser*)aRoomUer isSplit:(BOOL)isSplit count:(CGFloat)count{
    
    if (self = [super initWithFrame:frame]) {
        
        _iRoomUer = aRoomUer;
        _iVideoRole =aVideoRole;
        
        
        //默认按钮个数为0
        
        CGFloat tHeight = 69;
        
        CGFloat tWidth = CGRectGetWidth(frame);
        
        _iButton1 = ({//涂鸦授权
            
            TKButton *tButton = [self returninitFrame:CGRectMake(0, 10, tWidth, tHeight) buttonWidth:tWidth tHeight:tHeight imageName:ThemeKP(@"icon_control_tools_02") selectImageName:ThemeKP(@"icon_control_tools_01") title:MTLocalized(@"Button.CancelDoodle") selectTitle:MTLocalized(@"Button.AllowDoodle") action:@selector(button1Clicked:) selected:aRoomUer.canDraw];
            
            tButton;
            
        });
        
        if (aRoomUer.disableVideo == NO) {
            _iButton5 = ({//关闭视频
                
                BOOL isSelected = (aRoomUer.publishState == TKPublishStateBOTH) || (aRoomUer.publishState == TKPublishStateVIDEOONLY);
                
                TKButton *tButton = [self returninitFrame:CGRectMake(0,tHeight*2 , tWidth, tHeight) buttonWidth:tWidth tHeight:tHeight imageName:ThemeKP(@"icon_control_camera_02") selectImageName:ThemeKP(@"icon_control_camera_01") title:MTLocalized(@"Button.CloseVideo") selectTitle:MTLocalized(@"Button.OpenVideo") action:@selector(button5Clicked:) selected:isSelected];
                
                
                tButton;
                
            });
        }
        
        if (aRoomUer.disableAudio == NO) {
            
            _iButton3 = ({//关闭音频
                
                BOOL isSelected = (aRoomUer.publishState == TKPublishStateBOTH) || (aRoomUer.publishState == TKPublishStateAUDIOONLY);
                
                TKButton *tButton = [self returninitFrame:CGRectMake(0 , tHeight, tWidth, tHeight) buttonWidth:tWidth tHeight:tHeight imageName:ThemeKP(@"icon_close_audio") selectImageName:ThemeKP(@"icon_open_audio") title:MTLocalized(@"Button.CloseAudio") selectTitle:MTLocalized(@"Button.OpenAudio") action:@selector(button3Clicked:) selected:isSelected];
                
                
                // 不显示关闭视频按钮，减一个位置
                tButton;
                
            });
        }
        
        _iButton4= ({//发送奖杯
            
            CGFloat y = 0;
            if (aRoomUer.disableAudio == YES) {
                if (aRoomUer.disableVideo == YES) {
                    y = tHeight * 1;
                } else {
                    y = tHeight * 2;
                }
            } else {
                if (aRoomUer.disableVideo == YES) {
                    y = tHeight * 2;
                } else {
                    y = tHeight * 3;
                }
            }
            
            TKButton *tButton = [self returninitFrame:CGRectMake(0, y, tWidth, tHeight) buttonWidth:tWidth tHeight:tHeight imageName:ThemeKP(@"icon_control_gift") selectImageName:ThemeKP(@"icon_control_gift") title:MTLocalized(@"Button.GiveCup") selectTitle:MTLocalized(@"Button.GiveCup") action:@selector(button4Clicked:) selected:NO];
            
            tButton;
            
        });
        
        
        if (aVideoRole == TKEVideoRoleTeacher) {
            // 按钮位置。 音频在上 视频在下
            _iButton1 = ({//关闭视频
                
                BOOL isSelected = (aRoomUer.publishState == TKPublishStateBOTH) || (aRoomUer.publishState == TKPublishStateVIDEOONLY);
                
                TKButton *tButton = [self returninitFrame:CGRectMake(0, tHeight, tWidth, tHeight) buttonWidth:tWidth tHeight:tHeight imageName:ThemeKP(@"icon_control_camera_02") selectImageName:ThemeKP(@"icon_control_camera_01") title:MTLocalized(@"Button.CloseVideo") selectTitle:MTLocalized(@"Button.OpenVideo") action:@selector(button1Clicked:) selected:isSelected];
                
                tButton;
                
            });
            _iButton2 = ({//关闭音频
                
                BOOL isSelected = (aRoomUer.publishState == TKPublishStateBOTH) || (aRoomUer.publishState == TKPublishStateAUDIOONLY);
                
                TKButton *tButton = [self returninitFrame: CGRectMake(0, 0, tWidth, tHeight) buttonWidth:tWidth tHeight:tHeight imageName:ThemeKP(@"icon_close_audio") selectImageName:ThemeKP(@"icon_open_audio") title:MTLocalized(@"Button.CloseAudio") selectTitle:MTLocalized(@"Button.OpenAudio") action:@selector(button2Clicked:) selected:isSelected];
                
                tButton;
                
            });
            
            [self addSubview:_iButton1];
            [self addSubview:_iButton2];
            
            
        } else if ([aRoomUer.peerID isEqualToString:[TKEduSessionHandle shareInstance].localUser.peerID] && aVideoRole != TKEVideoRoleTeacher) {
            _iButton3.frame = CGRectMake(0, 0, tWidth, tHeight);
            _iButton5.frame = CGRectMake(0, tHeight, tWidth, tHeight);
            [self addSubview:_iButton5];
            [self addSubview:_iButton3];
            
        } else if (aRoomUer.role == TKUserType_Assistant) {
            _iButton2.frame = CGRectMake(0, 0, tWidth, tHeight);
            _iButton3.frame = CGRectMake(0, tHeight, tWidth, tHeight);
            _iButton5.frame = CGRectMake(0, 2*tHeight, tWidth, tHeight);
            
            [self addSubview:_iButton2];
            [self addSubview:_iButton3];
            [self addSubview:_iButton5];
            
        } else {
            
            [self addSubview:_iButton1];
            [self addSubview:_iButton2];
            [self addSubview:_iButton3];
            [self addSubview:_iButton5];
            [self addSubview:_iButton4];
            
        }
        
        if ([TKEduSessionHandle shareInstance].isOnlyAudioRoom) {
            _iButton5.hidden = YES;
        }
        
    }
    return self;
}


- (TKButton *)returninitFrame:(CGRect)frame buttonWidth:(CGFloat)tWidth tHeight:(CGFloat)tHeight imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName title:(NSString *)title selectTitle:(NSString *)selectTitle action:(SEL)action  selected:(BOOL)selected{
    
    TKButton *tButton = [TKButton buttonWithType:UIButtonTypeCustom];
    tButton.sakura.image(imageName,UIControlStateNormal);
    [tButton setTitle:title forState:UIControlStateNormal];
    tButton.sakura.image(selectImageName,UIControlStateSelected);
    [tButton setTitle:selectTitle forState:UIControlStateSelected];
    tButton.titleLabel.font = TKFont(9);
    tButton.sakura.titleColor(ThemeKP(@"videoToolTextColor"),UIControlStateNormal);
    
    tButton.titleLabel.textAlignment =NSTextAlignmentCenter;
    //修改部分2
    
    tButton.imageRect = CGRectMake((tWidth-20)/2.0, (tHeight-50)/2.0, 20, 20);
    tButton.titleRect = CGRectMake(0, tHeight-30, tWidth, 20);
    
    tButton.contentMode = UIViewContentModeCenter;
    [tButton addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    tButton.frame = frame;
    tButton.selected = selected;
    return tButton;
    
}

-(void)button1Clicked:(UIButton *)tButton{
    
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallbutton1:aVideoRole:)]) {
        [(id<VideoVlistProtocol>)_iDelegate videoSmallbutton1:tButton aVideoRole:_iVideoRole];
    }
    
}
-(void)button2Clicked:(UIButton *)tButton{
    
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton2:aVideoRole:)]) {
        [(id<VideoVlistProtocol>)_iDelegate videoSmallButton2:tButton aVideoRole:_iVideoRole];
    }
    
}
-(void)button3Clicked:(UIButton *)tButton{
    
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton3:aVideoRole:)]) {
        [(id<VideoVlistProtocol>)_iDelegate videoSmallButton3:tButton aVideoRole:_iVideoRole];
    }
}
-(void)button4Clicked:(UIButton *)tButton{
    
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton4:aVideoRole:)]) {
        [(id<VideoVlistProtocol>)_iDelegate videoSmallButton4:tButton aVideoRole:_iVideoRole];
    }
    
}
-(void)button5Clicked:(UIButton *)tButton{
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton5:aVideoRole:)]) {
        [(id<VideoVlistProtocol>)_iDelegate videoSmallButton5:tButton aVideoRole:_iVideoRole];
    }
}
-(void)button6Clicked:(UIButton *)tButton{
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton6:aVideoRole:)]) {
        [(id<VideoVlistProtocol>)_iDelegate videoSmallButton6:tButton aVideoRole:_iVideoRole];
    }
}


//移除从上向底部弹下去的UIView（包含遮罩）
- (void)dissMissView
{
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         
                     }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
