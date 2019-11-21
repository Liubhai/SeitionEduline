//
//  TKStudentMessageTableViewCell.h
//  EduClassPad
//
//  Created by ifeng on 2017/6/11.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKChatMessageModel.h"
#import "TKLinkLabel.h"


@interface TKChatMessageTableViewCell : UITableViewCell
@property (nonatomic, strong) TKChatMessageModel *chatModel;
@property (nonatomic, strong) UIButton *iTranslationButton;//翻译按钮
@property (nonatomic, strong) NSMutableArray *urlArray;

@property (nonatomic, strong) UILabel *iNickNameLabel;//用户名
@property (nonatomic, strong) UILabel *iTimeLabel;//时间
@property (nonatomic, strong) UIView *iMessageView;//聊天消息视图

//@property (nonatomic, strong) UILabel *iMessageLabel;//聊天内容
@property (nonatomic, strong) TKLinkLabel *iMessageLabel;//聊天内容

//@property (nonatomic, strong) UIButton *iTranslationButton;//翻译按钮
//@property (nonatomic, copy)   bTranslationButtonClicked iTranslationButtonClicked;
@property (nonatomic, strong) UIView *translationBorderView;// 分割线
@property (nonatomic, strong) UILabel *iMessageTranslationLabel;//翻译内容
@property (nonatomic, assign) TKMessageType iMessageType;//消息类型
@property (nonatomic, strong) NSString *iText;
@property (nonatomic, strong) NSString *iTranslationtext;
@property (nonatomic, strong) NSString *iNickName;
@property (nonatomic, strong) NSString *iTime;
@property (nonatomic, strong) NSString *cString;
+ (CGFloat)heightFromText:(NSString *)text withLimitWidth:(CGFloat)width;
+ (CGSize)sizeFromText:(NSString *)text withLimitHeight:(CGFloat)height Font:(UIFont*)aFont;
+ (CGSize)sizeFromText:(NSString *)text withLimitWidth:(CGFloat)width Font:(UIFont*)aFont;
+ (CGSize)sizeFromAttributedString:(NSString *)text withLimitWidth:(CGFloat)width Font:(UIFont*)aFont;

- (void)resetView;
@end
