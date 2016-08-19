//
//  EditingView.m
//  仿网易编辑栏目
//
//  Created by 李海龙 on 16/8/17.
//  Copyright © 2016年 shadow. All rights reserved.
//

#import "EditingView.h"

#define kAnimationDuration (0.35f)
#define kScaleFactory (1.25f)

#define kWidth    60   // 子view的宽度
#define kHeight   30   // 子view的高度
#define kColumns  4    // 显示的列数

#define kEditButttonTag     1100
#define kXButtonTag         1200

@interface EditingView (){
    float kHorizontalSpace;
    float kVerticalSpace;
    BOOL  isEditStatus;
    float editViewHeight;
}
@property (nonatomic, retain) NSMutableArray *editViewsArray;
@property (nonatomic, assign) UIView *selectedView;
@property (nonatomic, assign) CGPoint selectedViewOriginCenter;
@property (nonatomic, assign) CGPoint offset;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end


@implementation EditingView

-(void)loadData:(NSArray *)dataArray{
    _selectedViewOriginCenter = CGPointZero;
    _offset = CGPointZero;
    _dataArray = [[NSMutableArray alloc] initWithArray:dataArray];
    _editViewsArray = [NSMutableArray new];
    editViewHeight = 0;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
    
    kHorizontalSpace = self.bounds.size.width/8.;
    kVerticalSpace = 1/2. *kHeight + 1/4. *kHeight ;
    
    NSInteger count = _dataArray.count;
    for (int index = 0; index<count; index++) {
        NSInteger rowIndex = index / 4;
        NSInteger columnsIndex = index % 4;
        CGPoint center = CGPointMake(columnsIndex*2*kHorizontalSpace +kHorizontalSpace, rowIndex*2*kVerticalSpace + kVerticalSpace);
        [self addEditView:center index:index];
        if (index == count-1) {
            editViewHeight = center.y+1/2. *kHeight +30;
            [self.delegate setEditViewHeight:editViewHeight];
        }
    }
}

-(void)addEditView:(CGPoint)center index:(NSInteger )index{
    UIView *editBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width/kColumns, kHeight+2*0.25*kHeight)];
    [editBGView setCenter:center];
    editBGView.backgroundColor = [UIColor clearColor];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setFrame:CGRectMake(0, 0, kWidth, kHeight)];
    [editButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [editButton setCenter:CGPointMake(editBGView.bounds.size.width/2., editBGView.bounds.size.height/2.)];
    editButton.tag = kEditButttonTag;
    [editButton setTitle:_dataArray[index] forState:UIControlStateNormal];
    editButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [editButton setBackgroundColor:[UIColor whiteColor]];//[UIColor colorWithRed:246/255. green:246/255. blue:246/255. alpha:1.0]];
    [editButton.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [editButton.layer setBorderWidth:0.5f];
    [editButton.layer setCornerRadius:3.0f];
    [editButton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
    xButton.frame = CGRectMake(0,0, 1/2.5 *kHeight, 1/2.5 *kHeight);
    xButton.center = CGPointMake(editButton.frame.origin.x + editButton.frame.size.width, editButton.frame.origin.y);
    xButton.tag = kXButtonTag;
    xButton.hidden = YES;
    [xButton setTitle:@"-" forState:UIControlStateNormal];
    [xButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [xButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    xButton.backgroundColor = [UIColor whiteColor];
    xButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    xButton.layer.borderWidth = 0.5;
    xButton.layer.cornerRadius = xButton.bounds.size.width/2.;
    [xButton addTarget:self action:@selector(xButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [editBGView addSubview:editButton];
    [editBGView addSubview:xButton];
    [self addSubview:editBGView];
    [_editViewsArray addObject:editBGView];
}

#pragma mark - 寻找view
// 寻找被选中的图标
-(UIView *)findSelectedView:(CGPoint)touchedPoint{
    for (UIView *view in _editViewsArray) {
        CGRect editButtonFrame = CGRectMake(view.center.x - kWidth/2., view.center.y - kHeight/2., kWidth, kHeight);
        if (CGRectContainsPoint(editButtonFrame, touchedPoint)) {
            // 获取触摸位置与被选中图标中心点之间的偏移
            self.offset = CGPointMake(touchedPoint.x - view.center.x, touchedPoint.y - view.center.y);
            [self bringSubviewToFront:view];
            return view;
        }
    }
    return nil;
}

// 寻找包含被选中图标中心点的图标（非被选中的图标）
-(UIView *)findViewContainsSelectedViewCenter{
    for (UIView *view in _editViewsArray) {
        if (view != _selectedView) {
            CGRect editButtonFrame = CGRectMake(view.center.x - kWidth/2., view.center.y - kHeight/2., kWidth, kHeight);
            if (CGRectContainsPoint(editButtonFrame, _selectedView.center)) {
                return view;
            }
        }
    }
    return nil;
}

// 交换view的位置
-(void)exchangeSelectdView:(UIView *)selectedView betweenView:(UIView *)destView{
    if (selectedView && destView) {
        NSInteger idxSelectedView = [_editViewsArray indexOfObject:selectedView];
        NSInteger idxDestView = [_editViewsArray indexOfObject:destView];
        CGPoint newPoint = _selectedViewOriginCenter;
        if (idxSelectedView < idxDestView) {
            // 先移动前面的，再移动后面的
            for (NSInteger idx = idxSelectedView+1; idx < idxDestView+1; idx++) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                [UIView setAnimationDuration:kAnimationDuration];
                CGPoint oldPoint = ((UIView *)[_editViewsArray objectAtIndex:idx]).center;
                ((UIView *)[_editViewsArray objectAtIndex:idx]).center = newPoint;
                newPoint = oldPoint;
                [UIView commitAnimations];
                [_editViewsArray exchangeObjectAtIndex:idx withObjectAtIndex:idx-1];
            }
        }else{
            // 先移动后面的，再移动前面的
            for (NSInteger idx = idxSelectedView-1; idx > idxDestView-1; idx--) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                [UIView setAnimationDuration:kAnimationDuration];
                CGPoint oldPoint = ((UIView *)[_editViewsArray objectAtIndex:idx]).center;
                ((UIView *)[_editViewsArray objectAtIndex:idx]).center = newPoint;
                newPoint = oldPoint;
                [UIView commitAnimations];
                [_editViewsArray exchangeObjectAtIndex:idx withObjectAtIndex:idx+1];
            }
        }
        _selectedViewOriginCenter = newPoint;
    }
}

#pragma mark - touch事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint touchedLoc = [touch locationInView:self];
    _selectedView = [self findSelectedView:touchedLoc];// 寻找选中的图标
    _selectedViewOriginCenter = _selectedView.center;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if (_selectedView) {
        UIView *destView = [self findViewContainsSelectedViewCenter];
        [self exchangeSelectdView:_selectedView betweenView:destView];
        _selectedView.center = _selectedViewOriginCenter;
        _selectedView = nil;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    if (_selectedView) {
        UITouch *touch = [touches anyObject];
        CGPoint touchedLoc = [touch locationInView:self];
        CGFloat newX = touchedLoc.x - self.offset.x;
        CGFloat newY = touchedLoc.y - self.offset.y;
        _selectedView.center = CGPointMake(newX, newY);
        UIView *destView = [self findViewContainsSelectedViewCenter];
        [self exchangeSelectdView:_selectedView betweenView:destView];
    }
}


#pragma mark - action

-(void)editButtonAction:(UIButton *)sender{
    
}

-(void)xButtonAction:(UIButton *)sender{
    NSInteger indexDelete = [_editViewsArray indexOfObject:sender.superview];
    _selectedView = sender.superview;
    _selectedViewOriginCenter = _selectedView.center;
    UIView *destView = [_editViewsArray lastObject];
    for (UIView *view in _selectedView.subviews) {
        [view removeFromSuperview];
    }
    [self exchangeSelectdView:_selectedView betweenView:destView];
    [_editViewsArray removeObject:_selectedView];
    [_dataArray removeObjectAtIndex:indexDelete];
    UIView *lastView = [_editViewsArray lastObject];
    if (editViewHeight != (lastView.center.y + 1/2. *kHeight + 30)) {
        editViewHeight = lastView.center.y + 1/2. *kHeight + 30;
        [self.delegate setEditViewHeight:editViewHeight];
    }
}

-(void)longPressAction:(UILongPressGestureRecognizer *)gesture{
    NSLog(@"11111");
    [self showEnableEditStatus];
}

#pragma mark - 公共方法

-(void)insetData:(NSString *)title{
    [_dataArray addObject:title];
    NSInteger index = _dataArray.count - 1;
    NSInteger rowIndex = index / kColumns;
    NSInteger columnsIndex = index % kColumns;
    CGPoint center = CGPointMake(columnsIndex*2*kHorizontalSpace +kHorizontalSpace, rowIndex*2*kVerticalSpace + kVerticalSpace);
    [self addEditView:center index:index];
}

// 显示可编辑状态
-(void)showEnableEditStatus{
    if (isEditStatus) {
        return;
    }
    for (UIView *view in _editViewsArray) {
        UIButton *editButton = (UIButton *)[view viewWithTag:kEditButttonTag];
        UIButton *xButton = (UIButton *)[view viewWithTag:kXButtonTag];
        editButton.userInteractionEnabled = NO;
        xButton.hidden = NO;
    }
    isEditStatus = YES;
}

// 显示正常状态
-(void)restoreNomalStatus{
    if (!isEditStatus) {
        return;
    }
    for (UIView *view in _editViewsArray) {
        UIButton *editButton = (UIButton *)[view viewWithTag:kEditButttonTag];
        UIButton *xButton = (UIButton *)[view viewWithTag:kXButtonTag];
        editButton.userInteractionEnabled = YES;
        xButton.hidden = YES;
    }
    isEditStatus = NO;
}


@end
