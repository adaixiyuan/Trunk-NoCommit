//
//  FlightEditInsurerView.h
//  ElongClient
//
//  Created by chenggong on 13-12-13.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightEditInsurerView : UIView<UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *insurerArray;

- (void)refreshInsurerTableView;

@end
