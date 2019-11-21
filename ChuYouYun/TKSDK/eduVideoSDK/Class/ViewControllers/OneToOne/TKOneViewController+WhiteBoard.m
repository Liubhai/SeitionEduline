//
//  TKOneViewController+WhiteBoard.m
//  EduClass
//
//  Created by maqihan on 2018/11/21.
//  Copyright © 2018 talkcloud. All rights reserved.
//

#import "TKOneViewController+WhiteBoard.h"

@implementation TKOneViewController (WhiteBoard)

//界面更新回调
- (void)boardOnViewStateUpdate:(NSDictionary *)message{
    
    [self.navbarView updateView:message];
    
    if ([message.allKeys containsObject:@"scale"]) {
        // scale 0-3/4.0  1-9/16.0 其余的按 3/4.0 （一对一没有 2）
        CGFloat scale = [[message objectForKey:@"scale"] floatValue];
        CGFloat dpiOld = self.iTKEduWhiteBoardDpi;
        CGFloat dpi;
        if (scale == 1) {
            dpi = 9/16.0;
        } else {
            dpi = 3/4.0;
        }
        self.iTKEduWhiteBoardDpi = dpi;
        if (![TKEduSessionHandle shareInstance].iIsFullState && dpiOld != dpi) {
            [self calculateWhiteBoardVideoViewFrame];
            [self refreshVideoViewFrame];
        }
    }
    
    if ([message.allKeys containsObject:@"loadSuccess"]) {
        [self.iSessionHandle.whiteBoardManager refreshWhiteBoard];
    }
    
    if ([TKWhiteBoardManager shareInstance].nativeWhiteBoardView.fileid.integerValue == 0) {
        return;
    }
    
    NSNumber *prevStep = [[message objectForKey:@"page"] objectForKey:@"prevStep"];
    NSNumber *nextStep = [[message objectForKey:@"page"] objectForKey:@"nextStep"];
    NSNumber *prevPage = [[message objectForKey:@"page"] objectForKey:@"prevPage"];
    NSNumber *nextPage = [[message objectForKey:@"page"] objectForKey:@"nextPage"];
    NSNumber *currentPage = [[message objectForKey:@"page"] objectForKey:@"currentPage"];
    NSNumber *totalPage = [[message objectForKey:@"page"] objectForKey:@"totalPage"];
    
    if (![prevStep isEqual:[NSNull null]]) {
        self.pageControl.leftArrow.enabled = prevPage.boolValue ? : prevStep.boolValue;
    }
    
    if (![nextStep isEqual:[NSNull null]]) {
        self.pageControl.rightArrow.enabled = nextPage.boolValue ? : nextStep.boolValue;
    }
    

    self.pageControl.disenablePaging = ![TKEduSessionHandle shareInstance].iIsCanDraw;
 
//    if ([TKWhiteBoardManager shareInstance].nativeWhiteBoardView.fileid.integerValue == 0) {
//        self.pageControl.leftArrow.enabled = (currentPage.integerValue > 1);
//        if ([TKRoomManager instance].localUser.role == TKUserType_Teacher) {
//            self.pageControl.rightArrow.enabled = YES;
//        } else {
//            self.pageControl.rightArrow.enabled = [currentPage isEqual:totalPage];
//        }
//    }
}

//白板全屏回调
- (void)boardOnFullScreen:(BOOL)isFull {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:sChangeWebPageFullScreen object:@(isFull)];
}

//退出视频标注回调
- (void)boardVideoFlagExit
{
    if (self.iMediaView) {
        [self.iMediaView videoFlagExit];
    }
}

- (void)boardOnFileList:(NSArray*)fileList{
    TKLog(@"------OnFileList:%@ ",fileList);
}

- (BOOL)boardOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(long)ts Data:(NSObject*)data InList:(BOOL)inlist{
    TKLog(@"------WhiteBoardOnRemoteMsg:%@ msgID:%@ ",msgName,msgID);
    return NO;
    
}

- (void)boardOnRemoteMsgList:(NSArray*)list{
    
}

@end
