//
//  TKVideoFunctionView.m
//  EduClassPad
//
//  Created by ifeng on 2017/6/15.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKVideoFunctionView.h"
#import "TKButton.h"
#import "TKEduSessionHandle.h"


#define ThemeKP(args) [@"ClassRoom.TKVideoView." stringByAppendingString:args]

@interface TKVideoFunctionView ()
@property (nonatomic,retain)TKButton *iButton1;
@property (nonatomic,retain)TKButton *iButton2;
@property (nonatomic,retain)TKButton *iButton3;
@property (nonatomic,retain)TKButton *iButton4;
@property (nonatomic,retain)TKButton *iButton5;
@property (nonatomic,retain)TKButton *iButton6;
@property (nonatomic,retain)TKButton *iButton7;// 恢复位置
@property (nonatomic,retain)TKButton *iButton8;// 全部恢复

@property (nonatomic,assign)TKEVideoRole iVideoRole;
@end

@implementation TKVideoFunctionView


-(instancetype)initWithFrame:(CGRect)frame aVideoRole:(TKEVideoRole)aVideoRole aRoomUer:(TKRoomUser*)aRoomUer isSplit:(BOOL)isSplit count:(CGFloat)count{
    
    if (self = [super initWithFrame:frame]) {
        
        _iRoomUer = aRoomUer;
        _iVideoRole =aVideoRole;
        
        CGFloat tHeight = CGRectGetHeight(frame);
        
        //默认按钮个数为0
        CGFloat tPoroFloat = count;
        CGFloat tWidth = (CGRectGetWidth(frame)-20)/tPoroFloat;
       
        _iButton1 = ({//涂鸦授权
        
            TKButton *tButton = [self returninitFrame:CGRectMake(10, 0, tWidth, tHeight) buttonWidth:tWidth tHeight:tHeight imageName:ThemeKP(@"videoPopGraffitiSelectedImage") selectImageName:ThemeKP(@"videoPopGraffitiNomalImage") title:MTLocalized(@"Button.CancelDoodle") selectTitle:MTLocalized(@"Button.AllowDoodle") action:@selector(button1Clicked:) selected:aRoomUer.canDraw];
        
            
            tButton;
        
        });
        
        _iButton2 = ({//上下台控制
            
            TKButton *tButton = [self returninitFrame:CGRectMake(10+tWidth, 0, tWidth, tHeight) buttonWidth:tWidth tHeight:tHeight imageName:ThemeKP(@"icon_control_down") selectImageName:ThemeKP(@"icon_control_up") title:MTLocalized(@"Button.DownPlatform") selectTitle:MTLocalized(@"Button.UpPlatform") action:@selector(button2Clicked:) selected:(aRoomUer.publishState != TKPublishStateNONE)];
            
            
            tButton;
            
        });
        
        if (aRoomUer.disableVideo == NO) {
            _iButton5 = ({//关闭视频
                
                BOOL isSelected = (aRoomUer.publishState == TKPublishStateBOTH) || (aRoomUer.publishState == TKPublishStateVIDEOONLY);
                
                TKButton *tButton = [self returninitFrame:CGRectMake(10+tWidth*3, 0, tWidth, tHeight) buttonWidth:tWidth tHeight:tHeight imageName:ThemeKP(@"icon_control_camera_02") selectImageName:ThemeKP(@"icon_control_camera_01") title:MTLocalized(@"Button.CloseVideo") selectTitle:MTLocalized(@"Button.OpenVideo") action:@selector(button5Clicked:) selected:isSelected];
               
                
                tButton;
                
            });
        }
        
        if (aRoomUer.disableAudio == NO) {
            
            _iButton3 = ({//关闭音频
                
                BOOL isSelected = (aRoomUer.publishState == TKPublishStateBOTH) || (aRoomUer.publishState == TKPublishStateAUDIOONLY);
                
                TKButton *tButton = [self returninitFrame:CGRectMake((aRoomUer.disableVideo?tWidth*1:tWidth*2)+10 , 0, tWidth, tHeight) buttonWidth:tWidth tHeight:tHeight imageName:ThemeKP(@"icon_close_audio") selectImageName:ThemeKP(@"icon_open_audio") title:MTLocalized(@"Button.CloseAudio") selectTitle:MTLocalized(@"Button.OpenAudio") action:@selector(button3Clicked:) selected:isSelected];

                // 不显示关闭视频按钮，减一个位置
                tButton;
                
            });
        }

        _iButton4= ({//发送奖杯
            
            CGFloat x = 0;
            if (aRoomUer.disableAudio == YES) {
                if (aRoomUer.disableVideo == YES) {
                    x = tWidth * 2;
                } else {
                    x = tWidth * 3;
                }
            } else {
                if (aRoomUer.disableVideo == YES) {
                    x = tWidth * 3;
                } else {
                    x = tWidth * 4;
                }
            }
            
            TKButton *tButton = [self returninitFrame:CGRectMake(10+x, 0, tWidth, tHeight) buttonWidth:tWidth tHeight:tHeight imageName:ThemeKP(@"icon_control_gift")
                                      selectImageName:ThemeKP(@"icon_control_gift") title:MTLocalized(@"Button.GiveCup") selectTitle:MTLocalized(@"Button.GiveCup") action:@selector(button4Clicked:) selected:NO];
            
            
            tButton;
            
        });
       
        
        
        _iButton6 = ({//演讲
            
            TKButton *tButton = [self returninitFrame:CGRectMake(10+tWidth*5, 0, tWidth, tHeight) buttonWidth:tWidth tHeight:tHeight imageName:ThemeKP(@"icon_screen_normal") selectImageName:ThemeKP(@"icon_reply_normal_only") title:MTLocalized(@"Button.Speech") selectTitle:MTLocalized(@"Button.Recovery") action:@selector(button6Clicked:) selected:NO];
            
            tButton;
            
        });
        
        _iButton7 = ({//恢复位置
            
            TKButton *tButton = [self returninitFrame:CGRectMake(10+tWidth*6, 0, tWidth, tHeight) buttonWidth:tWidth tHeight:tHeight imageName:ThemeKP(@"tk_reset_mine") selectImageName:ThemeKP(@"tk_reset_mine") title:MTLocalized(@"Button.RestorePosition") selectTitle:MTLocalized(@"Button.RestorePosition") action:@selector(button7Clicked:) selected:NO];
            tButton;
        });
        
        _iButton8 = ({//全部恢复
            
            TKButton *tButton = [self returninitFrame:CGRectMake(10+tWidth*7, 0, tWidth, tHeight) buttonWidth:tWidth tHeight:tHeight imageName:ThemeKP(@"tk_reset_all") selectImageName:ThemeKP(@"tk_reset_all") title:MTLocalized(@"Button.RestoreAll") selectTitle:MTLocalized(@"Button.RestoreAll") action:@selector(button8Clicked:) selected:NO];
            tButton;
        });

        
//        ============ 老师 ===============
        if (aVideoRole == TKEVideoRoleTeacher) {
            
            BOOL isSelected = (aRoomUer.publishState == TKPublishStateBOTH || aRoomUer.publishState == TKPublishStateVIDEOONLY);
            _iButton1 = ({//关闭视频
                
                TKButton *tButton = [self returninitFrame:CGRectMake(10+tWidth, 0, tWidth, tHeight) buttonWidth:tWidth tHeight:tHeight imageName:ThemeKP(@"icon_control_camera_02") selectImageName:ThemeKP(@"icon_control_camera_01") title:MTLocalized(@"Button.CloseVideo") selectTitle:MTLocalized(@"Button.OpenVideo") action:@selector(button1Clicked:) selected:isSelected];
                
                tButton;
            });
            _iButton2 = ({//关闭音频
                
                BOOL isSelected = !(aRoomUer.publishState == TKPublishStateAUDIOONLY || aRoomUer.publishState == TKPublishStateBOTH);
                TKButton *tButton = [self returninitFrame: CGRectMake(10, 0, tWidth, tHeight) buttonWidth:tWidth tHeight:tHeight imageName:ThemeKP(@"icon_open_audio") selectImageName:ThemeKP(@"icon_close_audio") title:MTLocalized(@"Button.OpenAudio") selectTitle:MTLocalized(@"Button.CloseAudio") action:@selector(button2Clicked:) selected:isSelected];
                
                tButton;
            });
            
            [self addSubview:_iButton1];
            [self addSubview:_iButton2];
            
            if (isSplit) {
                _iButton7.frame = CGRectMake(10+tWidth*2, 0, tWidth, tHeight);
                _iButton8.frame = CGRectMake(10+tWidth*3, 0, tWidth, tHeight);
                [self addSubview:_iButton7];
                [self addSubview:_iButton8];
            } else {
                _iButton8.frame = CGRectMake(10+tWidth*2, 0, tWidth, tHeight);
                [self addSubview:_iButton8];
            }

            
            if(tPoroFloat == 3.0)
            {
//                _iButton6.frame = CGRectMake(10+tWidth*2, 0, tWidth, tHeight);
//                [self addSubview:_iButton6];
            }
         
           
        } else if ([aRoomUer.peerID isEqualToString:[TKEduSessionHandle shareInstance].localUser.peerID] && aVideoRole != TKEVideoRoleTeacher) {
            _iButton3.frame = CGRectMake(10, 0, tWidth, tHeight);
            _iButton5.frame = CGRectMake(10+tWidth, 0, tWidth, tHeight);
            [self addSubview:_iButton5];
            [self addSubview:_iButton3];

        } else if (aRoomUer.role == TKUserType_Assistant) {
            _iButton2.frame = CGRectMake(10, 0, tWidth, tHeight);
            _iButton3.frame = CGRectMake(10+tWidth, 0, tWidth, tHeight);
            _iButton5.frame = CGRectMake(10+2*tWidth, 0, tWidth, tHeight);

            [self addSubview:_iButton2];
            [self addSubview:_iButton3];
            [self addSubview:_iButton5];

            if (isSplit) {
                _iButton7.frame = CGRectMake(10+tWidth*3, 0, tWidth, tHeight);
                [self addSubview:_iButton7];
            }

        } else {
            
            [self addSubview:_iButton1];
            [self addSubview:_iButton2];
            [self addSubview:_iButton3];
            [self addSubview:_iButton5];
            [self addSubview:_iButton4];

            if (isSplit) {
                _iButton7.frame = CGRectMake(10+tWidth*5, 0, tWidth, tHeight);
                [self addSubview:_iButton7];
            }
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
        [(id<VideolistProtocol>)_iDelegate videoSmallbutton1:tButton aVideoRole:_iVideoRole];
    }
    
}
-(void)button2Clicked:(UIButton *)tButton{
   
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton2:aVideoRole:)]) {
        [(id<VideolistProtocol>)_iDelegate videoSmallButton2:tButton aVideoRole:_iVideoRole];
    }
    
}
-(void)button3Clicked:(UIButton *)tButton{
   
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton3:aVideoRole:)]) {
        [(id<VideolistProtocol>)_iDelegate videoSmallButton3:tButton aVideoRole:_iVideoRole];
    }
}
-(void)button4Clicked:(UIButton *)tButton{
   
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton4:aVideoRole:)]) {
        [(id<VideolistProtocol>)_iDelegate videoSmallButton4:tButton aVideoRole:_iVideoRole];
    }
    
}
-(void)button5Clicked:(UIButton *)tButton{
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton5:aVideoRole:)]) {
        [(id<VideolistProtocol>)_iDelegate videoSmallButton5:tButton aVideoRole:_iVideoRole];
    }
}
-(void)button6Clicked:(UIButton *)tButton{
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton6:aVideoRole:)]) {
        [(id<VideolistProtocol>)_iDelegate videoSmallButton6:tButton aVideoRole:_iVideoRole];
    }
}

-(void)button7Clicked:(UIButton *)tButton{
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton7:aVideoRole:)]) {
        [(id<VideolistProtocol>)_iDelegate videoSmallButton7:tButton aVideoRole:_iVideoRole];
    }
}
-(void)button8Clicked:(UIButton *)tButton{
    if (_iDelegate && [_iDelegate respondsToSelector:@selector(videoSmallButton8:aVideoRole:)]) {
        [(id<VideolistProtocol>)_iDelegate videoSmallButton8:tButton aVideoRole:_iVideoRole];
    }
}

- (void)setIsSplitScreen:(BOOL)isSplitScreen{
    switch (_iVideoRole) {
        case TKEVideoRoleTeacher:
        {
            _iButton3.selected = isSplitScreen;
            _iButton6.selected = isSplitScreen;
        }
            break;
        case TKEVideoRoleOur:
        case TKEVideoRoleOther:
        {
            _iButton6.selected = isSplitScreen;
        }
            break;
        default:
            break;
    }
}
@end
