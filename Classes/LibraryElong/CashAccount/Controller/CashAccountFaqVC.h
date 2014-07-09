//
//  CashAccountFaqVC.h
//  ElongClient
//  CA相关的FAQ
//
//  Created by 赵 海波 on 13-8-12.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashAccountFaqVC : DPNav <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSArray *introductionList;

@end
