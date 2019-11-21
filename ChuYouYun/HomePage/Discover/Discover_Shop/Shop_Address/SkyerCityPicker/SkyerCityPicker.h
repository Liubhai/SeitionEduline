//
//  SkyerCityPicker.h
//  CityPicker
//
//  Created by odier on 2016/10/29.
//  Copyright © 2016年 Skyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkyerCityPicker : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

typedef void (^getSelectCity) (NSMutableDictionary *dicSelectCity);
@property (nonatomic,weak) getSelectCity getSelectCity;


@property NSArray *arrProvince;
@property NSArray *arrCity;
@property NSArray *arrDistrict;
@property NSMutableDictionary *dicSelectCityAndCityCode;

@property (strong, nonatomic) UIPickerView *cityPicker;
@property (strong, nonatomic) UILabel *btnSelectShow;

/*block获取选择的城市的信息
 */
- (void)cityPikerGetSelectCity:(getSelectCity)getSelectCity;
@end
