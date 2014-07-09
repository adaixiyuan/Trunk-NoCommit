//
//  GrouponDistrictViewController.m
//  ElongClient
//
//  Created by Dawn on 13-8-1.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#define kNumberLabelTag 238

#define kTextFieldTag 239

#import "GrouponDistrictViewController.h"

@interface GrouponDistrictViewController ()

@end

@implementation GrouponDistrictViewController
@synthesize dataArray;
@synthesize item;
@synthesize delegate;

- (void)dealloc
{
    _distictList.delegate=nil;
    [_distictList release];
    self.dataArray = nil;
    self.item = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.wantsFullScreenLayout = YES;

    self.distictList = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    self.distictList.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.distictList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.distictList.delegate = self;
    self.distictList.dataSource = self;
    self.distictList.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.distictList];
}

- (void)reloadData
{
    [_distictList reloadData];
    [_distictList setContentOffset:CGPointMake(0, 0)];
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return HSC_CELL_HEGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SelectTableCellKey = @"SelectTableCellKey";
     
    CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
    if (cell == nil)
    {
        cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKey
                                                height:HSC_CELL_HEGHT
                                                 style:CommonCellStyleChoose] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.minimumFontSize=12;
        cell.textLabel.numberOfLines=1;
        cell.textLabel.frame=CGRectMake(60, cell.textLabel.frame.origin.y, BOTTOM_BUTTON_WIDTH-35, cell.textLabel.frame.size.height);
        
//        UILabel *valueLabel			= [[UILabel alloc] init];
//        valueLabel.font				= FONT_12;
//        valueLabel.tag				= kNumberLabelTag;
//        valueLabel.textColor		= [UIColor colorWithRed:0.0f/255.0f green:65.0f/255.0f blue:131.0f/255.0 alpha:1];
//        valueLabel.backgroundColor	= [UIColor clearColor];
//        [cell.contentView addSubview:valueLabel];
//        [valueLabel release];
    }
    
    // 团购区域
    NSString *text = [[self.dataArray safeObjectAtIndex:indexPath.row] objectForKey:@"ItemName"];
    cell.textLabel.text		= [NSString stringWithFormat:@"%@ (%@)",text,[[self.dataArray safeObjectAtIndex:indexPath.row] safeObjectForKey:@"GrouponCnt"]];
//    CGSize titleSize		= [text sizeWithFont:cell.textLabel.font];
//    int titleWidth=titleSize.width>BOTTOM_BUTTON_WIDTH-45?BOTTOM_BUTTON_WIDTH-35:titleSize.width;
//    // 团购数量
//    UILabel *valueLabel	= (UILabel *)[cell.contentView viewWithTag:kNumberLabelTag];
//    valueLabel.text		= [NSString stringWithFormat:@"(%@)",[[self.dataArray safeObjectAtIndex:indexPath.row] safeObjectForKey:@"GrouponCnt"]];
//    CGSize valueSize	= [valueLabel.text sizeWithFont:FONT_12];
//    valueLabel.frame	= CGRectMake(60+titleWidth, 14, valueSize.width, 20);
    
    if ([self.item isEqualToString:text])
    {
        cell.cellImage.highlighted = YES;
    }
    else
    {
        cell.cellImage.highlighted = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.item = [[self.dataArray safeObjectAtIndex:indexPath.row] safeObjectForKey:@"ItemName"];
    [_distictList reloadData];
    
    [self.delegate grouponDistrictVC:self didSelectedAtIndex:indexPath.row];
}

@end
