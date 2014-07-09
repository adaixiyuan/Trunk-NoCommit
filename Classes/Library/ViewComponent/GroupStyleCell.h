//
//  GroupStyleCell.h
//  ElongClient
//  类似系统的goup风格
//
//  Created by 赵 海波 on 13-7-23.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    GroupCellPositionTop = -1,          // 顶部
    GroupCellPositionMiddle = 0,        // 中间
    GroupCellPositionBottom = 1,        // 底部
    GroupCellPositionWhole = 2,        // 底部
}GroupCellPosition;     // cell的位置

typedef enum
{
    GroupCellStyleDefault,           // 只有主标题和灰色箭头
    GroupCellStyleSubTitle,          // 比default多了个在右边的副标题
    GroupCellStyleTextField          // 比default多了个文本输入框
}GroupCellStyle;

@protocol GroupStyleCellDelegate <NSObject>

@optional
- (void)cellTextFieldShouldBeginEditing:(UITextField *)textField;    // cell上的输入框被选中

@end


@interface GroupStyleCell : UITableViewCell <UITextFieldDelegate> {
@private
    UIImageView *bgImageView;
    UIImageView *rightArrow;
    
    NSInteger cellHeight;
    
    GroupCellStyle cellStyle;
}

@property (nonatomic, assign) id<GroupStyleCellDelegate> delegate;
@property (nonatomic, assign) GroupCellPosition cellType;
@property (nonatomic, retain) UILabel *titleLabel;          // 标题（左）
@property (nonatomic, retain) UILabel *subTitleLabel;       // 副标题（for GroupCellStyleSubTitle）
@property (nonatomic, retain) CustomTextField *inputField;  // 输入框（for GroupCellStyleTextField）
@property (nonatomic, assign) BOOL needHighLighted;         // 是否显示选中效果,default ＝ yes

- (id)initWithStyle:(GroupCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(int)height;

@end
