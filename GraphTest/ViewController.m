//
//  ViewController.m
//  GraphTest
//
//  Created by shenj on 16/8/30.
//  Copyright © 2016年 shenj. All rights reserved.
//
// http://hq.sinajs.cn/wskt?list=sh600893,sh600893_i

#define __urlStr @"http://hq.sinajs.cn/wskt?list=sh600893,sh600893_i"

#import "ViewController.h"
#import "AFNetworking.h"
#import "SCChart.h"

@interface ViewController ()<SCChartDataSource,SCChartDelegate>

@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) SCChart *chartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    for (int i = 0 ; i < 100000000; i++) {
//        @autoreleasepool {
//            NSString *str = [[NSString alloc]initWithFormat:@"hello -%04d",i];
//            str = [str stringByAppendingString:@" - world"];
//            NSLog(@"---");
//        }
//        NSLog(@"autorelease结束");
//    }
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    [self prepareData];
    
//    [self uiConfig];
    
}

-(void)uiConfig{
    
    if (_chartView) {
        [_chartView removeFromSuperview];
        _chartView = nil;
    }
    _chartView = [[SCChart alloc] initwithSCChartDataFrame:self.view.bounds withSource:self
                                                withStyle:SCChartLineStyle];
    [_chartView showInView:self.view];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_chartView addSubview:btn];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
    btn.frame = CGRectMake(250, 60, 80, 35);
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitle:@"切换" forState:UIControlStateNormal];
    
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    
}

-(void)btnAction{
    
    NSLog(@"切换柱状图");
    
}

-(void)prepareData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //必须指定返回结果的类型:data,json,xml
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:__urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /**
         * 打印后台报错信息用
         NSString *result  =[[ NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
         SJLog(@"接受信息---- %@",result);
         */
        
        NSString *result  =[[ NSString alloc] initWithData:(NSData *)responseObject encoding:1];
//        NSLog(@"result -- %@",result);
        
        NSArray *arr = [result componentsSeparatedByString:@","];
        [_dataArray addObject:arr[10]];
//        NSLog(@"dataArr -- %@",_dataArray);
        
        
//        [self performSelector:@selector(prepareData) withObject:nil afterDelay:3];
       
        [self uiConfig];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self prepareData];
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    
}

#pragma mark - @required

//横坐标标题数组
- (NSArray *)SCChart_xLableArray:(SCChart *)chart {
    return [self getXTitles:7];
}

- (NSArray *)getXTitles:(int)num {
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i=0; i<num; i++) {
        NSString * str = [NSString stringWithFormat:@"第%d个指标",i+1];
        [xTitles addObject:str];
    }
    return xTitles;
}

//数值多重数组
- (NSArray *)SCChart_yValueArray:(SCChart *)chart {
    NSMutableArray *chatArr = [[NSMutableArray alloc] init];
    if (_dataArray.count == 0) {
        chatArr = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0"]];
        
    }else if (_dataArray.count == 1){
        chatArr = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",_dataArray[0]]];
        
    }else if (_dataArray.count == 2){
        chatArr = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",_dataArray[0],_dataArray[1]]];
        
    }else if (_dataArray.count == 3){
        chatArr = [NSMutableArray arrayWithArray:@[@"0",@"0",_dataArray[0],_dataArray[1],_dataArray[2]]];
        
    }else if (_dataArray.count == 4){
        chatArr = [NSMutableArray arrayWithArray:@[@"0",_dataArray[0],_dataArray[1],_dataArray[2],_dataArray[3]]];;
        
    }else if (_dataArray.count == 5){
        chatArr = _dataArray;
        
    }else{
        NSArray *arr = [_dataArray subarrayWithRange:NSMakeRange(_dataArray.count-5, 5)];
        [chatArr addObjectsFromArray:arr];
    }
    NSLog(@"dataArr -- %@",chatArr);
    return @[chatArr];
}

#pragma mark - @optional
//颜色数组
- (NSArray *)SCChart_ColorArray:(SCChart *)chart {
    return @[SCBlue];
}

#pragma mark 折线图专享功能
//标记数值区域
- (CGRange)SCChartMarkRangeInLineChart:(SCChart *)chart {
    return CGRangeZero;
}

//显示数值范围
- (CGRange)SCChartChooseRangeInLineChart:(SCChart *)chart{
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)SCChart:(SCChart *)chart ShowHorizonLineAtIndex:(NSInteger)index {
    return YES;
}

//判断显示最大最小值
- (BOOL)SCChart:(SCChart *)chart ShowMaxMinAtIndex:(NSInteger)index {
    return NO;
}


@end
