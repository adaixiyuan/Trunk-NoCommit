//
//  CouponIntroductionController.h
//  ElongClient
//
//  Created by 赵岩 on 13-7-22.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponIntroductionController : DPNav <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSArray *introductionList;

@end
