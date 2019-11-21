//
//  photoImageView.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/19.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "photoImageView.h"
#import "SYG.h"


@implementation photoImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)addImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [self addSubview:imageView];
}

- (void)addImageView:(UIImageView *)imageView {
    
    [self addSubview:imageView];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat Space = 10;
    NSInteger Num;
    Num = _Num;
    CGFloat imageW = (MainScreenWidth - Space - (Num + 1) * Space) / Num;
    CGFloat imageH = imageW;
    
    NSInteger count = self.subviews.count;
    for (int i = 0 ; i < count; i ++) {
        UIImageView *imageView = self.subviews[i];
        imageView.frame = CGRectMake(Space + Space * (i % Num) + imageW * (i % Num), (imageH + Space) * (i / Num), imageW, imageH);
//        if (count == 1) {//当只有一张图片的时候
//            imageView.frame = CGRectMake(Space, 0, 150, 150);
//        }
    }
    
}

- (NSArray *)totalImages {
    NSMutableArray *images = [NSMutableArray array];
    
    for (UIImageView *imageView in self.subviews ) {
        [images addObject:imageView.image];
    }
    return images;
}

- (void)removeImage {
    for (UIImageView *imageView in self.subviews ) {
        [imageView removeFromSuperview];
    }
    
    
}


@end
