//
//  ScenicOrderNumCell.h
//  ElongClient
//
//  Created by jian.zhao on 14-5-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TicketsNumDelegate <NSObject>

-(void)reduceNum:(UIButton *)sender;
-(void)plusNum:(UIButton *)sender;

@end

@interface ScenicOrderNumCell : UITableViewCell
@property (nonatomic,assign) id<TicketsNumDelegate>delegate;
@property (retain, nonatomic) IBOutlet UILabel *spanNum;
@property (retain, nonatomic) IBOutlet UILabel *buyNum;
@property (retain, nonatomic) IBOutlet UIButton *left;
@property (retain, nonatomic) IBOutlet UIButton *right;

@end
