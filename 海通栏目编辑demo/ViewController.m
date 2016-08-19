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
    
    [self initData];
    [self addSubViews];
    [self setSubViewFrames];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 私有方法

-(void)initData{
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
    self.bgScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.hotFunBGView.frame.origin.y + self.hotFunBGView.frame.size.height+1000);
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
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.frame.origin.y + headView.frame.size.height - 2, headView.frame.size.width, 1.)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    
    [headView addSubview:leftLineView];
    [headView addSubview:titleLabel];
    [headView addSubview:detailLabel];
    [headView addSubview:bottomLineView];
    
    return headView;
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
        _hotFunHeadView = [self creatHeadViewWithTitle:@"热门功能" detailTitle:@"点击添加更多"];
    }
    return _hotFunHeadView;
}

-(UIScrollView *)bgScrollView{
    if (nil == _bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _bgScrollView.contentSize = self.view.bounds.size;
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
