//
//  CategoryListBottomBar.h
//  ElongClient
//
//  Created by Jian.Zhao on 14-1-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomBarDelegate <NSObject>

@optional
-(void)hideTheCompleteItemOrNot:(BOOL)yes;
-(void)tapTheEditButtonWithStatus:(BOOL)status;

@end

@interface CategoryListBottomBar : UIView{

    id<BottomBarDelegate>_delegate;
    
    BOOL hideComplete;
    BOOL isEdit;
    
    UIButton *hideBtn;
    UIButton *editBtn;
}

@property (nonatomic,assign)    id<BottomBarDelegate>delegate;


@end
