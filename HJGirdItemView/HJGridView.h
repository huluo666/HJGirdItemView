//
//  HLGridView.h
//  MyMoveGird
//
//  Created by luo.h on 15/10/13.
//  Copyright © 2015年 l.h. All rights reserved.
//
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#define kItemsArrayCacheKey @"ItemsArrayCacheKey"

#import <UIKit/UIKit.h>
#import "NSUserDefaults+Data.h"

@interface HJGridView : UIScrollView

@property (nonatomic, strong) NSArray *gridModelsArray;

-(void)savegridModelsArrayWithView;

@end
