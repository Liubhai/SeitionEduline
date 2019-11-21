//
//  YunKeTang_HomeCollectionViewCell.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/3/28.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YunKeTang_HomeCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imagePhoto;
@property (nonatomic,strong)UILabel     *title;
@property (nonatomic,strong)UILabel     *price;
@property (strong,nonatomic)UILabel     *person;
@property (strong ,nonatomic)UILabel    *stats;
@property (nonatomic,assign)CGRect      frame;

- (void)dataWithDict:(NSDictionary *)dict;

@end
