//
//  GLTextView.h
//  类的封装
//
//  Created by IOS on 16/6/22.
//  Copyright © 2016年 IOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLTextView : UITextView

/** 占位符 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位符颜色*/
@property (nonatomic, strong) UIColor *placeholderColor;

@end
