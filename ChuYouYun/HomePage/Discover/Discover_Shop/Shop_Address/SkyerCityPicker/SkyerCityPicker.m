//
//  SkyerCityPicker.m
//  CityPicker
//
//  Created by odier on 2016/10/29.
//  Copyright © 2016年 Skyer. All rights reserved.
//

#import "SkyerCityPicker.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2
#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

@implementation SkyerCityPicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    if (self = [super init]) {
        [self initCityPickerView];
    }
    return self;
}
- (void)initCityPickerView{
    [self getCityData];
    self.frame=[UIScreen mainScreen].bounds;
    self.backgroundColor=[UIColor clearColor];
    
    //一个选择器
    _cityPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, KScreenHeight-216, KScreenWidth, 216)];
    _cityPicker.delegate=self;
    _cityPicker.dataSource=self;
    [self addSubview:_cityPicker];
    //一个工具栏
    UIView *viewTool=[[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-216-44, KScreenWidth, 44)];
    UIColor *color=[UIColor colorWithRed:230/256.0 green:230/256.0 blue:230/256.0 alpha:1];
    viewTool.backgroundColor=color;
    [self addSubview:viewTool];
    //一个取消按钮
    UIButton *btnCancel=[[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 30)];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnCancel addTarget:self action:@selector(btnCancelAction) forControlEvents:UIControlEventTouchUpInside];
    [viewTool addSubview:btnCancel];
    //一个确定按钮
    UIButton *btnSure=[[UIButton alloc] initWithFrame:CGRectMake(KScreenWidth-45, 5, 40, 30)];
    [btnSure setTitle:@"确定" forState:UIControlStateNormal];
    [btnSure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnSure setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnSure addTarget:self action:@selector(btnSureAction) forControlEvents:UIControlEventTouchUpInside];
    [viewTool addSubview:btnSure];
    //一个显示城市的lab
    _btnSelectShow=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, KScreenWidth-100, 30)];
    _btnSelectShow.text=@"北京市";
    _btnSelectShow.textAlignment=1;
    [viewTool addSubview:_btnSelectShow];
    [self animationWithView:_cityPicker duration:0.5];
    [self showSkyerCityPicker];
}
- (void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [view.layer addAnimation:animation forKey:nil];
    
}
#pragma mark - 数据初始化
- (void)getCityData{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"address" ofType:@"plist"];
    NSDictionary*addressDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    _arrProvince=[addressDic objectForKey:@"address"];
    _arrCity=[[_arrProvince objectAtIndex:0] objectForKey:@"sub"];
    _arrDistrict=[[_arrCity objectAtIndex:0] objectForKey:@"sub"];
    _dicSelectCityAndCityCode=[[NSMutableDictionary alloc] init];
    
    [_dicSelectCityAndCityCode setObject:[[_arrProvince objectAtIndex:0] objectForKey:@"name"] forKey:@"Province"];
    
    [_dicSelectCityAndCityCode setObject:[[_arrCity objectAtIndex:0] objectForKey:@"name"] forKey:@"City"];
    
    [_dicSelectCityAndCityCode setObject:[_arrDistrict objectAtIndex:0] forKey:@"District"];
    
    [_dicSelectCityAndCityCode setObject:[[[[_arrProvince objectAtIndex:0] objectForKey:@"sub"] objectAtIndex:0] objectForKey:@"zipcode"] forKey:@"cityCode"];
    
    
    _btnSelectShow.text=[_dicSelectCityAndCityCode objectForKey:@"City"];
    
}

#pragma mark- 选择器的数据源代理

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {//省
        return [_arrProvince count];
    }else if (component == CITY_COMPONENT) {//市
        return [_arrCity count];
    }else {//区
        return [_arrDistrict count];
    }
}


#pragma mark- 选择器的代理方法
//使用城市的名称作为title
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [[_arrProvince objectAtIndex: row] objectForKey:@"name"];
    }else if (component == CITY_COMPONENT) {
        return [[_arrCity objectAtIndex: row] objectForKey:@"name"];
    }else {
        return [_arrDistrict objectAtIndex: row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        _arrCity=[[_arrProvince objectAtIndex:row] objectForKey:@"sub"];
        //大于0就不是直辖市，而是省份，可以分三组。直辖市就直接把城市数组给区域数组
        if (_arrCity.count>0) {
            _arrDistrict=[[_arrCity objectAtIndex:0] objectForKey:@"sub"];
        }else{
            _arrDistrict=_arrCity;
        }
        
        [_dicSelectCityAndCityCode setObject:[[_arrProvince objectAtIndex:row] objectForKey:@"name"] forKey:@"Province"];
        [_dicSelectCityAndCityCode setObject:[[[[_arrProvince objectAtIndex:row] objectForKey:@"sub"] objectAtIndex:0] objectForKey:@"zipcode"] forKey:@"cityCode"];
        [_dicSelectCityAndCityCode setObject:[[_arrCity objectAtIndex:0] objectForKey:@"name"] forKey:@"City"];
        [_dicSelectCityAndCityCode setObject:[_arrDistrict objectAtIndex:0] forKey:@"District"];
        
        
        [_cityPicker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [_cityPicker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [_cityPicker reloadComponent: CITY_COMPONENT];
        [_cityPicker reloadComponent: DISTRICT_COMPONENT];
    }else if (component == CITY_COMPONENT) {
        if (_arrCity.count>0) {
            _arrDistrict=[[_arrCity objectAtIndex:row] objectForKey:@"sub"];
        }
        
        [_dicSelectCityAndCityCode setObject:[[_arrCity objectAtIndex:row] objectForKey:@"name"] forKey:@"City"];
        [_dicSelectCityAndCityCode setObject:[_arrDistrict objectAtIndex:0] forKey:@"District"];
        [_dicSelectCityAndCityCode setObject:[[_arrCity objectAtIndex:row] objectForKey:@"zipcode"] forKey:@"cityCode"];
        
        [_cityPicker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [_cityPicker reloadComponent: DISTRICT_COMPONENT];
    }else{
        [_dicSelectCityAndCityCode setObject:[_arrDistrict objectAtIndex:row] forKey:@"District"];
    }
    _btnSelectShow.text=[_dicSelectCityAndCityCode objectForKey:@"City"];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return KScreenWidth/3.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *myView;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth/3.0, 30)];
        myView.textAlignment = 1;
        myView.text = [[_arrProvince objectAtIndex:row] objectForKey:@"name"];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth/3.0, 30)];
        myView.textAlignment = 1;
        myView.text = [[_arrCity objectAtIndex:row] objectForKey:@"name"];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth/3.0, 30)];
        myView.textAlignment = 1;
        myView.text = [_arrDistrict objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}
#pragma mark -block获取选择的城市词典
- (void)cityPickerSetSelectCity{
    if (_getSelectCity) {
        _getSelectCity(_dicSelectCityAndCityCode);
    }
}

- (void)cityPikerGetSelectCity:(getSelectCity)getSelectCity{
    _getSelectCity=getSelectCity;
}


- (void)btnCancelAction{
    [self disMissCityPicker];
}
- (void)btnSureAction{
    [self cityPickerSetSelectCity];
    [self disMissCityPicker];
}
- (void)showSkyerCityPicker{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.center = [UIApplication sharedApplication].keyWindow.center;
}
-(void)disMissCityPicker{
    [self removeFromSuperview];
}
@end
