//
//  ClassMainViewController.h
//  YunKeTang
//
//  Created by 刘邦海 on 2019/7/8.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "BaseViewController.h"

@interface ClassMainViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (strong ,nonatomic)NSString *cate_ID;//总分类跳过来的
@property (strong ,nonatomic)NSString *screeningStr;

@end
