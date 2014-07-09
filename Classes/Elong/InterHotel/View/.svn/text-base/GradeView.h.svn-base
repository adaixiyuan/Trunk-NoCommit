//
//  GradeView.h
//  ElongClient
//
//  Created by nieyun on 14-6-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol gradeDelegate <NSObject>

- (void) didSelectedButton:(int ) flag;

@end
@interface GradeView : UIView
{
    NSMutableArray  *buttonAr;
    int allCount;
    NSString *lightImagePath;
    NSString  *grayImagePath;
    int defaultScore;
}
@property (nonatomic,assign) id <gradeDelegate> delegate;
- (void) setDefaultScore:(float)score lightImage:(NSString *)limage  grayImage:(NSString *)gimage count:(int )count;
@end

