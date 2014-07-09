//
//  HomeCityCell.h
//  ElongClient
//
//  Created by nieyun on 14-5-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#define VInterVal  10
#define HInterval  10
@interface HomeCityCell : UITableViewCell
{
    UIView  *cityView;
    int vertical;
    int horizontal;
    id   delegate;
}
@property (retain, nonatomic) IBOutlet UIImageView *nearImageV;
@property (retain,nonatomic)  NSArray  *modelAr;
@property (retain,nonatomic)  NSArray  *textAr;
- (void)setDelegate:(id) dele;
@end
