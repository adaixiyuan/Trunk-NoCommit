//
//  CommonCell.m
//  ElongClient
//
//  Created by haibo on 11-12-31.
//  Copyright 2011 elong. All rights reserved.
//

#import "CommonCell.h"

@implementation CommonCell

@synthesize cellImage;		
@synthesize textLabel;

- (void)dealloc
{
	self.cellImage  = nil;		
	self.textLabel  = nil;		
	[_button release];
    [super dealloc];
}

- (id)initWithIdentifier:(NSString *)identifierString height:(CGFloat)cellHeight style:(CommonCellStyle)cellStyle
{
    curStyle=cellStyle;
    
	if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierString]) {
		UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        backView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.selectedBackgroundView = backView;
//        backView.backgroundColor = RGBACOLOR(237, 237,237, 1);
        backView.backgroundColor=[UIColor clearColor];
		[backView release];
        
        self.backgroundColor=[UIColor clearColor];
		
		// arrow
		UIImageView *img = [[UIImageView alloc] init];
        img.contentMode = UIViewContentModeCenter;
		if (CommonCellStyleDownArrow == cellStyle) {
			img.frame = CGRectMake(SCREEN_WIDTH - 16,0 , 12, cellHeight);
			img.image = [UIImage imageNamed:@"ico_downarrow.png"];
		}
		else if (CommonCellStyleRightArrow == cellStyle) {
			img.frame = CGRectMake(SCREEN_WIDTH - 16, 0, 8, cellHeight);
			img.image = [UIImage imageNamed:@"ico_rightarrow.png"];
		}
		else if (CommonCellStyleChoose == cellStyle) {
			img.frame = CGRectMake(18, 0, 19, cellHeight);
            img.contentMode = UIViewContentModeCenter;
			img.image = [UIImage imageNamed:@"btn_checkbox.png"];
			img.highlightedImage = [UIImage imageNamed:@"btn_checkbox_checked.png"];
		}
		else if (CommonCellStyleCheckBox == cellStyle) {
            img.frame = CGRectMake(18, 0, 19, cellHeight);
			img.image = [UIImage imageNamed:@"btn_choice.png"];
        }else{
			img.frame = CGRectZero;
			img.image = nil;
		}
        
        [self setImgOther:img];
		
		[self.contentView addSubview:img];
		self.cellImage = img;
		[img release];
		
		// conditions
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((CommonCellStyleChoose == cellStyle || CommonCellStyleCheckBox == cellStyle)? 60 : 20, 10, BOTTOM_BUTTON_WIDTH, cellHeight - 20)];
        label.numberOfLines = 0;
		label.backgroundColor	= [UIColor clearColor];
		label.font				= FONT_15;
		label.adjustsFontSizeToFitWidth = YES;
		label.minimumFontSize	= 14;
        label.textColor = RGBACOLOR(52, 52, 52, 1);
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self setlabelOther:label];
        
		[self.contentView addSubview:label];
		self.textLabel = label;
		[label release];
		
		// dashed
        UIImageView *dashview = [[[UIImageView alloc] initWithFrame:CGRectMake(0, cellHeight - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
        dashview.tag = 101;
        dashview.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:dashview];
	}
	
	return self;
}

//设置图标的其他，子类可以实现
-(void) setImgOther:(UIImageView *)img
{
    
}

//设置label的其他，子类可以实现
-(void) setlabelOther:(UILabel *)label
{
    
}

- (void) setChecked:(BOOL)checked{
    _checked = checked;
    if (checked) {
        self.cellImage.image = [UIImage imageNamed:@"btn_choice_checked.png"];
    }else{
        self.cellImage.image = [UIImage imageNamed:@"btn_choice.png"];
    }
}

@end

@implementation RoundCornerSelectCell

@synthesize textLabel;
@synthesize cellImage;

- (void)dealloc
{
    self.topSplitView = nil;
    self.bottomSplitView = nil;
	self.textLabel  = nil;
    self.cellImage  = nil;
    
    [super dealloc];
}

- (id)initWithIdentifier:(NSString *)identifierString height:(CGFloat)cellHeight
{
	if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifierString]) {
        // 背景色
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        backView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.selectedBackgroundView = backView;
        backView.backgroundColor = RGBACOLOR(237, 237,237, 1);
		[backView release];
        
		UIImageView *img = [[UIImageView alloc] init];
        img.frame = CGRectMake(18, (cellHeight-25) / 2, 28, 24);
        img.image = [UIImage imageNamed:@"btn_checkbox.png"];
        img.highlightedImage = [UIImage imageNamed:@"btn_checkbox_checked.png"];
		[self.contentView addSubview:img];
        img.contentMode = UIViewContentModeCenter;
        self.cellImage = img;
		[img release];
		
		// conditions
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, (cellHeight-21) / 2, BOTTOM_BUTTON_WIDTH, 20)];
		label.backgroundColor	= [UIColor clearColor];
		label.font				= FONT_15;
		label.adjustsFontSizeToFitWidth = YES;
		label.minimumFontSize	= 14;
        label.textColor = RGBACOLOR(102, 102, 102, 1);
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self.contentView addSubview:label];
		self.textLabel = label;
		[label release];
		
		// dashed
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        self.topSplitView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
        self.topSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:self.topSplitView];
    
        self.bottomSplitView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, cellHeight - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)] autorelease];
        self.bottomSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:self.bottomSplitView];
	}
	
	return self;
}

- (void)setCellPosition:(RoundCornerSelectCellPosition)position
{
    if (position == RoundCornerSelectCellPositionTop) {
        self.topSplitView.hidden = NO;
        self.bottomSplitView.hidden = NO;
    }
    else if(position == RoundCornerSelectCellPositionCenter){
        self.topSplitView.hidden = YES;
        self.bottomSplitView.hidden = NO;
    }
    else {
        self.topSplitView.hidden = NO;
        self.bottomSplitView.hidden = NO;
    }
}

@end
