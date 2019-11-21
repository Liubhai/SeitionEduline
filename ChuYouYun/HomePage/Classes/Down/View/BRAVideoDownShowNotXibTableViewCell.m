//
//  BRAVideoDownShowNotXibTableViewCell.m
//  YunKeTang
//
//  Created by git burning on 2019/6/16.
//  Copyright © 2019 ZhiYiForMac. All rights reserved.
//

#import "BRAVideoDownShowNotXibTableViewCell.h"
#import "HWCircleView.h"
#import "Masonry.h"

@interface BRAVideoDownShowNotXibTableViewCell()
@property (nonatomic, strong) HWCircleView *circleProgressView;
@end
@implementation BRAVideoDownShowNotXibTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)br_updateProgress:(float)progress{
    if (progress >= 0) {
        _circleProgressView.hidden = NO;
        _circleProgressView.progress = MIN(progress, 1);
        _mStatusLabel.hidden = YES;
    }
    else{
        _circleProgressView.hidden = YES;
        _mStatusLabel.hidden = NO;
    }
}
- (void)br_selectedDownFile{
    if (self.br_selectedBlock) {
        self.br_selectedBlock(self);
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    CGRect progressFrame = self.circleProgressView.frame;
    progressFrame.origin.x = self.bounds.size.width - progressFrame.size.width - 20;
    progressFrame.origin.y = (self.bounds.size.height - progressFrame.size.height) / 2.0;
    self.circleProgressView.frame = progressFrame;
//    _circleProgressView.center = _mStatusLabel.center;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        
        self.nNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.nNameLabel];
        [self.nNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(12));
            make.centerY.equalTo(@(25));
        }];
        self.nNameLabel.font = [UIFont systemFontOfSize:15];
        self.mStatusLabel = [UILabel new];
        [self.contentView addSubview:self.mStatusLabel];
        [self.mStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.equalTo(@(25));
            make.size.mas_equalTo(CGSizeMake(50, 30));
            make.left.equalTo(self.nNameLabel.mas_right).offset(5);
        }];
        self.mStatusLabel.layer.cornerRadius = 5.0;
        self.mStatusLabel.clipsToBounds = YES;
        self.mStatusLabel.layer.borderWidth = 1;
        self.mStatusLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.mStatusLabel.textAlignment = NSTextAlignmentCenter;
        self.mStatusLabel.font = [UIFont systemFontOfSize:13];
        self.mStatusLabel.textColor = [UIColor darkGrayColor];
        _circleProgressView = [[HWCircleView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _circleProgressView.cLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_circleProgressView];
        _circleProgressView.hidden = YES;
        _mStatusLabel.text = @"下载";
        _circleProgressView.userInteractionEnabled = NO;
        _mStatusLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(br_selectedDownFile)];
        [_mStatusLabel addGestureRecognizer:tap];
    }
    return self;
    
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier isClassNew:(BOOL)isClassNew cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _isClassNew = isClassNew;
        _cellSection = cellSection;
        _cellRow = cellRow;
        self.selectionStyle = 0;
        
        self.nNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, MainScreenWidth - 12 - 50 - 17, 50 * WideEachUnit)];
        [self addSubview:self.nNameLabel];
        if (_isClassNew) {
            _nNameLabel.frame = CGRectMake(12, 0, MainScreenWidth - 12 - 50 - 17, 50 * WideEachUnit);
        } else {
            _nNameLabel.frame = CGRectMake(22, 0, MainScreenWidth - 22 - 50 - 17, 50 * WideEachUnit);
        }
        self.nNameLabel.font = [UIFont systemFontOfSize:15];
        self.mStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 12 - 50, 0, 50, 30)];
        _mStatusLabel.centerY = _nNameLabel.centerY;
        [self addSubview:self.mStatusLabel];
        self.mStatusLabel.layer.cornerRadius = 5.0;
        self.mStatusLabel.clipsToBounds = YES;
        self.mStatusLabel.layer.borderWidth = 1;
        self.mStatusLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.mStatusLabel.textAlignment = NSTextAlignmentCenter;
        self.mStatusLabel.font = [UIFont systemFontOfSize:13];
        self.mStatusLabel.textColor = [UIColor darkGrayColor];
        _circleProgressView = [[HWCircleView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _circleProgressView.cLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_circleProgressView];
        _circleProgressView.hidden = YES;
        _mStatusLabel.text = @"下载";
        _circleProgressView.userInteractionEnabled = NO;
        _mStatusLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(br_selectedDownFile)];
        [_mStatusLabel addGestureRecognizer:tap];
        
        if (_isClassNew) {
            _mStatusLabel.hidden = YES;
            _cellTableViewSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, MainScreenWidth, 0.5)];
            _cellTableViewSpace.backgroundColor = RGBHex(0xEEEEEE);
            [self addSubview:_cellTableViewSpace];
            _dataSource = [NSMutableArray new];
            _cellTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50 * WideEachUnit, MainScreenWidth, 1)];
            _cellTableView.dataSource = self;
            _cellTableView.delegate = self;
            _cellTableView.showsVerticalScrollIndicator = NO;
            _cellTableView.showsHorizontalScrollIndicator = NO;
            _cellTableView.bounces = NO;
            _cellTableView.rowHeight = 50 * WideEachUnit;
            [self addSubview:_cellTableView];
        }
    }
    return self;
}

- (void)setClassCourseDownListCellInfo:(NSDictionary *)cellInfo downLoadMutableDict:(nonnull NSMutableDictionary *)dict {
    if (_isClassNew) {
        _downLoadMutableDict = dict;
        [_cellTableView setHeight:[[cellInfo objectForKey:@"child"] count] * 50 *WideEachUnit];
        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:[cellInfo objectForKey:@"child"]];
        [_cellTableView reloadData];
        _mStatusLabel.hidden = YES;
    } else {
        _nNameLabel.text = cellInfo[@"title"];
        _mStatusLabel.hidden = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuse = @"classnewDown";
    BRAVideoDownShowNotXibTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuse];
    if (!cell) {
        cell = [[BRAVideoDownShowNotXibTableViewCell alloc] initWithReuseIdentifier:cellReuse isClassNew:NO cellSection:0 cellRow:0];
    }
    NSDictionary *dic = [_dataSource objectAtIndex:indexPath.row];
    NSString *id_str = dic[@"id"];
    [cell setClassCourseDownListCellInfo:dic downLoadMutableDict:_downLoadMutableDict];
    
    NSInteger type = [_downLoadMutableDict[id_str] integerValue];
    if (type == 3) {
        [cell br_updateProgress:-1];
        cell.mStatusLabel.text = @"已下载";
        
    }
    cell.br_selectedBlock = ^(BRAVideoDownShowNotXibTableViewCell * _Nonnull cell1) {
        NSIndexPath *selectedIndex = [tableView indexPathForCell:cell1];
        NSDictionary *a_info_dict = _dataSource[selectedIndex.row];
        if (_delegate && [_delegate respondsToSelector:@selector(downloadSelected:currentCell:)]) {
            [_delegate downloadSelected:a_info_dict currentCell:cell1];
        }
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_cellTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(BRAVideoDownShowNotXibTableViewCellSelected:cellSection:cellRow:classCellRow:)]) {
        [_delegate BRAVideoDownShowNotXibTableViewCellSelected:[_dataSource objectAtIndex:indexPath.row] cellSection:_cellSection cellRow:_cellRow classCellRow:indexPath.row];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
