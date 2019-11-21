//
//  PhotosView.h
//  XiaoZhuShou
//
//  Created by 智艺创想 on 15/11/20.
//  Copyright (c) 2015年 skill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosView : UIView

- (void)addImage:(UIImage *)image;

- (NSArray *)totalImages;

- (void)removeImage;

- (void)addImageView:(UIImageView *)imageView;

@end
