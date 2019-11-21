//
//  photoImageView.h
//  dafengche
//
//  Created by 智艺创想 on 16/10/19.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface photoImageView : UIView

@property (assign ,nonatomic)NSInteger Num;

- (void)addImage:(UIImage *)image;

- (NSArray *)totalImages;

- (void)removeImage;

- (void)addImageView:(UIImageView *)imageView;

@end
