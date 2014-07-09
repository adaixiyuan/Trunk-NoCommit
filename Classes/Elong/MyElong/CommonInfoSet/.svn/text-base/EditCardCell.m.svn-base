//
//  EditCardCell.m
//  ElongClient
//
//  Created by Dawn on 13-12-23.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "EditCardCell.h"

@implementation EditCardCell

- (void) dealloc{
    self.titleLbl = nil;
    self.detailLbl = nil;
    self.detailField = nil;
    self.arrowView = nil;
    self.topSplitView = nil;
    self.bottomSplitView = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // title
        self.titleLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 44)] autorelease];
        self.titleLbl.backgroundColor = [UIColor clearColor];
        self.titleLbl.textColor = RGBACOLOR(93, 93, 93, 1);
        self.titleLbl.font = FONT_16;
        [self.contentView addSubview:self.titleLbl];
        
        // detail
        self.detailLbl = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 44)] autorelease];
        self.detailLbl.textColor = RGBACOLOR(52, 52, 52, 1);
        self.detailLbl.backgroundColor = [UIColor clearColor];
        self.detailLbl.textAlignment = UITextAlignmentRight;
        self.detailLbl.font = FONT_16;
        [self.contentView addSubview:self.detailLbl];
        
        self.detailField = [[[EmbedTextField alloc] initCustomFieldWithFrame:CGRectMake(80, 0, SCREEN_WIDTH - 100, 44) Title:@"" TitleFont:FONT_16] autorelease];
        [self.detailField setBgHidden:YES];
        self.detailField.delegate = self;
        self.detailField.textField.textAlignment = UITextAlignmentRight;
        self.detailField.textFont = FONT_16;
        [self.contentView addSubview:self.detailField];
        
        //arrow
        self.arrowView = [[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16, 0, 8, 44)] autorelease];
        self.arrowView.contentMode = UIViewContentModeCenter;
        self.arrowView.image = [UIImage noCacheImageNamed:@"ico_downarrow.png"];
        [self.contentView addSubview:self.arrowView];
        
        //分割线
        self.topSplitView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
        self.topSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:self.topSplitView];
        
        self.bottomSplitView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
        self.bottomSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:self.bottomSplitView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
