//
//  AddressTableCell.h
//  ElongClient
//
//  Created by WangHaibin on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddressTableCell : UITableViewCell {
	IBOutlet UILabel *nameLable;
	IBOutlet UILabel *infoLable;
	int cellheight;
}

@property (nonatomic, retain) UILabel *nameLable;
@property (nonatomic, retain) UILabel *infoLable;

@end