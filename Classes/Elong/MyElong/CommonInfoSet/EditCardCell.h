//
//  EditCardCell.h
//  ElongClient
//
//  Created by Dawn on 13-12-23.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmbedTextField.h"

@interface EditCardCell : UITableViewCell

@property (nonatomic,retain) UILabel *titleLbl;
@property (nonatomic,retain) UILabel *detailLbl;
@property (nonatomic,retain) EmbedTextField *detailField;
@property (nonatomic,retain) UIImageView *topSplitView;
@property (nonatomic,retain) UIImageView *bottomSplitView;
@property (nonatomic,retain) UIImageView *arrowView;
@end
