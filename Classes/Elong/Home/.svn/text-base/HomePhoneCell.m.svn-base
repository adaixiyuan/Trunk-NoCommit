//
//  HomePhoneCell.m
//  ElongClient
//
//  Created by Dawn on 13-12-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HomePhoneCell.h"

@implementation HomePhoneCell

- (void) dealloc{
    self.titleLbl = nil;
    self.detailLbl = nil;
    self.iconView = nil;
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *splitLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        splitLineView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self addSubview:splitLineView];
        [splitLineView release];
        
        splitLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        splitLineView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self addSubview:splitLineView];
        [splitLineView release];
        
        self.titleLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 44)] autorelease];
        self.titleLbl.font = [UIFont systemFontOfSize:16.0f];
        self.titleLbl.textColor = RGBACOLOR(35, 119, 232, 1);
        [self.contentView addSubview:self.titleLbl];
        
//        self.detailLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH - 20, 20)] autorelease];
//        self.detailLbl.font = [UIFont systemFontOfSize:12.0f];
//        self.detailLbl.textColor =  RGBACOLOR(153, 153, 153, 1);
//        [self.contentView addSubview:self.detailLbl];
        
//        self.iconView = [[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 0, 70, 70)] autorelease];
//        self.iconView.contentMode = UIViewContentModeCenter;
//        [self.contentView addSubview:self.iconView];
//        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
