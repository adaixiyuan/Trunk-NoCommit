//
//  XGBaseTableViewCell.m
//  ElongClient
//
//  Created by guorendong on 14-4-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGBaseTableViewCell.h"

@implementation XGBaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 根据cell的行数取出xib上对应的页面

+(id)getCellByNibName:(NSString *)name ctype:(Class)ctype
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
    for (id oneObject in nib)
    {
        if ([oneObject isKindOfClass:ctype]) {
            return oneObject;
        }
    }
    return nil;
}

@end
