//
//  NSUserDefaults+Data.h
//  MyMoveGird
//
//  Created by luo.h on 15/10/14.
//  Copyright © 2015年 l.h. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Data)

+(void)saveDataWithRootObject:(id)rootObject forKey:(NSString *)key;
-(void)saveDataWithRootObject:(id)rootObject forKey:(NSString *)key;

+(NSArray *)arrayWithKey:(NSString *)key;
-(NSArray *)arrayWithKey:(NSString *)key;

@end
