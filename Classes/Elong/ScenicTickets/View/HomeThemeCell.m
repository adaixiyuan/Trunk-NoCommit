//
//  HomeThemeCell.m
//  ElongClient
//
//  Created by nieyun on 14-5-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HomeThemeCell.h"
#import "HotScenicView.h"
#import "ScenicListViewController.h"

@implementation HomeThemeCell
- (void)dealloc
{
    SFRelease(hotView);
    SFRelease(_textAr);
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       
       
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!hotView)
    {
//        hotView = [[HotScenicView alloc]initWithFrame:self.bounds withHorizontalCount:4 withVerticalCount:3 withTextAr:nil andFinish:^(UIButton *bt, int i)
//        {
//            NSLog(@"%d",i);
//            ElongClientAppDelegate  *delegate = (ElongClientAppDelegate *)[UIApplication  sharedApplication].delegate;
//            __block  ElongClientAppDelegate  *replace =delegate;
//            ScenicListViewController  *listCtrl = [[ScenicListViewController  alloc]initWithTitle:@"景点门票" style:NavBarBtnStyleOnlyBackBtn];
//            
//                     [replace.navigationController  pushViewController:listCtrl animated:YES];
//            
//                     [listCtrl  release];
//        }];
        hotView = [[HotScenicView alloc]initWithFrame:self.bounds withHorizontalCount:4 withVerticalCount:3 withTextAr:nil andDelegate:self.delegate];
        
        [self  addSubview:hotView];

        
    }
    if (self.textAr)
    {
        hotView.textAr = self.textAr;
    }
}


- (void) setTextAr:(NSArray *)textAr{
    [_textAr release];
    _textAr = textAr;
    [_textAr retain];
    hotView.textAr = textAr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
