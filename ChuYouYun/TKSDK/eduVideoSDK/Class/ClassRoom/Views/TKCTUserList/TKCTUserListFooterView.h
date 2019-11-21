//
//  TKCTUserListFooterView.h
//  EduClass
//
//  Created by talkcloud on 2018/10/15.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TKCTUserListFooterViewDelegate <NSObject>
- (void)userListJumpPageNum:(int)pageNum;
@end

@interface TKCTUserListFooterView : UIView

@property (nonatomic, weak) id<TKCTUserListFooterViewDelegate> delegate;
@property (nonatomic, copy) void(^nextPage)();

@property (nonatomic, copy) void(^prePage)();

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIButton *preBtn;

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalPage;

@property (weak, nonatomic) IBOutlet UITextField *currentPage;

@property (weak, nonatomic) IBOutlet UIView *currentpageView;


- (void)setCurrentPageNum:(NSInteger)pageNum;
- (void)setTotalNum:(NSInteger)totalNum;
- (void)destory;

@end
