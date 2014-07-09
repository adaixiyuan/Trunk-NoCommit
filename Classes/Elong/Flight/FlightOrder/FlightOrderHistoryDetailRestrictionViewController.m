//
//  FlightOrderHistoryDetailRestrictionViewController.m
//  ElongClient
//
//  Created by WangHaibin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlightOrderHistoryDetailRestrictionViewController.h"


@implementation FlightOrderHistoryDetailRestrictionViewController
@synthesize returnRegulateLabel;
@synthesize changeRegulateLabel;
@synthesize returnTitle;
@synthesize changeTitle;

- (id)init
{
    self = [super initWithTopImagePath:nil andTitle:@"退改签规定" style:_NavNormalBtnStyle_];
    if (self) {
        
    }
    return self;
}

-(void)fillContentWithReturnContent:(NSString *)returnContent andChangeContent:(NSString *)changeContent andSignRule:(NSString *)signRule{
    CGSize returnSize = [returnContent sizeWithFont:FONT_14 constrainedToSize:CGSizeMake(300, 10000)];
    CGSize changeSize = [changeContent sizeWithFont:FONT_14 constrainedToSize:CGSizeMake(300, 10000)];
    CGSize signruleSize = [signRule sizeWithFont:FONT_14 constrainedToSize:CGSizeMake(300, 10000)];
    int returnHeight = returnSize.height>25?returnSize.height+10:25;
    int changeHeight = changeSize.height>25?changeSize.height+10:25;
    int signruHeight = signruleSize.height>25?signruleSize.height+10:25;
    self.returnRegulateLabel.text = returnContent;
    self.changeRegulateLabel.text = changeContent;
    self.signRuleLabel.text = signRule;
    self.returnRegulateLabel.frame = CGRectMake(10, 35, 300, returnHeight);
    self.changeTitle.frame = CGRectMake(10, 45+returnHeight, 100, 25);
    self.changeRegulateLabel.frame = CGRectMake(10, 70+returnHeight, 300, changeHeight);
    self.signRuleTitle.frame = CGRectMake(10, 10+self.changeRegulateLabel.bottom, 100, 25);
    self.signRuleLabel.frame = CGRectMake(10, 2+self.signRuleTitle.bottom, 300, signruHeight);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
	[returnRegulateLabel release];
	[changeRegulateLabel release];
	[returnTitle release];
	[changeTitle release];

	
	[super dealloc];
}


@end
