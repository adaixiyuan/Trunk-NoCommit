//
//  CouponIntroductionController.m
//  ElongClient
//
//  Created by 赵岩 on 13-7-22.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "CouponIntroductionController.h"

#define kCellTopMargin  (20)
#define kCellTextTopMargin (10)
#define kCellTitleFontSize  (13)
#define kCellTextFontSize   (12)

@interface CouponIntroductionController ()

@end

@implementation CouponIntroductionController

- (void)dealloc
{
    [_introductionList release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        int offX = 0;
        UIView *topView = [[UIView alloc] init];
        NSString *titleStr = @"返现规则";
        CGSize size = [titleStr sizeWithFont:FONT_B18];
		if (size.width >= 200) {
			size.width = 195;
		}
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offX + 3, 13, size.width, 18)];
		label.tag = 101;
		label.backgroundColor	= [UIColor clearColor];
		label.font				= FONT_B18;
		label.textColor			= [UIColor blackColor];
		label.text				= titleStr;
		label.textAlignment		= UITextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumFontSize = 14.0f;
		
		topView.frame = CGRectMake(0, 0, size.width + offX + 5, 44);
		[topView addSubview:label];
		self.navigationItem.titleView = topView;
		
		[label		release];
		[topView	release];
        
        [super headerView:@"btn_navback_normal.png" backSelectIcon:nil
                 telicon:nil telSelectIcon:nil
                homeicon:nil homeSelectIcon:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.introductionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        CGSize titleSize = [[[self.introductionList safeObjectAtIndex:indexPath.row] safeObjectForKey:@"Title"] sizeWithFont:[UIFont boldSystemFontOfSize:kCellTitleFontSize] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, kCellTopMargin, 300, titleSize.height)] autorelease];
        titleLabel.tag = 1024;
        titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [cell.contentView addSubview:titleLabel];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = RGBACOLOR(52, 52, 52, 1);
        
        CGSize textSize = [[[self.introductionList safeObjectAtIndex:indexPath.row] safeObjectForKey:@"Text"] sizeWithFont:[UIFont boldSystemFontOfSize:kCellTitleFontSize] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, kCellTopMargin + titleSize.height + kCellTextTopMargin, 300, textSize.height)] autorelease];
        textLabel.tag = 1025;
        textLabel.numberOfLines = 0;
        textLabel.font = [UIFont systemFontOfSize:12];
        textLabel.textColor = RGBACOLOR(93, 93, 93, 1);
        textLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textLabel];
    }
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:1024];
    titleLabel.text = [[self.introductionList safeObjectAtIndex:indexPath.row] safeObjectForKey:@"Title"];
    
    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:1025];
    textLabel.text = [[self.introductionList safeObjectAtIndex:indexPath.row] safeObjectForKey:@"Text"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGSize titleSize = [[[self.introductionList safeObjectAtIndex:indexPath.row] safeObjectForKey:@"Title"] sizeWithFont:[UIFont boldSystemFontOfSize:kCellTitleFontSize] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize textSize = [[[self.introductionList safeObjectAtIndex:indexPath.row] safeObjectForKey:@"Text"] sizeWithFont:[UIFont boldSystemFontOfSize:kCellTitleFontSize] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return kCellTopMargin + titleSize.height + kCellTextTopMargin + textSize.height;
}

@end
