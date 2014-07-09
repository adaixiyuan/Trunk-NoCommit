//
//  GrouponDetailCellDelegate.h
//  ElongClient
//
//  Created by garin on 14/6/5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GrouponDetailCellDelegate <NSObject>

- (void) changeCellHeight:(UITableViewCell *)cell cellHeight:(float) cellHeight;

@end
