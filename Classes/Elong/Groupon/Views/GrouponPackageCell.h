//
//  GrouponPackageCell.h
//  ElongClient
//
//  Created by garin on 14-2-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrouponPackageCell : UITableViewCell
{
    UILabel *roomName;
    UILabel *currencyLbl;
    UILabel *moneyLbl;
    UIImageView *upSplitView;
}

-(void) setShowPrice:(NSString *) price;

-(void) setRoomName:(NSString *) rName;

-(void) setUpSplitHidden:(BOOL) hidden;
@end
