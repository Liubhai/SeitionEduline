//
//  ZFDownloadedCell.m
//  dafengche
//
//  Created by IOS on 16/9/26.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "ZFDownloadedCell.h"

@implementation ZFDownloadedCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setFileInfo:(ZFFileModel *)fileInfo
{
    self.headerImage.image = fileInfo.fileimage;
    _fileInfo = fileInfo;
    NSString *totalSize = [ZFCommonHelper getFileSizeString:fileInfo.fileSize];
    self.fileNameLabel.text = fileInfo.fileName;
    self.fileNameLabel.textColor = [UIColor blackColor];
    NSLog(@"=====%@",fileInfo.fileName);
    self.sizeLabel.text = totalSize;
}

@end
