//
//  MessageBoxController.h
//  ElongClient
//
//  Created by 赵岩 on 13-5-23.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"

#define UPDATE_MESSAGECOUNT @"update_messageCount"
@interface MessageBoxController : DPNav <UITableViewDataSource, UITableViewDelegate>

-(void)updateUIWithFrame:(CGRect)aFrame;

@end
