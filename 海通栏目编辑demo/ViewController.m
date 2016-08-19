//
//  ViewController.m
//  海通栏目编辑demo
//
//  Created by 李海龙 on 16/8/18.
//  Copyright © 2016年 shadow. All rights reserved.
//

#import "ViewController.h"
#import "EditingView.h"


#define kAnimationDuration (0.35f)
#define kScaleFactory (1.25f)

#define kWidth    60   // 子view的宽度
#define kHeight   30   // 子view的高度
#define kColumns  4    // 显示的列数

#define kEditButttonTag     1100
#define kXButtonTag         1200


@interface ViewController (){
    CGPoint myFunSelectedViewOriginCenter;
    CGPoint hotFunSelectedViewOriginCenter;
    CGPoint offset;
    float kHorizontalSpace;
    float kVerticalSpace;
    UIView *myFunSelectedView;
    float myFunBGViewHeight;
    float hotFunBGViewHeight;
}
@property (nonatomic, strong) NSMutableArray *myFunDataArray;// 我的功能title
@property (nonatomic, strong) NSMutableArray *hotFunDataArray;// 热点功能title
@property (nonatomic, strong) NSMutableArray *myFunViewArray;// 我的功能View
@property (nonatomic, strong) NSMutableArray *hotFunViewArray;// 热点功能View
@property (nonatomic, strong) UIView *myFunHeadView;// 我的功能headView
@property (nonatomic, strong) UIView *hotFunHeadView;// 热点功能headView
@property (nonatomic, strong) UIScrollView *bgScrollView;// 背景view
@property (nonatomic, strong) UIView *myFunBGView; // 我的功能背景view
@property (nonatomic, strong) UIView *hotFunBGView; // 热点功能背景View

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    editView = [[EditingView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height)];
//    editView.backgroundColor = [UIColor yellowColor];
//    editView.delegate = self;
//    [editView loadData:@[@"1",@"222222",@"股票3",@"股票4",@"225",@"股票666股票",@"337",@"股票8",@"1119",@"10",@"股票11",@"股票12",@"13",@"股票14",@"股票15",@"股票16",@"股票17",@"股票18",@"股票19",@"股票2000"]];
//    [editView showEnableEditStatus];
//    [self.view addSubview:editView];
    
    [self initObj];
    [self addSubViews];
//    [self setSubViewFrames];
    [self loadMyFunViewData:@[@"股票1",@"股票2",@"股票3",@"股票4",@"股票5",@"股票6",@"股票7",@"股票8",@"股票9",@"股票10"] hotFunViewData:@[@"股票11",@"股票12",@"股票13",@"股票14",@"股票15",@"股票16",@"股票17",@"股票18",@"股票19"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 公有方法

-(void)loadMyFunViewData:(NSArray *)myFunData hotFunViewData:(NSArray *)hotFunData{
    [self.myFunDataArray addObjectsFromArray:myFunData];
    [self.hotFunDataArray addObjectsFromArray:hotFunData];
    NSInteger myFunCount = self.myFunDataArray.count;
    NSInteger hotFunCount = self.hotFunDataArray.count;
    for (int myFunIndex = 0; myFunIndex < myFunCount; myFunIndex++) {
        NSInteger rowIndex = myFunIndex / 4;
        NSInteger columnsIndex = myFunIndex % 4;
        CGPoint center = CGPointMake(columnsIndex*2*kHorizontalSpace + kHorizontalSpace, rowIndex*2*kVerticalSpace + kVerticalSpace);
        UIView *editView = [self addEditView:center index:myFunIndex data:self.myFunDataArray isMyFun:YES];
        [self.myFunBGView addSubview:editView];
        [self.myFunViewArray addObject:editView];
        if (myFunIndex == myFunCount - 1) {
            myFunBGViewHeight = center.y +1/2.*kHeight +30;
//            [self setSubViewFrames];
        }
    }
    
    for (int hotFunIndex = 0; hotFunIndex < hotFunCount; hotFunIndex++) {
        NSInteger rowIndex = hotFunIndex / 4;
        NSInteger columnsIndex = hotFunIndex % 4;
        CGPoint center = CGPointMake(columnsIndex*2*kHorizontalSpace + kHorizontalSpace, rowIndex*2*kVerticalSpace + kVerticalSpace);
        UIView *editView = [self addEditView:center index:hotFunIndex data:self.hotFunDataArray isMyFun:NO];
        [self.hotFunBGView addSubview:editView];
        [self.hotFunViewArray addObject:editView];
        if (hotFunIndex == hotFunCount - 1) {
            hotFunBGViewHeight = center.y +1/2.*kHeight +30;
            [self setSubViewFrames];
        }
    }
}

#pragma mark - 私有方法

-(void)initObj{
    myFunSelectedViewOriginCenter = CGPointZero;
    hotFunSelectedViewOriginCenter = CGPointZero;
    offset = CGPointZero;
    kHorizontalSpace = self.view.bounds.size.width/8.;
    kVerticalSpace = 1/2.*kHeight+1/4.*kHeight;
    myFunSelectedView = nil;
    myFunBGViewHeight = 0.;
    hotFunBGViewHeight = 0.;

}
-(void)addSubViews{
    [self.bgScrollView addSubview:self.myFunHeadView];
    [self.bgScrollView addSubview:self.myFunBGView];
    [self.bgScrollView addSubview:self.hotFunHeadView];
    [self.bgScrollView addSubview:self.hotFunBGView];
    [self.view addSubview:self.bgScrollView];

}

-(void)setSubViewFrames{
    self.myFunHeadView.frame = CGRectMake(0, 20, self.view.bounds.size.width, kHeight);
    self.myFunBGView.frame = CGRectMake(self.myFunHeadView.frame.origin.x,self.myFunHeadView.frame.origin.y+self.myFunHeadView.frame.size.height, self.myFunHeadView.frame.size.width, myFunBGViewHeight);
    self.hotFunHeadView.frame = CGRectMake(self.myFunHeadView.frame.origin.x, self.myFunBGView.frame.origin.y + self.myFunBGView.frame.size.height, self.myFunBGView.frame.size.width, kHeight);
    self.hotFunBGView.frame = CGRectMake(self.hotFunHeadView.frame.origin.x,self.hotFunHeadView.frame.origin.y+self.hotFunHeadView.frame.size.height, self.hotFunHeadView.frame.size.width, hotFunBGViewHeight);
    self.bgScrollView.frame = self.view.bounds;
    self.bgScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.hotFunBGView.frame.origin.y + self.hotFunBGView.frame.size.height);
}

-(UIView *)addEditView:(CGPoint)center index:(NSInteger )index data:(NSMutableArray *)dataArray isMyFun:(BOOL)isMyFun{
    UIView *editBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/kColumns, kHeight+2*0.25*kHeight)];
    [editBGView setCenter:center];
    editBGView.backgroundColor = [UIColor clearColor];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setFrame:CGRectMake(0, 0, kWidth, kHeight)];
    [editButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [editButton setCenter:CGPointMake(editBGView.bounds.size.width/2., editBGView.bounds.size.height/2.)];
    editButton.tag = kEditButttonTag;
    [editButton setTitle:dataArray[index] forState:UIControlStateNormal];
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
//    xButton.hidden = YES;
    [xButton setTitle:isMyFun ? @"-" : @"+" forState:UIControlStateNormal];
    [xButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [xButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    xButton.backgroundColor = [UIColor whiteColor];
    xButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    xButton.layer.borderWidth = 0.5;
    xButton.layer.cornerRadius = xButton.bounds.size.width/2.;
    [xButton addTarget:self action:@selector(xButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [editBGView addSubview:editButton];
    [editBGView addSubview:xButton];
    return editBGView;
}


-(UIView *)creatHeadViewWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kHeight)];
    
    UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 1/3.*kHeight, 5, 1/3.*kHeight)];
    leftLineView.backgroundColor = [UIColor colorWithRed:59/255. green:92/255. blue:148/255. alpha:1.0f];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLineView.frame.origin.x +leftLineView.frame.size.width + 20, 1/4.*kHeight, kWidth, 1/2.*kHeight)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width + 20, 1/4.*kHeight, 200, 1/2.*kHeight)];
    detailLabel.text = detailTitle;
    detailLabel.textColor = [UIColor lightGrayColor];
    detailLabel.font = [UIFont systemFontOfSize:15.0f];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.frame.origin.y + headView.frame.size.height - 2, headView.frame.size.width, 0.5)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    
    [headView addSubview:leftLineView];
    [headView addSubview:titleLabel];
    [headView addSubview:detailLabel];
    [headView addSubview:bottomLineView];
    
    return headView;
}

#pragma mark - 寻找view
// 寻找被选中的图标
-(UIView *)findSelectedView:(CGPoint)touchedPoint{
    for (UIView *view in self.myFunViewArray) {
        CGRect editButtonFrame = CGRectMake(view.center.x - kWidth/2., view.center.y - kHeight/2., kWidth, kHeight);
        if (CGRectContainsPoint(editButtonFrame, touchedPoint)) {
            // 获取触摸位置与被选中图标中心点之间的偏移
            offset = CGPointMake(touchedPoint.x - view.center.x, touchedPoint.y - view.center.y);
            [self.myFunBGView bringSubviewToFront:view];
            return view;
        }
    }
    return nil;
}

// 寻找包含被选中图标中心点的图标（非被选中的图标）
-(UIView *)findViewContainsSelectedViewCenter{
    for (UIView *view in self.myFunViewArray) {
        if (view != myFunSelectedView) {
            CGRect editButtonFrame = CGRectMake(view.center.x - kWidth/2., view.center.y - kHeight/2., kWidth, kHeight);
            if (CGRectContainsPoint(editButtonFrame, myFunSelectedView.center)) {
                return view;
            }
        }
    }
    return nil;
}

// 交换view的位置
-(void)exchangeSelectdView:(UIView *)selectedView betweenView:(UIView *)destView{
    if (selectedView && destView) {
        NSInteger idxSelectedView = [self.myFunViewArray indexOfObject:selectedView];
        NSInteger idxDestView = [self.myFunViewArray indexOfObject:destView];
        CGPoint newPoint = myFunSelectedViewOriginCenter;
        if (idxSelectedView < idxDestView) {
            // 先移动前面的，再移动后面的
            for (NSInteger idx = idxSelectedView+1; idx < idxDestView+1; idx++) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                [UIView setAnimationDuration:kAnimationDuration];
                CGPoint oldPoint = ((UIView *)[self.myFunViewArray objectAtIndex:idx]).center;
                ((UIView *)[self.myFunViewArray objectAtIndex:idx]).center = newPoint;
                newPoint = oldPoint;
                [UIView commitAnimations];
                [self.myFunViewArray exchangeObjectAtIndex:idx withObjectAtIndex:idx-1];
                [self.myFunDataArray exchangeObjectAtIndex:idx withObjectAtIndex:idx-1];
            }
        }else{
            // 先移动后面的，再移动前面的
            for (NSInteger idx = idxSelectedView-1; idx > idxDestView-1; idx--) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                [UIView setAnimationDuration:kAnimationDuration];
                CGPoint oldPoint = ((UIView *)[self.myFunViewArray objectAtIndex:idx]).center;
                ((UIView *)[self.myFunViewArray objectAtIndex:idx]).center = newPoint;
                newPoint = oldPoint;
                [UIView commitAnimations];
                [self.myFunViewArray exchangeObjectAtIndex:idx withObjectAtIndex:idx+1];
                [self.myFunDataArray exchangeObjectAtIndex:idx withObjectAtIndex:idx+1];
            }
        }
        myFunSelectedViewOriginCenter = newPoint;
    }
}


#pragma mark - touch事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint touchedLoc = [touch locationInView:self.myFunBGView];
    myFunSelectedView = [self findSelectedView:touchedLoc];// 寻找选中的图标
    myFunSelectedViewOriginCenter = myFunSelectedView.center;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if (myFunSelectedView) {
        UIView *destView = [self findViewContainsSelectedViewCenter];
        [self exchangeSelectdView:myFunSelectedView betweenView:destView];
        myFunSelectedView.center = myFunSelectedViewOriginCenter;
        myFunSelectedView = nil;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    if (myFunSelectedView) {
        UITouch *touch = [touches anyObject];
        CGPoint touchedLoc = [touch locationInView:self.myFunBGView];
        CGFloat newX = touchedLoc.x - offset.x;
        CGFloat newY = touchedLoc.y - offset.y;
        myFunSelectedView.center = CGPointMake(newX, newY);
        UIView *destView = [self findViewContainsSelectedViewCenter];
        [self exchangeSelectdView:myFunSelectedView betweenView:destView];
    }
}


- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
//    NSLog(@"用户点击了scroll上的视图%@,是否开始滚动scroll",view);
//    //返回yes 是不滚动 scroll 返回no 是滚动scroll
//    return YES;
    
    if (view == self.myFunBGView) {
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    
//    NSLog(@"用户点击的视图 %@",view);
//    
//    //NO scroll不可以滚动 YES scroll可以滚动
//    return NO;
    if (view == self.myFunBGView) {
        return NO;
    }else{
        return YES;
    }

}


#pragma mark - action

-(void)editButtonAction:(UIButton *)sender{
    
}

-(void)xButtonAction:(UIButton *)sender{
    
}

#pragma mark - 属性

-(NSMutableArray *)myFunDataArray{
    if (nil == _myFunDataArray) {
        _myFunDataArray = [NSMutableArray new];
    }
    return _myFunDataArray;
}

-(NSMutableArray *)hotFunDataArray{
    if (nil == _hotFunDataArray) {
        _hotFunDataArray = [NSMutableArray new];
    }
    return _hotFunDataArray;
}

-(NSMutableArray *)myFunViewArray{
    if (nil == _myFunViewArray) {
        _myFunViewArray = [NSMutableArray new];
    }
    return _myFunViewArray;
}

-(NSMutableArray *)hotFunViewArray{
    if (nil == _hotFunDataArray) {
        _hotFunDataArray = [NSMutableArray new];
    }
    return _hotFunDataArray;
}

-(UIView *)myFunHeadView{
    if (nil == _myFunHeadView) {
        _myFunHeadView = [self creatHeadViewWithTitle:@"我的功能" detailTitle:@"(拖动调整顺序)"];
    }
    return _myFunHeadView;
}

-(UIView *)hotFunHeadView{
    if (nil == _hotFunHeadView) {
        _hotFunHeadView = [self creatHeadViewWithTitle:@"热门功能" detailTitle:@"(点击添加更多)"];
    }
    return _hotFunHeadView;
}

-(UIScrollView *)bgScrollView{
    if (nil == _bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _bgScrollView.contentSize = self.view.bounds.size;
        _bgScrollView.userInteractionEnabled = NO;
    }
    return _bgScrollView;
}

-(UIView *)myFunBGView{
    if (nil == _myFunBGView) {
        _myFunBGView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _myFunBGView;
}

-(UIView *)hotFunBGView{
    if (nil == _hotFunBGView) {
        _hotFunBGView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _hotFunBGView;
}



@end
