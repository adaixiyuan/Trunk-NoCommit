//
//  FAQView.m
//  ElongClient
//
//  Created by jinmiao on 11-2-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FAQ.h"


@implementation FAQ

- (void)loadView {
	[super loadView];
    int height = (SCREEN_HEIGHT > 500) ? 44 : 44;
//	UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
//	contentView.backgroundColor=[UIColor whiteColor];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"FaqTitle" ofType:@"plist"];
	array = [[NSDictionary alloc] initWithContentsOfFile:path];

	keys=[[NSArray alloc]initWithArray:[array allKeys]];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    scrollView.backgroundColor = [UIColor whiteColor];
    
	for (int i = 0; i < [keys count]; i++) {
	    NSString *ValueString = [NSString stringWithFormat:@"%d",i];
		UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
		abtn.frame = CGRectMake(0, i*height, 320, height);
		abtn.backgroundColor = [UIColor clearColor];
		abtn.tag=i;
        abtn.exclusiveTouch = YES;
		[abtn setBackgroundImage:[UIImage stretchableImageWithPath:@"common_btn_press.png"] forState:UIControlStateHighlighted];
		[abtn addTarget:self action:@selector(goFAQInform:) forControlEvents:UIControlEventTouchUpInside];
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = RGBACOLOR(52, 52, 52, 1);
		label.highlightedTextColor = [UIColor whiteColor];
		label.font = FONT_B14;
		label.text = [[array safeObjectForKey:ValueString] safeObjectAtIndex:0];
		[label sizeToFit];
		label.tag = 10;
		label.frame=CGRectMake(10, 0, 300, height);
        
		UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[lineView setImage:[UIImage noCacheImageNamed:@"dashed.png"]];
	    [lineView sizeToFit];
		lineView.contentMode = UIViewContentModeScaleAspectFill;
		lineView.clipsToBounds = YES;
		lineView.frame=CGRectMake(0, height-SCREEN_SCALE, 320, SCREEN_SCALE);
        
		UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectZero];
		image.frame=CGRectMake(300, (height-9)/2, 5, 9);
		image.image = [UIImage imageNamed:@"ico_rightarrow.png"];
		
		
		[abtn addSubview:label];
		[abtn addSubview:lineView];
		[abtn addSubview:image];
		[label release];
		[lineView release];
		[image release];
        [scrollView addSubview:abtn];
	}

    scrollView.userInteractionEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, [array count] * height);
    [self.view addSubview:scrollView];
    [scrollView release];
//	contentView.frame=CGRectMake(0, 12, 320, [array count]*height);
//	contentView.userInteractionEnabled=YES;
//	[self.view addSubview:contentView];
//	[contentView release];
}


-(void)goFAQInform:(id)sender{
	NSInteger tag = [sender tag];
	
	NSString *tagString = [NSString stringWithFormat:@"%d",tag];

	
	FAQInform *faqinform = [[FAQInform alloc] init:[[array safeObjectForKey:tagString] safeObjectAtIndex:0] style:_NavNoTelStyle_ _filename:[[array safeObjectForKey:tagString] safeObjectAtIndex:1]];
	
	[self.navigationController pushViewController:faqinform animated:YES];
	
	[faqinform release];
}


- (void)dealloc {
	[keys release];
	[array release];
	
    [super dealloc];
}


@end
