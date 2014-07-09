//
//  GrouponOrderPhoneCell.h
//  ElongClient
//
//  Created by Dawn on 13-7-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmbedTextField.h"

@protocol GrouponOrderPhoneCellDelegate;
@interface GrouponOrderPhoneCell : UITableViewCell{
@private
    UIImageView *bgImageView;
    CustomTextField *phoneField;
    id delegate;
}
@property (nonatomic,readonly) CustomTextField *phoneField;
@property (nonatomic,assign) id<GrouponOrderPhoneCellDelegate> delegate;
@end


@protocol  GrouponOrderPhoneCellDelegate <NSObject>
@optional
- (void) orderPhoneCellAddPhone:(GrouponOrderPhoneCell *)cell;

@end