//
//  CashAccountTableCell.m
//  ElongClient
//
//  Created by 赵 海波 on 13-12-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "CashAccountTableCell.h"
#import "CashAccountPasswordSetVC.h"

@implementation CashAccountTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)clickResetPwdBtn
{
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window endEditing:YES];
    
    CashAccountPasswordSetVC *controller = [[CashAccountPasswordSetVC alloc] initWithType:ECashAccountSetTypeReset];
    [appDelegate.navigationController pushViewController:controller animated:YES];
}

@end
