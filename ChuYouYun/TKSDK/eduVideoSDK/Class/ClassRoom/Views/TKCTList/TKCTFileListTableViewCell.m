//
//  TKCTFileListTableViewCell.m
//  EduClass
//
//  Created by talkcloud on 2018/10/16.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKCTFileListTableViewCell.h"
#import "TKDocmentDocModel.h"
#import "TKMediaDocModel.h"
#import "TKEduSessionHandle.h"


#define ThemeKP(args) [@"TKDocumentListView." stringByAppendingString:args]

@interface TKCTFileListTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation TKCTFileListTableViewCell
{
    id _model;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 5;
    
    self.backView.sakura.backgroundColor(ThemeKP(@"listBackColor"));
    self.deleteBtn.sakura.image(ThemeKP(@"file_list_delete_new"),UIControlStateNormal);

    self.nameLabel.sakura.textColor(ThemeKP(@"coursewareButtonDefaultColor"));
    
    self.hiddenDeleteBtn = NO;
    [[TKEduSessionHandle shareInstance] addObserver:self forKeyPath:@"iIsPlaying" options:NSKeyValueObservingOptionNew context:nil];
    [self newUI];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"iIsPlaying"]	) {
        
        TKMediaDocModel *tCurrentMediaModel = [TKEduSessionHandle shareInstance].iCurrentMediaDocModel;
        BOOL tIsCurrentDocment =[[TKEduSessionHandle shareInstance]isEqualFileId:_model aSecondModel:tCurrentMediaModel];
		
        if (tIsCurrentDocment) {
            _watchBtn.selected = [TKEduSessionHandle shareInstance].iIsPlaying;
        } else {
            _watchBtn.selected = NO;
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)newUI
{
    self.backView.backgroundColor = UIColor.clearColor;
    self.nameLabel.sakura.textColor(@"TKUserListTableView.coursewareButtonWhiteColor");
}

- (IBAction)watchClick:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(watchFile:aIndexPath:withModel:)]) {
        [self.delegate watchFile:sender aIndexPath:_iIndexPath withModel:_model];
    }
}

- (IBAction)deleteClick:(UIButton *)sender {
    
//    TKAlertView *alert = [[TKAlertView alloc]initForWarningWithTitle:MTLocalized(@"Prompt.prompt") contentText:MTLocalized(@"Prompt.delClassFile") leftTitle:MTLocalized(@"Prompt.Cancel") rightTitle:MTLocalized(@"Prompt.OK")];
//    [alert show];
//    alert.rightBlock = ^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteFile:aIndexPath:withModel:)]) {
            [self.delegate deleteFile:sender aIndexPath:_iIndexPath withModel:_model];
        }
//    };

}

-(void)configaration:(id)aModel withFileListType:(TKFileListType)aFileListType isClassBegin:(BOOL)isClassBegin{
    
    _model = aModel;
    _iFileListType = aFileListType;
    switch (_iFileListType) {
            //视频列表
        case TKFileListTypeAudioAndVideo:
        {
            
            //媒体列表
            _watchBtn.sakura.image(ThemeKP(@"icon_play"),UIControlStateNormal);
            _watchBtn.sakura.image(ThemeKP(@"icon_pause"),UIControlStateSelected);
            
            TKMediaDocModel *tMediaModel =(TKMediaDocModel*) aModel;
            NSString *tTypeString = [TKHelperUtil docmentOrMediaImage:tMediaModel.filetype?tMediaModel.filetype:[tMediaModel.filename pathExtension]];
            
            _iconImageView.sakura.image(tTypeString);
            
            _nameLabel.text = tMediaModel.filename;
            TKMediaDocModel *tCurrentMediaModel = [TKEduSessionHandle shareInstance].iCurrentMediaDocModel;
            NSLog(@"%@",tMediaModel.fileid);
            BOOL tIsCurrentDocment =[[TKEduSessionHandle shareInstance]isEqualFileId:tMediaModel aSecondModel:tCurrentMediaModel];
            if (tIsCurrentDocment) {
                _watchBtn.selected = [TKEduSessionHandle shareInstance].iIsPlaying;
            } else {
                _watchBtn.selected = NO;;
            }
            
            
            
        }
            break;
        case TKFileListTypeDocument:
        {
            //文档列表
            _watchBtn.sakura.image(ThemeKP(@"close_eyes"),UIControlStateNormal);
            _watchBtn.sakura.image(ThemeKP(@"open_eyes"),UIControlStateSelected);
            TKDocmentDocModel *tDocModel =(TKDocmentDocModel*) aModel;
            
            NSString *tTypeString = [TKHelperUtil docmentOrMediaImage:tDocModel.filetype?tDocModel.filetype:[tDocModel.filename pathExtension]];
            
            BOOL tIsCurrentDocment = false;
            if ([tDocModel.fileid isEqual:[TKEduSessionHandle shareInstance].iCurrentDocmentModel.fileid]) {
                tIsCurrentDocment = true;
            }
            
            _watchBtn.selected = tIsCurrentDocment;
            _iconImageView.sakura.image(ThemeKP(tTypeString));
            _nameLabel.text = tDocModel.filename;
            
            //如果是白板需要隐藏掉删除按钮
            if ([tDocModel.filetype isEqualToString:(@"whiteboard")]) {
                _deleteBtn.hidden = YES;
            }else{
                _deleteBtn.hidden =  NO;
            }
        }
            break;
        default:
            break;
    }
    if (!_iconImageView.image) {
        _iconImageView.image = [UIImage imageNamed:@"icon_weizhi"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc
{
    
    @try {
        [[TKEduSessionHandle shareInstance] removeObserver:self forKeyPath:@"iIsPlaying"];

    } @catch (NSException *exception) {
    }
}
@end
