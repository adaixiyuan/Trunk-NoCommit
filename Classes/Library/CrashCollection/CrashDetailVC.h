//
//  CrashDetailVC.h
//  ElongClient
//
//  Created by bruce on 14-3-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DPNav.h"

@interface CrashDetailVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *crashTime;                      // Crash时间
@property (nonatomic, strong) NSDictionary *crashDetail;                 // Crash详情
@property (nonatomic, strong) NSDictionary *crashSteps;                  // Crash步骤
@property (nonatomic, strong) NSString *crashStepContent;                // Crash步骤内容

@end
