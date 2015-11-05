//
//  HLGridItemModel.m
//  MyMoveGird
//
//  Created by luo.h on 15/10/13.
//  Copyright © 2015年 l.h. All rights reserved.
//

#import "HJGridItemModel.h"

@implementation HJGridItemModel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.WebUrl = [aDecoder decodeObjectForKey:@"WebUrl"];
        self.WebName     = [aDecoder decodeObjectForKey:@"WebName"];
        self.webSiteIcon=[aDecoder decodeObjectForKey:@"webSiteIcon"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.WebUrl    forKey:@"WebUrl"];
    [aCoder encodeObject:self.WebName        forKey:@"WebName"];
    [aCoder encodeObject:self.webSiteIcon        forKey:@"webSiteIcon"];
}



@end
