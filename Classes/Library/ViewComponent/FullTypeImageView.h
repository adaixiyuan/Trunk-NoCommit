//
//  FullTypeImageView.h
//  ElongClient
//
//  Created by 赵 海波 on 13-3-29.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoView.h"
#import "CustomSegmented.h"

@protocol FullImageViewDelegate;
@interface FullTypeImageView : UIView <PhotoViewDelegate, CustomSegmentedDelegate> {
@private
    PhotoView *photoPageView;
    BOOL fullScreen;
    UIButton *cancelBtn;
    UILabel *tipsLbl;
    NSInteger index;
    
    NSArray *allImgs;                       // 所有数据源
    NSMutableArray *guestRoomImgs;          // 客房图片
    NSMutableArray *exteriorImgs;           // 外观图片
    NSMutableArray *receptionImgs;          // 前台图片
    NSMutableArray *otherImgs;              // 设施图片
    NSMutableArray *titles;                 // 分类标题
    NSArray *displayArray;                  // 当前正在展示的分类
    
    id delegate;
    UILabel *titleLbl;
}

@property (nonatomic,assign) id<FullImageViewDelegate> delegate;

- (void)reloadData;
- (id)initWithFrame:(CGRect)frame Images:(NSArray *)imageURLs AtIndex:(NSInteger)indexNum;

@end

@protocol FullTypeImageViewDelegate <NSObject>

@optional
- (void) fullImageView:(FullTypeImageView *)fullImageView didClosedAtIndex:(NSInteger)index;

@end