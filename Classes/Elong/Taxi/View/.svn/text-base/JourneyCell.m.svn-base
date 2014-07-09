//
//  JourneyCell.m
//  ElongClient
//
//  Created by nieyun on 14-2-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "JourneyCell.h"
#import "UIViewExt.h"
#import "CommonDefine.h"
#define Imagheight  30

#define CellLineHeight  0.3

@implementation JourneyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
         _dLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, SCREEN_SCALE, self.width, self.height -SCREEN_SCALE)];
        _dLabel.backgroundColor  = [UIColor clearColor];
        self.dLabel.font = [UIFont  systemFontOfSize:15];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView  addSubview:self.dLabel];
        
        self.contentView.backgroundColor  =[UIColor  whiteColor];
        
//       _imgv = [[UIImageView  alloc]initWithFrame:CGRectMake(0, (self.height - Imagheight)/2, 30, 30)];
//        _imgv.backgroundColor = [UIColor  orangeColor];
//        [self.contentView  addSubview:_imgv];
        
    }
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews ];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) dealloc
{
    [_model release];
    [_message release];
    self.dLabel = nil;
    [_behindMessage  release];
    [_imgv release];
    [super dealloc];
}
@end
