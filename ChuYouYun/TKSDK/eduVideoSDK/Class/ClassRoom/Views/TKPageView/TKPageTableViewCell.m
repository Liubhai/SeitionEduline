//
//  TKPageTableViewCell.m
//  EduClass
//
//  Created by lyy on 2018/5/9.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKPageTableViewCell.h"
#import "SYG.h"


@interface TKPageTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
@implementation TKPageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    // Initialization code
}
- (void)setTheContent:(NSInteger)title lineViewColor:(NSString *)lineViewColor titleLabelColor:(NSString *)titleLabelColor{
    
    self.lineView.sakura.backgroundColor(lineViewColor);
    self.titleLabel.sakura.textColor(titleLabelColor);
    
    NSString *titleText;
    if (title<10) {
        titleText = [NSString stringWithFormat:@"0%zd",title];
        
    }else{
        
        titleText = [NSString stringWithFormat:@"%zd",title];
    }
    
    self.titleLabel.text = titleText;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
