//
//  GrouponDetailMutipleAddreeCell.h
//  ElongClient
//
//  Created by garin on 14-5-30.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrouponDetailAppointmentCellDelegate.h"

@interface GrouponDetailMutipleAddreeCell : UITableViewCell

@property (nonatomic,assign) id<GrouponDetailAppointmentCellDelegate> delegate;

- (IBAction)appointMentClick:(id)sender;
@end
