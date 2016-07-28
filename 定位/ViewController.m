//
//  ViewController.m
//  定位
//
//  Created by yangqinglong on 16/1/13.
//  Copyright © 2016年 yangqinglong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLGeocoder *geoCoder;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *location;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   }

- (IBAction)startDidClicked:(id)sender {
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc]init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
        
        //ios8.0以上
        if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0) {
            [_locationManager requestAlwaysAuthorization];
        }
        
        //开始获取位置
        [_locationManager startUpdatingLocation];
        
        //获取当前时间
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yy/MMM/dd EE aa H:mm:ss";
        NSString *formatDateString = [formatter stringFromDate:nowDate];
        _time.numberOfLines = 0;
        _time.lineBreakMode = NSLineBreakByWordWrapping;
        _time.text = formatDateString;
    }

}
//定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
}
//位置在一直更新
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //暂停位置更新
    [_locationManager stopUpdatingLocation];
    
    //获取最新的location
    CLLocation *newLocation = [locations lastObject];
    
    //将location 反编码
    self.geoCoder = [[CLGeocoder alloc]init];
    [_geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //获取placeMark
        CLPlacemark *placeMark = [placemarks lastObject];
        _location.numberOfLines = 0;
        _location.lineBreakMode =  NSLineBreakByWordWrapping;
        _location.text = placeMark.name;
        NSLog(@"%@",placeMark.name);
    }];
}

@end
