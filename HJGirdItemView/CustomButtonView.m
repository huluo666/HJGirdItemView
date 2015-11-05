//
//  CustomButton.m
//  UIButtonCenterTitleAndImage
//
//  Created by luo.h on 15/10/17.
//  Copyright © 2015年 qiwang. All rights reserved.
//

#import "CustomButtonView.h"


@interface CustomButtonView ()

@end

@implementation CustomButtonView


-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor=[UIColor clearColor];
        
        [self addSubview:self.button];
        [self addSubview:self.titleLabel];
    }
    return self;
}



-(void)layoutSubviews
{
    self.button.frame=CGRectMake(5, 5, CGRectGetWidth(self.frame)-10, CGRectGetWidth(self.frame)-10);
    self.titleLabel.frame=CGRectMake(0,CGRectGetMaxY(self.button.frame)+5, CGRectGetWidth(self.frame),CGRectGetHeight(self.frame)-CGRectGetMaxY(self.button.frame)-5);
}


-(UIButton *)button
{
    if (!_button) {
        _button=[UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundImage:[UIImage imageNamed:@"default_favicon_small"] forState:UIControlStateNormal];
    }
    return _button;
}


-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.font=[UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor=[UIColor grayColor];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.frame=CGRectZero;
        _titleLabel.text=@"网址";
    }
    return _titleLabel;
}



@end
