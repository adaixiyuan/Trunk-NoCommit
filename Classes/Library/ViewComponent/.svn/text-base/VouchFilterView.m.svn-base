//
//  VouchFilterView.m
//  ElongClient
//
//  Created by 赵 海波 on 12-12-5.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import "VouchFilterView.h"
#import "Utils.h"

#define Vouch_Tag           6782
#define Vouch_Money_Tag     6783

static int cell_Height	= 60;
static int max_Number   = 6;

@implementation VouchFilterView

@synthesize moneyValue;

- (void)dealloc {
    [moneyValue release];
    
    [super dealloc];
}


- (id)initWithTitle:(NSString *)title Datas:(NSArray *)datas {
    if (self = [super initWithTitle:title Datas:datas]) {
        
        NSInteger height = 0;
		if ([datas count] > max_Number) {
			height = MAINCONTENTHEIGHT - 30;
		}
		else {
			height = cell_Height * [datas count];
		}

		keyTable.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, height);
    }
    
    return  self;
}


- (void)showInView {
//	if (!isShowing) {
//		clickBlock = NO;
//		isShowing = YES;
//		
//		if ([listDatas count] < max_Number) {
//			[self.view.superview  bringSubviewToFront:self.view];
//			CGRect rect		 = self.view.frame;
//			rect.size.height = NAVIGATION_BAR_HEIGHT + keyTable.frame.size.height;
//			self.view.frame  = rect;
//			
//			[Utils animationView:self.view
//						   fromX:0
//						   fromY:SCREEN_HEIGHT + 20
//							 toX:0
//							 toY:SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - self.view.frame.size.height
//						   delay:0.0f
//						duration:SHOW_WINDOWS_DEFAULT_DURATION];
//		} else {
//			ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
//			[appDelegate.navigationController.visibleViewController presentModalViewController:self animated:YES];
//		}
//	}
    [super showInView];
}

- (void)dismissInView {
//	if (isShowing) {
//		isShowing = NO;
//		
//		if ([listDatas count] < max_Number) {
//			[Utils animationView:self.view
//						   fromX:0
//						   fromY:SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - self.view.frame.size.height
//							 toX:0
//							 toY:SCREEN_HEIGHT + 20
//						   delay:0.0f
//						duration:SHOW_WINDOWS_DEFAULT_DURATION];
//		} else {
//			[self dismissModalViewControllerAnimated:YES];
//		}
//	}
    [super dismissInView];
}


- (UIView *)makeVouchStyleView {
    UIView *vouchView = [[UIView alloc] initWithFrame:CGRectMake(60, 25, BOTTOM_BUTTON_WIDTH, 35)];
    vouchView.backgroundColor = [UIColor clearColor];
    
    UIImageView *cardImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 10, 23, 15)];
    cardImage.image = [UIImage noCacheImageNamed:@"mastercard.png"];
    [vouchView addSubview:cardImage];
    [cardImage release];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 8, 140, 19)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = FONT_B16;
    titleLabel.text = @"需担保，金额为：";
    titleLabel.textColor = [UIColor grayColor];
    [vouchView addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 8, 100, 19)];
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.font = FONT_B18;
    moneyLabel.textColor = [UIColor orangeColor];
    moneyLabel.tag = Vouch_Money_Tag;
    [vouchView addSubview:moneyLabel];
    [moneyLabel release];
    
    return [vouchView autorelease];
}


- (void)setMoneyValue:(NSString *)string {
    if (string != moneyValue) {
        [moneyValue release];
        moneyValue = [string copy];
        
        [keyTable reloadData];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [listDatas count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return cell_Height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SelectTableCellKey = @"SelectTableCellKey";
    
	CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
	if (cell == nil) {
		cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKey height:cell_Height style:CommonCellStyleChoose] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *vouchView = [self makeVouchStyleView];
        vouchView.tag = Vouch_Tag;
        vouchView.hidden = YES;
        [cell.contentView addSubview:vouchView];
	}
	
	NSDictionary *dic = [listDatas safeObjectAtIndex:indexPath.row];
    if ([[dic safeObjectForKey:NEEDVOUCH] boolValue]) {
        // 需要担保时调整页面布局
        cell.textLabel.frame = CGRectMake(60, 8, BOTTOM_BUTTON_WIDTH, 20);
        
        UIView *vouchView = [cell.contentView viewWithTag:Vouch_Tag];
        vouchView.hidden = NO;
        
        UILabel *moneyLabel = (UILabel *)[vouchView viewWithTag:Vouch_Money_Tag];
        moneyLabel.text = moneyValue;
    }
    else {
        // 不需要担保时延续原来的布局
        cell.textLabel.frame = CGRectMake(60, (cell_Height - 21) / 2, BOTTOM_BUTTON_WIDTH, 20);
        
        UIView *vouchView = [cell.contentView viewWithTag:Vouch_Tag];
        vouchView.hidden = YES;
    }
        
    NSString *cellTitle = [dic safeObjectForKey:SHOWTIME];
	if (![cellTitle isEqual:[NSNull null]]) {
		cell.textLabel.text = cellTitle;
	}
	
	if (indexPath.row == currentRow) {
		cell.cellImage.highlighted = YES;
	}
	else {
		cell.cellImage.highlighted = NO;
	}
	
    return cell;
}

@end