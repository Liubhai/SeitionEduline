//
//  ZFDownloadedCell.h
//  dafengche
//
//  Created by IOS on 16/9/26.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFDownloadManager.h"

@interface ZFDownloadedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
/** 下载信息模型 */
@property (nonatomic, strong) ZFFileModel *fileInfo;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@end
