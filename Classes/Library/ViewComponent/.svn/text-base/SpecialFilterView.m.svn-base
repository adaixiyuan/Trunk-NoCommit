//
//  SpecialFilterView.m
//  ElongClient
//
//  Created by Dawn on 13-11-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "SpecialFilterView.h"

@interface SpecialFilterView ()

@end

@implementation SpecialFilterView

- (id)initWithTitle:(NSString *)title Datas:(NSArray *)datas {
    if (self = [super initWithTitle:title Datas:datas]) {
        UILabel *tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, keyTable.frame.size.width, 40)];
        tipsLbl.font = [UIFont systemFontOfSize:12.0f];
        tipsLbl.textColor = [UIColor grayColor];
        keyTable.tableFooterView = tipsLbl;
        [tipsLbl release];
        tipsLbl.textAlignment = UITextAlignmentCenter;
        tipsLbl.text = @"我们会将您的需求提交给酒店，但无法保证100%满足";
        tipsLbl.backgroundColor = [UIColor clearColor];
        keyTable.frame = CGRectMake(keyTable.frame.origin.x, keyTable.frame.origin.y, keyTable.frame.size.width, keyTable.frame.size.height + 40);
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
