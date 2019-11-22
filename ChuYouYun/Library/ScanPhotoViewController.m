//
//  ScanPhotoViewController.m
//  ThinkSNS
//
//  Created by ZhouWeiMing on 14/8/23.
//  Copyright (c) 2014年 zhishi. All rights reserved.
//

#import "ScanPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
//#import "UIImage+WaterMark.h"
#import "UIImage+Util.h"
//#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UIActionSheet+Blocks.h"

@interface ScanPhotoViewController ()

{
//    UIImageView *_ZoomImageView;
}

@end

@implementation ScanPhotoViewController

@synthesize imgArr,index,delegate,isPhoto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.fd_prefersNavigationBarHidden =YES;
    currentIndex = index;
    _titleImage.backgroundColor = BasidColor;
    
    _titleLabel.text = [NSString stringWithFormat:@"%d/%lu",index+1,(unsigned long)[imgArr count]];
    if (isPhoto) {
        _rightButton.hidden = YES;
    }else{
        [_rightButton setImage:Image(@"ico_more") forState:UIControlStateNormal];
        //		[_rightButton setTitle:@"删除" forState:0];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initScrollView];
    imgCount = [imgArr count];
}

-(void)initScrollView{
    
    if (_scrollView) {
        for (UIImageView *imageView in _scrollView.subviews) {
            [imageView removeFromSuperview];
        }
    }else{
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, MACRO_UI_UPHEIGHT, MainScreenWidth+20, MainScreenHeight-(MACRO_UI_UPHEIGHT))];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.tag = 222;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
////        //设置最大伸缩比例
//        _scrollView.maximumZoomScale=2.0;
//        //设置最小伸缩比例
//        _scrollView.minimumZoomScale=0.5;
        
        [self.view addSubview:_scrollView];
    }
    
    _scrollView.contentSize = CGSizeMake((MainScreenWidth+20) * [imgArr count], MainScreenHeight-(MACRO_UI_UPHEIGHT));
    for (int i = 0; i < [imgArr count]; i ++) {
        float imageWidth,imageHeight;
        UIImage *image;
        
        if (isPhoto) {
            ALAsset *asset = [imgArr objectAtIndex:i];
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            //获取资源图片的长宽
            imageHeight = [representation dimensions].height/2;
            imageWidth = [representation dimensions].width/2;
            image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        }else{
            image = [imgArr objectAtIndex:i];
            CGImageRef imageRef = [image CGImage];
            imageWidth = CGImageGetWidth(imageRef)/2;
            imageHeight = CGImageGetHeight(imageRef)/2;
        }
        
        
        CGFloat scalce = imageWidth / imageHeight;
        CGFloat scalcePhoneScreen =  MainScreenWidth / (MainScreenHeight - _titleImage.height);
        
        if (scalce >= scalcePhoneScreen) {
            imageWidth = MainScreenWidth;
            imageHeight = imageWidth / scalce;
        }
        else {
            imageHeight = MainScreenHeight - _titleImage.height;
            imageWidth = imageHeight * scalce;
        }
    
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((MainScreenWidth+20)*i, 0, imageWidth, imageHeight)];
        imageView.center = CGPointMake(MainScreenWidth/2+(MainScreenWidth +20)*i, ((MainScreenHeight-(MACRO_UI_UPHEIGHT))/2));
        
        imageView.image = image;
        imageView.tag = i;
        imageView.contentMode =UIViewContentModeScaleToFill;
        imageView.clipsToBounds =YES;
        [_scrollView addSubview:imageView];
    }
    
//    [_scrollView setMinimumZoomScale:50];//设置最小的缩放大小
//    [_scrollView setZoomScale:50];//设置scrollview的缩放
    _scrollView.contentOffset = CGPointMake((MainScreenWidth+20)*currentIndex, 0);
}


//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    
//    return _ZoomImageView;
//    
//}
//
//
//-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    //当捏或移动时，需要对center重新定义以达到正确显示未知
//    CGFloat xcenter = scrollView.center.x,ycenter = scrollView.center.y;
//    NSLog(@"adjust position,x:%f,y:%f",xcenter,ycenter);
//    xcenter = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2 :xcenter;
//    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
//    [_ZoomImageView setCenter:CGPointMake(xcenter, ycenter)];
//}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int count = scrollView.contentOffset.x/(MainScreenWidth +20);
    
    _titleLabel.text = [NSString stringWithFormat:@"%d/%lu",count+1,(unsigned long)[imgArr count]];
    currentIndex = count;
    
//    for (UIView *view in _scrollView.subviews) {
//        if ([view isKindOfClass:[UIImageView class]]) {
//            if (view.tag == count) {
//                _ZoomImageView = (UIImageView *)view;
//                break;
//            }
//        }
//    }
}

-(void)leftButtonClick:(id)sender
{
    
    if (imgCount!=[imgArr count])
    {
        if (self.delegate &&[self.delegate respondsToSelector:@selector(sendPhotoArr:)])
        {
            NSMutableArray *array = [NSMutableArray array];
            for (int i=0; i<imgArr.count; i++)
            {
                if ([[imgArr objectAtIndex:i] isKindOfClass:[UIImage class]])
                {
                    [array addObject:imgArr[i]];
                }
                else
                {
                    ALAsset *asset = imgArr[i];
                    [array addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
                }
            }
            [self.delegate sendPhotoArr:array];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)rightButtonClick:(id)sender{
    UIActionSheet *actionSheet = [UIActionSheet showInView:self.view withTitle:@"更多操作" cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex==0) {
            [imgArr removeObjectAtIndex:currentIndex];
            if ([imgArr count]==0) {
                [self leftButtonClick:nil];
                return;
            }
            
            int index1;
            if (currentIndex == 0) {
                index1 = 1;
            }else if (currentIndex == [imgArr count]){
                index1 = [imgArr count];
            }else{
                index1 = currentIndex+1;
            }
            currentIndex = index1-1;
            [self initScrollView];
            _titleLabel.text = [NSString stringWithFormat:@"%d/%lu",index1,(unsigned long)[imgArr count]];
        }else if (buttonIndex==10){
            [self initScrollView];
        }
    }];

    
    
//    // herman 打开了水印功能 
//    UIActionSheet *actionSheet = [UIActionSheet showInView:self.view withTitle:@"更多操作" cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@[@"打上水印"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
//        if (buttonIndex==0) {
//            [imgArr removeObjectAtIndex:currentIndex];
//            if ([imgArr count]==0) {
//                [self leftButtonClick:nil];
//                return;
//            }
//            
//            int index1;
//            if (currentIndex == 0) {
//                index1 = 1;
//            }else if (currentIndex == [imgArr count]){
//                index1 = [imgArr count];
//            }else{
//                index1 = currentIndex+1;
//            }
//            currentIndex = index1-1;
//            [self initScrollView];
//            _titleLabel.text = [NSString stringWithFormat:@"%d/%lu",index1,(unsigned long)[imgArr count]];
//        }else if (buttonIndex== 1){
//            UIImage *orangeImg = [imgArr objectAtIndex:currentIndex];
//            CGFloat  nameWidth = [[NSString stringWithFormat:@"@%@",SWUNAME] boundingRectWithSize:CGSizeMake(10000,30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]} context:nil].size.width;
//            UIImage *resultImage = [orangeImg imageWaterMarkWithString:[NSString stringWithFormat:@"@%@",SWUNAME] rect:CGRectMake((orangeImg.size.width-nameWidth)/2.0+15 + 15, orangeImg.size.height-25 - 15, nameWidth, 30) attribute:@{NSFontAttributeName:[UIFont systemFontOfSize:30],NSForegroundColorAttributeName:[UIColor whiteColor]} image:ImageNamed(@"ts_logo") imageRect:CGRectMake((orangeImg.size.width-nameWidth)/2.0-10, orangeImg.size.height-22 - 15, 30, 30) alpha:1];
//            [imgArr replaceObjectAtIndex:currentIndex withObject:resultImage];
//            [self initScrollView];
//        }
//    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
