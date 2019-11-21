//
//  Good_ClassCatalogTableViewCell.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/11.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAProgressView.h"

@protocol Good_ClassCatalogTableViewCellDelegate <NSObject>

- (void)classCourseCellTableViewCellSelected:(NSDictionary *)classCourseCellDict cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow classCellRow:(NSInteger)classCellRow;

@end

@interface Good_ClassCatalogTableViewCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) id<Good_ClassCatalogTableViewCellDelegate> delegate;
@property (strong ,nonatomic)UIImageView      *lockImageView;
@property (strong ,nonatomic)UIImageView      *palyImage;
@property (strong ,nonatomic)UILabel          *title;
@property (strong ,nonatomic)UILabel          *time;
@property (strong ,nonatomic)UIButton         *isLookButton;
@property (strong ,nonatomic)UIButton         *downButton;
@property (strong ,nonatomic)UILabel          *size;
@property (strong ,nonatomic)UILabel          *freeLabel;
@property (strong ,nonatomic)UAProgressView   *progressView;

//课时解锁
@property (strong ,nonatomic)NSString         *buyString;
@property (strong ,nonatomic)NSDictionary     *cellDict;
@property (strong ,nonatomic)NSDictionary     *liveInfo;

@property (strong, nonatomic) UITableView *cellTableView;
@property (assign, nonatomic) BOOL isClassNew;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIView *cellTableViewSpace;
@property (assign, nonatomic) NSInteger cellRow;
@property (assign, nonatomic) NSInteger cellSection;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier isClassNew:(BOOL)isClassNew cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow;
- (void)dataSourceWithDict:(NSDictionary *)dict withBuyString:(NSString *)buyString WithLiveInfo:(NSDictionary *)liveInfo;
- (void)dataSourceWithDict:(NSDictionary *)dict withType:(NSString *)type;
- (void)dataSourceWithDict:(NSDictionary *)dict withType:(NSString *)type withProgress:(CGFloat)progress;

@end
