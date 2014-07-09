//
//  TaxiPersonCell.h
//  ElongClient
//
//  Created by nieyun on 14-3-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

@protocol PersonChooseDelegate <NSObject>

- (void) personChooseAction;

@end
#import <UIKit/UIKit.h>
#import "TaxiPublicDefine.h"

@interface TaxiPersonCell : UITableViewCell

{
@private
  
    UILabel *titleLbl;
    UILabel *detailLbl;
    UIImageView *topSplitView;
    UIImageView *dashView;
}
@property (nonatomic,retain) UITextField *textField;
@property (nonatomic,assign) CellType cellType;
@property (nonatomic,assign) id<PersonChooseDelegate>  delegate;
@property (nonatomic,assign) BOOL  isMember;
@end
