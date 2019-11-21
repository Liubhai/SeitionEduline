//
//  TKCTUserListHeaderView.m
//  EduClass
//
//  Created by talkcloud on 2018/10/15.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKCTUserListHeaderView.h"
#import "SYG.h"
#define ThemeKP(args) [@"TKUserListView." stringByAppendingString:args]
@interface TKCTUserListHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *equipmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *underplatformLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet UILabel *audioLabel;

@property (weak, nonatomic) IBOutlet UILabel *editLabel;
@property (weak, nonatomic) IBOutlet UILabel *handLabel;
@property (weak, nonatomic) IBOutlet UILabel *bannedLabel;
@property (weak, nonatomic) IBOutlet UILabel *deleteLabel;

@property (nonatomic, strong) NSArray *labelArray;

@property (nonatomic, strong) NSArray *labelTitleArray;

@end

@implementation TKCTUserListHeaderView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.labelArray = @[self.equipmentLabel,self.nickNameLabel,self.underplatformLabel,self.videoLabel,self.audioLabel,self.editLabel,self.handLabel,self.bannedLabel,self.deleteLabel];
    self.labelTitleArray = @[MTLocalized(@"Label.Equipment"),MTLocalized(@"Label.UserNickname"),MTLocalized(@"Label.StepUpAndDown"),MTLocalized(@"Label.Camera"),MTLocalized(@"Label.Microphone"),MTLocalized(@"Label.Authorized"),MTLocalized(@"Label.RaisingHands"),MTLocalized(@"Label.Ban"),MTLocalized(@"Label.Remove")];
    
}

- (void)setTitleHeight:(CGFloat)height{
    
    CGFloat textH = IS_PAD ? 14 : 12;
    
    for (int i = 0; i<self.labelArray.count; i++) {
        UILabel *label = (UILabel *)self.labelArray[i];
        
        label.font = [UIFont systemFontOfSize:textH];
        label.sakura.textColor(ThemeKP(@"userlistTextColor"));
        label.text  = self.labelTitleArray[i];
        
    }
}

@end
