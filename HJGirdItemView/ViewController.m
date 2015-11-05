//
//  ViewController.m
//  HJGirdItemView
//
//  Created by luo.h on 15/11/5.
//  Copyright © 2015年 l.h. All rights reserved.
//

#import "ViewController.h"
#import "HJGridView.h"
#import "HJGridItemModel.h"
#import "NSUserDefaults+Data.h"
#import "MJExtension.h"

@interface ViewController ()

@property(nonatomic,strong)  HJGridView  *homeGridView;

@end

@implementation ViewController


-(HJGridView *)homeGridView
{
    if (!_homeGridView) {
        _homeGridView=[[HJGridView alloc]initWithFrame:CGRectMake(0,50, kScreen_Width,CGRectGetHeight(self.view.bounds))];
        _homeGridView.backgroundColor=[UIColor whiteColor];
    }
    return _homeGridView;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.homeGridView];
    
    [self initDataSouce];
}


-(void)initDataSouce
{
    NSMutableArray *temp = [NSMutableArray array];
    //解档
    NSArray *array=[[NSUserDefaults standardUserDefaults] arrayWithKey:kItemsArrayCacheKey];
    if (array) {
        [temp setArray:array];
    }else{
        NSString *Json_path=[[NSBundle mainBundle] pathForResource:@"DefaultListWebsites" ofType:@"json"];
        NSData *data=[NSData dataWithContentsOfFile:Json_path];
        if (!data) return;
        NSArray *array=[NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingAllowFragments
                                                         error:nil];
        NSLog(@"array===%@",array);
        for (NSDictionary *subDict in array) {
            HJGridItemModel *model=[HJGridItemModel  objectWithKeyValues:subDict];
            [temp addObject:model];
        }
        
        //归档保存
        [NSUserDefaults saveDataWithRootObject:temp forKey:kItemsArrayCacheKey];
    }
    
    self.homeGridView.gridModelsArray = [temp copy];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
