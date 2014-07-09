//
//  GrouponUserGuideView.h
//  ElongClient
//
//  Created by bruce on 13-10-8.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GrouponUserGuideDelegate <NSObject>

- (void)guideViewFinish;

@end

@interface GrouponUserGuideView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) id <GrouponUserGuideDelegate> delegate; // 代理

// 消失
- (void)dismiss;

@end
