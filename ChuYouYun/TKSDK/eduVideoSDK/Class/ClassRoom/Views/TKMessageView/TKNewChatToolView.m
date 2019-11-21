//
//  TKNewChatToolView.m
//  EduClass
//
//  Created by talk on 2018/11/23.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKNewChatToolView.h"

@implementation TKNewChatToolView

- (instancetype)initWithFrame:(CGRect)frame isDistance:(BOOL)isDistance
{
    if (self = [super initWithFrame:frame isDistance:isDistance]) {
        
        self.inputField.layer.borderColor = UIColor.clearColor.CGColor;
        
    }
    
    return self;
}

@end
