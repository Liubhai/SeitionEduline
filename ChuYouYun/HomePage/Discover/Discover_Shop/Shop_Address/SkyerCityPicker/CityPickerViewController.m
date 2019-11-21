//
//  CityPickerViewController.m
//  CityPicker
//
//  Created by odier on 2016/10/28.
//  Copyright © 2016年 Skyer. All rights reserved.
//

#import "CityPickerViewController.h"
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2
#define KScreenwidth  [UIScreen mainScreen].bounds.size.width

@interface CityPickerViewController ()

@end

@implementation CityPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getCityData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
    
    
    _btnSelectShow.title=[_dicSelectCityAndCityCode objectForKey:@"City"];
    
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
        return [_arrProvince objectAtIndex: row];
    }else if (component == CITY_COMPONENT) {
        return [_arrCity objectAtIndex: row];
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
    _btnSelectShow.title=[_dicSelectCityAndCityCode objectForKey:@"City"];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return KScreenwidth/3.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, KScreenwidth/3.0, 30)];
        myView.textAlignment = 1;
        myView.text = [[_arrProvince objectAtIndex:row] objectForKey:@"name"];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, KScreenwidth/3.0, 30)];
        myView.textAlignment = 1;
        myView.text = [[_arrCity objectAtIndex:row] objectForKey:@"name"];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, KScreenwidth/3.0, 30)];
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

#pragma mark 取消选择
- (IBAction)btnCancel:(id)sender {
    [self disMissCityPicker];
}
#pragma mark 确定选择
- (IBAction)btnSure:(id)sender {
    [self cityPickerSetSelectCity];
    [self disMissCityPicker];
}

-(void)disMissCityPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
