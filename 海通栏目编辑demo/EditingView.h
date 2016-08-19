//
//  EditingView.h
//  仿网易编辑栏目
//
//  Created by 李海龙 on 16/8/17.
//  Copyright © 2016年 shadow. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditViewDeledate <NSObject>

@required

-(void)setEditViewHeight:(float)value;

@end


@interface EditingView : UIView<EditViewDeledate>

@property (nonatomic,retain) id<EditViewDeledate>delegate;

-(void)loadData:(NSArray *)dataArray;
-(void)restoreNomalStatus;
-(void)showEnableEditStatus;
-(void)insetData:(NSString *)title;
@end
