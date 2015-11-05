//
//  HLGridView.m
//  MyMoveGird
//
//  Created by luo.h on 15/10/13.
//  Copyright © 2015年 l.h. All rights reserved.
//


#define KGridViewPerRowItemCount    3
#define KGridViewColItemNum         4

#define DeleteBtn_TAG           2000
#define APPIcon_Button_TAG      1000

//const NSInteger DeleteBtn_TAG = 2000;
//const NSInteger APPIcon_Button_TAG = 1000;


#import "HJGridView.h"
#import "CustomButtonView.h"

#import "HJGridItemModel.h"
#import "NSUserDefaults+Data.h"

@interface HJGridView ()

@property(nonatomic,strong)  UIButton  *addBtton;

@end


@implementation HJGridView
{
    NSMutableArray *_itemsArray;
    NSMutableArray *_tempArray;

    CGPoint     _lastPoint;
    UIButton   *_placeholderButton;
    
    BOOL  isEditing;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _itemsArray = [NSMutableArray array];
        _placeholderButton = [[UIButton alloc] init];
        self.pagingEnabled=YES;
    }
    return self;
}


#pragma mark - properties

-(void)setGridModelsArray:(NSArray *)gridModelsArray
{
    _gridModelsArray = gridModelsArray;
    [_itemsArray removeAllObjects];//清空可编辑数组
    _tempArray=[NSMutableArray arrayWithArray:gridModelsArray];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//移除所有子视图

    [gridModelsArray enumerateObjectsUsingBlock:^(HJGridItemModel *model, NSUInteger idx, BOOL *stop) {
        
        CustomButtonView *itemButton=[[CustomButtonView alloc]init];
        [itemButton.button setBackgroundImage:[UIImage imageNamed:@"21"] forState:UIControlStateNormal];
        itemButton.button.tag = idx + APPIcon_Button_TAG;
        [itemButton.button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.titleLabel.text=model.WebName;
        
        //长按事件
        UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
        [itemButton addGestureRecognizer:longPressed];        

        [self addSubview:itemButton];
        [self addDelBuuton:itemButton];//删除按钮
        [self addSubview:self.addBtton];//添加按钮

        [_itemsArray addObject:itemButton];
    }];
    
    [self setupSubViewsFrame];
    
}

- (void)btnClick:(UIButton *)sender{

    UIButton *button=(UIButton *)sender;
    UIButton * deleteBtn = (UIButton *)[button.superview viewWithTag:DeleteBtn_TAG];
    if (deleteBtn.hidden!=YES) {
        [self hiddenBtn:YES];
        [self savegridModelsArrayWithView];//保存数组
        return;
    }
 
    HJGridItemModel *model=_gridModelsArray[button.tag-APPIcon_Button_TAG];
    NSLog(@"button==%ld==title=%@---%@",(long)button.tag,button.currentTitle,_gridModelsArray[button.tag-APPIcon_Button_TAG]);
    NSLog(@"model==%@",model);
}




-(void)addDelBuuton:(CustomButtonView *)btn
{
    UIButton *deleteBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame=CGRectMake(0, 0, 25, 25);
    [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    deleteBtn.hidden=YES;
    deleteBtn.tag = DeleteBtn_TAG;
    [deleteBtn addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchDown];
    [btn addSubview:deleteBtn];
}

/**
 *  根据tag取值保存
 */
-(void)savegridModelsArrayWithView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSMutableArray *mArray=[NSMutableArray array];
        for (CustomButtonView *btn in _itemsArray) {
            [mArray addObject:_gridModelsArray[btn.button.tag-APPIcon_Button_TAG]];
        }
        //归档保存
        [NSUserDefaults saveDataWithRootObject:mArray forKey:kItemsArrayCacheKey];
    });
}


-(void)deleteButtonClick:(UIButton *)sender
{
        [_itemsArray removeObject:sender.superview];
    
        [sender.superview removeFromSuperview];
        [UIView animateWithDuration:0.4 animations:^{
            [self setupSubViewsFrame];
        }];

}

-(void)reSetScrollViewContentSize
{
    CGFloat KWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger PageSizeNum=KGridViewPerRowItemCount*KGridViewColItemNum;
    NSInteger totalPageNum = (self.gridModelsArray.count  + PageSizeNum  - 1) / PageSizeNum;
    self.contentSize = CGSizeMake(KWidth*totalPageNum,200);
}


-(void)hiddenBtn:(BOOL)hidden
{
    self.addBtton.hidden=!hidden;
    
    for (UIButton *btn in self.subviews) {
        UIButton * deleteBtn = (UIButton *)[btn viewWithTag:DeleteBtn_TAG];
        deleteBtn.hidden=hidden;
        if (hidden) {
            [btn.layer removeAnimationForKey:@"transform.rotation.z"];
        }else{
            [self addannimation:btn];
        }
    }
}


-(void)addannimation:(UIButton *)sender
{
    CABasicAnimation * vibrateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    vibrateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    vibrateAnimation.fromValue = @(- M_PI / 96);
    vibrateAnimation.toValue = @( M_PI / 96);
    vibrateAnimation.autoreverses = YES;
    vibrateAnimation.duration = 0.1;
    vibrateAnimation.repeatCount = CGFLOAT_MAX;
    [sender.layer addAnimation:vibrateAnimation forKey:@"transform.rotation.z"];
}

- (void)buttonLongPressed:(UILongPressGestureRecognizer *)longPressed
{
    CGPoint point = [longPressed locationInView:self];
    if (longPressed.state == UIGestureRecognizerStateBegan) {

        [self hiddenBtn:NO];//显示删除按钮
        
        longPressed.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
        long index = [_itemsArray indexOfObject:longPressed.view];
        [_itemsArray  removeObject:longPressed.view];
        [_itemsArray  insertObject:_placeholderButton atIndex:index];
        _lastPoint = point;
        [self bringSubviewToFront:longPressed.view];
    }else if (longPressed.state == UIGestureRecognizerStateChanged ){
        
        CGRect temp = longPressed.view.frame;
        temp.origin.x += point.x - _lastPoint.x;
        temp.origin.y += point.y - _lastPoint.y;
        longPressed.view.frame = temp;
        _lastPoint = point;
        NSLog(@"_lastPointX==%f",point.x);
        //移动翻页
        NSInteger page = longPressed.view.center.x/self.frame.size.width;
        [self scrollToPage:page];
        
        [_itemsArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
            if (CGRectContainsPoint(button.frame, point) && button != longPressed.view) {
                [_itemsArray removeObject:_placeholderButton];
                [_itemsArray insertObject:_placeholderButton atIndex:idx];
                *stop = YES;
                
                [UIView animateWithDuration:0.5 animations:^{
                    [self setupSubViewsFrame];
                }];
            }
            
        }];
        
    }else  if (longPressed.state == UIGestureRecognizerStateEnded) {
        long index = [_itemsArray indexOfObject:_placeholderButton];
        [_itemsArray removeObject:_placeholderButton];
        [_itemsArray insertObject:longPressed.view atIndex:index];
        
        [UIView animateWithDuration:0.4 animations:^{
            longPressed.view.transform = CGAffineTransformIdentity;
            [self setupSubViewsFrame];
        } completion:^(BOOL finished) {
       
        }];
    }
}


//移动翻页
-(void)scrollToPage:(NSInteger)pageIndex
{
    CGFloat offsetX = pageIndex* self.frame.size.width;
    CGPoint offset = CGPointMake(offsetX,0);
    [UIView animateWithDuration:0.5 animations:^{
        [self setContentOffset:offset animated:YES];
    } completion:^(BOOL finished) {
        
    }];
}


- (void)deleteView:(UIView *)view
{
    [_itemsArray removeObject:view];
    [view removeFromSuperview];
    [UIView animateWithDuration:0.4 animations:^{
        [self setupSubViewsFrame];
    }];
}


- (void)setupSubViewsFrame
{
    CGFloat btnWidth=kScreen_Width/KGridViewPerRowItemCount-30;
    [_itemsArray enumerateObjectsUsingBlock:^(UIView *item, NSUInteger idx, BOOL *stop) {
        
        item.frame=[self calFrameWithRowCount:KGridViewPerRowItemCount colCount:KGridViewColItemNum btnW:btnWidth btnH:btnWidth+20 idx:idx];
        if (idx == (_itemsArray.count-1)) {
            NSInteger    allPageNum= (idx+1)/(KGridViewPerRowItemCount*KGridViewColItemNum)+1;//总页数
            self.contentSize = CGSizeMake(allPageNum* kScreen_Width, 0);
            CGRect  frame=[self calFrameWithRowCount:KGridViewPerRowItemCount colCount:KGridViewColItemNum btnW:btnWidth btnH:btnWidth+20 idx:idx+1];
            self.addBtton.frame=CGRectMake(frame.origin.x, frame.origin.y+10, btnWidth, btnWidth);
        }
    }];
}



#pragma -mark 私有方法
//顶部边距
static const CGFloat topInset = 12.f;

/**
 *  计算view坐标
 *
 *  @param rowCount 每行个数
 *  @param btnH     宽度
 *  @param btnW     高度
 *  @param idx      索引值
 *
 *  @return frame
 */
-(CGRect)calFrameWithRowCount:(NSUInteger)rowCount colCount:(NSInteger)colCount btnW:(CGFloat)btnW  btnH:(CGFloat)btnH idx:(NSUInteger)idx{
    
    CGFloat     icon_SpaceInset=(kScreen_Width-btnW*rowCount)/(rowCount+1);//间隙
    NSInteger   pageNumCount=rowCount*colCount;//每页个数
    NSInteger   page=idx/pageNumCount;  //页码
    
    NSUInteger    row=(idx%pageNumCount)%rowCount;//行
    NSUInteger    col = (idx%pageNumCount)/rowCount;;//列
    
    CGFloat btnX = page*kScreen_Width+row*(btnW+icon_SpaceInset)+icon_SpaceInset;
    CGFloat btnY = col * (btnH +topInset)+ topInset;
    CGRect frame = CGRectMake(btnX, btnY, btnW, btnH);
    return frame;
}



#pragma mark - scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

}


#pragma init UI
-(UIButton *)addBtton
{
    if (!_addBtton) {
        _addBtton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtton setTitle:@"+" forState:UIControlStateNormal];
        [_addBtton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _addBtton.backgroundColor=[UIColor orangeColor];
        [_addBtton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtton;
}

-(void)addButtonClick:(UIButton*)sender
{
    NSLog(@"添加按钮Click");
}



@end
