//
//  InstCourseCell.h
//  dafengche
//
//  Created by 智艺创想 on 16/12/4.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstCourseCell : UITableViewCell

@property (nonatomic,strong)UIImageView *ImagV;
@property (nonatomic,strong)UILabel *startTimeLab;
@property (nonatomic,strong)UILabel *startLab;
@property (nonatomic,strong)UILabel *endTimeLab;
@property (nonatomic,strong)UILabel *endLab;
@property (nonatomic,strong)UILabel *lastNumLab;
@property (nonatomic,strong)UILabel *lastLab;
@property (nonatomic,strong)UILabel *lineLab;


- (void)dataWithDic:(NSDictionary *)dict;

@end
