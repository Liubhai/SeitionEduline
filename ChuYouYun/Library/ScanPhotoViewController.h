//
//  ScanPhotoViewController.h
//  ThinkSNS（探索版）
//
//  Created by SamWu on 16/3/15.
//  Copyright © 2016年 zhishi. All rights reserved.
//

#import "BaseViewController.h"

@protocol sendPhotoArrDelegate <NSObject>

-(void)sendPhotoArr:(NSArray *)array;

@end

@interface ScanPhotoViewController : BaseViewController<UIScrollViewDelegate,UINavigationBarDelegate,UIActionSheetDelegate>{
	int currentIndex,imgCount;
	UIScrollView *_scrollView;
}
@property(nonatomic,assign)id<sendPhotoArrDelegate>delegate;
@property (nonatomic,retain) NSMutableArray *imgArr;
@property(nonatomic,assign)int index;
@property(nonatomic,assign)BOOL isPhoto;

@end
