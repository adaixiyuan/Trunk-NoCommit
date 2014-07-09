//
//  HotScenicView.h
//  ElongClient
//
//  Created by nieyun on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotScenicButton.h"
typedef  void(^hotScenicBlock) (UIButton *,int );
@interface HotScenicView : UIView
{
    float  labelWidth;
    float  labelHeight;
    NSMutableArray  *buttonAr;
}
- (id) initWithFrame:(CGRect)frame withHorizontalCount:(int  )hcount  withVerticalCount:(int)vcount
          withTextAr:(NSArray *)textAr  andFinish:(clickBlock) finishBlock;
- (id) initWithFrame:(CGRect)frame withHorizontalCount:(int  )hcount  withVerticalCount:(int)vcount
          withTextAr:(NSArray *)textAr  andDelegate:(id) delegate;
@property  (nonatomic,retain)NSArray  *textAr;
@end
