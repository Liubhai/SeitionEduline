//
//  LanchAnimationVC.h
//  ThinkSNS（探索版）
//
//  Created by Herman8040 on 2016/10/19.
//  Copyright © 2016年 zhishi. All rights reserved.
//

typedef void(^animationBlock)(BOOL succesed);


#import "BaseViewController.h"

@interface LanchAnimationVC : BaseViewController


@property (nonatomic,copy) animationBlock animationFinished;


@end
