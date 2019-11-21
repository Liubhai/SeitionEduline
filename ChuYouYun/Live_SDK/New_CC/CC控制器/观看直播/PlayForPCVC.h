//
//  PlayForPCVC.h
//  NewCCDemo
//
//  Created by cc on 2016/12/27.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayForPCVC : UIViewController

-(instancetype)initWithLeftLabelText:(NSString *)leftLabelText ;
-(instancetype)initWithRoomId:(NSString *)roomid WithUserId:(NSString *)userId WithViewerName:(NSString *)name WithToken:(NSString *)token;


@end
