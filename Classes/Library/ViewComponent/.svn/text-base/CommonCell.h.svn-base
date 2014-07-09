//
//  CommonCell.h
//  ElongClient
//  v3.0统一风格的cell
//
//  Created by haibo on 11-12-31.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	CommonCellStyleDownArrow,	// 带下箭头
	CommonCellStyleRightArrow,	// 带右箭头
	CommonCellStyleChoose,		// 带选择框
	CommonCellStyleNone,
    CommonCellStyleCheckBox     // 多选框
}CommonCellStyle;

@interface CommonCell : UITableViewCell {

    CommonCellStyle curStyle;
}

@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UIImageView *cellImage;	// cell上的图标，参考上面的枚举
@property (nonatomic, retain) UILabel *textLabel;		// 标题
@property (nonatomic, assign) BOOL checked;

// 指定高度、风格、选中样式的cell
- (id)initWithIdentifier:(NSString *)identifierString height:(CGFloat)cellHeight style:(CommonCellStyle)cellStyle;


@end

typedef enum {
	RoundCornerSelectCellPositionTop,     // 顶部
	RoundCornerSelectCellPositionCenter,  // 中间
	RoundCornerSelectCellPositionBottom   // 底部
}RoundCornerSelectCellPosition;   // cell位于tableview的位置(背景图不同)

@interface RoundCornerSelectCell : UITableViewCell

@property (nonatomic, retain) UIImageView *topSplitView;
@property (nonatomic, retain) UIImageView *bottomSplitView;
@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UIImageView *cellImage;


- (id)initWithIdentifier:(NSString *)identifierString height:(CGFloat)cellHeight;

// 设置位置
- (void)setCellPosition:(RoundCornerSelectCellPosition)position;

@end
