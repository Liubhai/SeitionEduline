//
//  PlayBackVC.h
//  NewCCDemo
//
//  Created by cc on 2017/1/9.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayBackVC : UIViewController

-(instancetype)initWithRoomId:(NSString *)roomid WithUserId:(NSString *)userId WithViewerName:(NSString *)name WithToken:(NSString *)token withLiveID:(NSString *)liveID;

@end
