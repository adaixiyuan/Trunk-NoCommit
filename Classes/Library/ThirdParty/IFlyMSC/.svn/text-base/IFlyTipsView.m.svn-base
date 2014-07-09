//
//  IFlyTipsView.m
//  ElongClient
//
//  Created by Dawn on 14-3-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "IFlyTipsView.h"

@interface IFlyTipsView()

@property (nonatomic,retain) NSMutableArray *items;
@property (nonatomic,assign) CGFloat itemHeight;
@property (nonatomic,assign) CGFloat titleHeight;
@property (nonatomic,assign) CGFloat move;

@end

@implementation IFlyTipsView

- (void) dealloc{
    self.items = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame items:(NSArray *)itemArray{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleHeight    = 80;
        self.itemHeight     = 36;
        self.move           = 240;
        self.timeFront      = 0.4;
        self.timeRear       = 0.4;
        self.timeFrontDelay = 0.2;
        self.timeRearDelay  = 0.2;
        self.items = [NSMutableArray array];
        for (int i = 0; i < itemArray.count; i++) {
            UILabel *lbl = nil;
            if (i == 0) {
                lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.titleHeight)];
                lbl.textColor = RGBACOLOR(86, 86, 86, 1);
                lbl.font = [UIFont systemFontOfSize:24.0f];
            }else{
                lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.titleHeight + (i - 1) * self.itemHeight, self.frame.size.width, self.itemHeight)];
                lbl.textColor = RGBACOLOR(153,153, 153, 1);
                lbl.font = [UIFont systemFontOfSize:18.0f];
                lbl.lineBreakMode = UILineBreakModeCharacterWrap;
                lbl.numberOfLines = 2;
            }
            lbl.backgroundColor = [UIColor clearColor];
            lbl.textAlignment = UITextAlignmentCenter;
            [self.items addObject:lbl];
            [lbl release];
            [self addSubview:lbl];
            lbl.text = [itemArray objectAtIndex:i];
            lbl.alpha = 1.0f;
        }
        self.clipsToBounds = NO;
    }
    return self;
}

- (void) reloadItems:(NSArray *)itemArray completion:(void(^)(void))completion{
    if (itemArray.count < self.items.count) {
        UILabel *lbl = (UILabel *)[self.items lastObject];
        while ((!lbl.text || [lbl.text isEqualToString:@""]) && self.items.count) {
            [self.items removeLastObject];
            [lbl removeFromSuperview];
            lbl = (UILabel *)[self.items lastObject];
        }
    }
    NSInteger i = self.items.count;
    while (itemArray.count > self.items.count) {
        UILabel *lbl = nil;
        if (i == 0) {
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.titleHeight)];
            lbl.textColor = RGBACOLOR(86, 86, 86, 1);
            lbl.font = [UIFont systemFontOfSize:24.0f];
        }else{
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, self.titleHeight + (i - 1) * self.itemHeight, self.frame.size.width, self.itemHeight)];
            lbl.textColor = RGBACOLOR(153,153, 153, 1);
            lbl.font = [UIFont systemFontOfSize:18.0f];
            lbl.lineBreakMode = UILineBreakModeCharacterWrap;
            lbl.numberOfLines = 2;
        }
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textAlignment = UITextAlignmentCenter;
        [self.items addObject:lbl];
        [self addSubview:lbl];
        [lbl release];
        i++;
    }
    if(self.items){
        for (int i = 0; i < self.items.count; i++) {
            UILabel *lbl = (UILabel *)[self.items objectAtIndex:i];
            if (i == 0) {
                lbl.frame = CGRectMake(0, 0, self.frame.size.width, self.titleHeight);
            }else{
                lbl.frame = CGRectMake(0, self.titleHeight + (i - 1) * self.itemHeight, self.frame.size.width, self.itemHeight);
            }
            lbl.alpha = 1.0f;
            
            void (^secondBlock)(BOOL finished);
            secondBlock = ^(BOOL finished) {
                if (i < itemArray.count) {
                    lbl.text = [itemArray objectAtIndex:i];
                }else{
                    lbl.text = @"";
                }
                if (i == 0) {
                    lbl.frame = CGRectMake(0, self.move, self.frame.size.width, self.titleHeight);
                }else{
                    lbl.frame = CGRectMake(0, self.move + self.titleHeight + (i - 1) * self.itemHeight, self.frame.size.width, self.itemHeight);
                }
                if (IOSVersion_7) {
                    // ios7下的弹簧效果
                    [UIView animateWithDuration:self.timeRear * 1.6 delay:self.timeRearDelay + i * 0.06 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        if (i == 0) {
                            lbl.frame = CGRectMake(0, 0, self.frame.size.width, self.titleHeight);
                        }else{
                            lbl.frame = CGRectMake(0, self.titleHeight + (i - 1) * self.itemHeight, self.frame.size.width, self.itemHeight);
                        }
                        lbl.alpha = 1.0f;
                    } completion:^(BOOL finished) {
                        if (completion && i == itemArray.count - 1) {
                            self.timeFrontDelay = 0.6;
                            completion();
                            self.timeFrontDelay = 0.2;
                        }
                    }];
                }else{
                    [UIView animateWithDuration:self.timeRear delay:self.timeRearDelay + i * 0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        if (i == 0) {
                            lbl.frame = CGRectMake(0, 0, self.frame.size.width, self.titleHeight);
                        }else{
                            lbl.frame = CGRectMake(0, self.titleHeight + (i - 1) * self.itemHeight, self.frame.size.width, self.itemHeight);
                        }
                        lbl.alpha = 1.0f;
                    } completion:^(BOOL finished) {
                        if (completion && i == itemArray.count - 1) {
                            self.timeFrontDelay = 0.6;
                            completion();
                            self.timeFrontDelay = 0.2;
                        }
                    }];
                }
            };
            
            if (IOSVersion_7) {
                [UIView animateWithDuration:self.timeFront * 1.6 delay:self.timeFrontDelay + i * 0.1 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    if (i == 0) {
                        lbl.frame = CGRectMake(0, - self.move, self.frame.size.width, self.titleHeight);
                    }else{
                        lbl.frame = CGRectMake(0, - self.move + self.titleHeight + (i - 1) * self.itemHeight, self.frame.size.width, self.itemHeight);
                    }
                    lbl.alpha = 0.0f;
                } completion:secondBlock];
            }else{
                [UIView animateWithDuration:self.timeFront delay:self.timeFrontDelay + i * 0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    if (i == 0) {
                        lbl.frame = CGRectMake(0, - self.move, self.frame.size.width, self.titleHeight);
                    }else{
                        lbl.frame = CGRectMake(0, - self.move + self.titleHeight + (i - 1) * self.itemHeight, self.frame.size.width, self.itemHeight);
                    }
                    lbl.alpha = 0.0f;
                } completion:secondBlock];
            }
        }
    }
}

- (void) reloadItems:(NSArray *)itemArray{
    [self reloadItems:itemArray completion:nil];
}

@end
