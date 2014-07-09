//
//  CardTableCell.h
//  ElongClient
//
//  Created by WangHaibin on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CardTableCell : UITableViewCell {
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *bankTypeNameLabel;
	IBOutlet UILabel *bankNumberLabel;
}

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *bankTypeNameLabel;
@property (nonatomic, retain) UILabel *bankNumberLabel;
@property (nonatomic, retain) IBOutlet UIImageView *overDueImgView;

@end
