//
//  UniformCell.h
//  ElongClient
//  统一风格的cell（样式参考酒店订单填写页）
//
//  Created by Zhao Haibo on 13-11-18.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    UniformCellTypeTop,         // 顶部圆角
    UniformCellTypeMiddle,      // 中间无圆角
    UniformCellTypeBottom,      // 底部圆角
    UniformCellTypeSingle       // 四周圆角
}UniformCellType;   // cell样式

@interface UniformCell : UITableViewCell
{
    UIImageView *bgImageView;
    UIImageView *splitView;
}

@property (nonatomic, assign) UniformCellType cellType;     // 指定cell的样式

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier cellHeight:(NSInteger)height;

@end
