//
//  NSUserDefaults+Data.m
//  MyMoveGird
//
//  Created by luo.h on 15/10/14.
//  Copyright © 2015年 l.h. All rights reserved.
//

#import "NSUserDefaults+Data.h"

@implementation NSUserDefaults (Data)

+(void)saveDataWithRootObject:(id)rootObject forKey:(NSString *)key
{
    return [[self standardUserDefaults]  saveDataWithRootObject:rootObject forKey:key];
}


-(void)saveDataWithRootObject:(id)rootObject forKey:(NSString *)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rootObject];
    [self setObject:data forKey:key];
    [self synchronize];
}


+(NSArray *)arrayWithKey:(NSString *)key
{
    return [[self standardUserDefaults] arrayWithKey:key];
}


-(NSArray *)arrayWithKey:(NSString *)key
{
    //解档取值
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return array;
}



@end
