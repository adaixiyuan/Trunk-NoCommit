//
//  StarSelector.h
//  ElongClient
//
//  酒店星级选择控件，支持多选
//  Created by Dawn on 14-4-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StarSelectorItemDelegate;
@protocol StarSelectorDelegate;
@interface StarSelectorItem : UIView{
@private
    UIButton *_itemBtn;
    UILabel *_itemLbl;
    UILabel *_innerLbl;
}

@property (nonatomic,retain) NSString *innerTitle;  // 星级文字
@property (nonatomic,retain) NSString *title;       // 星级下文字
@property (nonatomic,retain) UIImage *image;        // 灰色星级
@property (nonatomic,retain) UIImage *hightImage;   // 高亮星级
@property (nonatomic,copy) NSString *starCode;      // 星级的code
@property (nonatomic,assign) BOOL selected;         // 选中状态
@property (nonatomic,assign) id<StarSelectorItemDelegate> delegate;
@end

@protocol StarSelectorItemDelegate <NSObject>

- (void) starSelectorItemAction:(StarSelectorItem *)item;

@end

@interface StarSelector : UIView<StarSelectorItemDelegate>
@property (nonatomic,assign) id<StarSelectorDelegate> delegate;
@property (nonatomic,retain) NSString *starCodes;               // 当前星级的选中情况“，”分割
@end


@protocol StarSelectorDelegate <NSObject>
- (void)starSelector:(StarSelector *)starSelector didSelectStarCodes:(NSString *)starCodes;

@end