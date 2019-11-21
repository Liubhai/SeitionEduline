//
//  BRPlayM3u8VideoViewController.h
//  M3U8DownLoadTest
//
//  Created by git burning on 2019/6/18.
//  Copyright © 2019 controling. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BRPlayM3u8VideoViewController : UIViewController
@property (nonatomic ,strong) NSURL *playUrl;
@property (nonatomic, copy)  NSString *filePath;
@end

NS_ASSUME_NONNULL_END
