//
//  GrouponOrderConfirmView.m
//  ElongClient
//
//  Created by 赵 海波 on 14-5-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponOrderConfirmView.h"

@implementation GrouponOrderConfirmView

- (id)initWithContents:(NSArray *)contentArray
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        // 生成3行label来显示内容
        int fixHeight = 20;
        int fixWidth = 320 - 2 * 12;
        UIFont *fixFont = FONT_15;
        int offY = 0;
        
        for (int i = 0; i < [contentArray count]; i ++)
        {
            int labelHeight = fixHeight;
            
            CGSize size = [[contentArray objectAtIndex:i] sizeWithFont:fixFont constrainedToSize:CGSizeMake(fixWidth, 80)];
            if (size.height > fixHeight)
            {
                labelHeight = size.height;      // 换行需要考虑的情况
                if (IOSVersion_7)
                {
                    labelHeight += 10;
                }
            }
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, offY + 7, fixWidth, labelHeight)];
            if (IOSVersion_6)
            {
                contentLabel.preferredMaxLayoutWidth = fixWidth;
            }
            contentLabel.backgroundColor = [UIColor clearColor];
            contentLabel.numberOfLines = 0;
            //contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
            offY += labelHeight;
            
            switch (i)
            {
                case 0:
                {
                    contentLabel.text = [contentArray objectAtIndex:0];
                    contentLabel.textColor = RGBCOLOR(52, 52, 52, 1);
                    contentLabel.font = fixFont;
                }
                    break;
                case 1:
                    contentLabel.text = [contentArray objectAtIndex:1];
                    contentLabel.textColor = RGBCOLOR(52, 52, 52, 1);
                    contentLabel.font = fixFont;
                    break;
                case 2:
                    contentLabel.text = [contentArray objectAtIndex:2];
                    contentLabel.textColor = [UIColor darkGrayColor];
                    contentLabel.font = FONT_12;
                    contentLabel.numberOfLines = 4;
                    break;
                    
                default:
                    break;
            }
            
            [self addSubview:contentLabel];
            
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, offY + 15);
        }
        
        [self addSubview:[UIImageView dashedHalfLineWithFrame:CGRectMake(0, self.frame.size.height - 1, SCREEN_WIDTH, 1)]];
    }
    
    return self;
}

@end
