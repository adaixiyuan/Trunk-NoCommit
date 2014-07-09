//
//  FAQcell.h
//  ElongClient
//
//  Created by jinmiao on 11-2-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FAQInformCell : UITableViewCell {
	UILabel *contentlabel;
	UILabel *titlelabel;
	UIView *subBgview;
	UIImageView* headimageView;
	IBOutlet UIImageView *answerBgImageView;
	BOOL isSelected;
	int row;
}
@property(nonatomic,retain) IBOutlet UILabel *titlelabel;
@property (nonatomic,retain)IBOutlet UILabel *contentlabel;
@property(nonatomic,retain) IBOutlet UIView *subBgview;
@property(nonatomic,retain) IBOutlet UIImageView* headimageView;
@property (nonatomic,retain) IBOutlet UIImageView *answerBgImageView;
@property (nonatomic)BOOL isSelected;
@property (nonatomic)int row;
@end
