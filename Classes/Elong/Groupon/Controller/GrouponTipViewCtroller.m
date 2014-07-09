//
//  GrouponTipViewCtroller.m
//  ElongClient
//  团购提示
//
//  Created by haibo on 11-11-24.
//  Copyright 2011 elong. All rights reserved.
//

#import "GrouponTipViewCtroller.h"

static NSString *tipMessage = @"1. 预约时需提供艺龙团购券券号及密码；预约成功后，艺龙团购券视为已使用，不得进行变更和取消；预约是否成功以商家的最终确认为准；由于商家单日接待能力有限，建议您尽可能更早提前预约。\n\n"
"2. 成功购买艺龙团购券后，不退不换，不设找赎，不可兑换现金，过期作废，不可顺延；如团购未成功，则艺龙会将款项退还至您支付时使用的信用卡账户中，由于各信用卡开户行不同退款时间大约需要2-15个工作日。\n\n"
"3. 艺龙团购券购买数量不设限(酒店声明的特殊情况除外)。除非特别说明，可以在一家酒店连续使用多张团购券。请注意在预约时向酒店说明。\n\n"
"4. 此价格不可与其它折扣或促销项目同时享用。\n\n"
"5. 每间客房最多入住2位宾客，每位入住宾客需携带有效身份证件方可办理入住登记。\n\n"
"6. 艺龙团购券未包含得其它项目，如酒店餐饮、娱乐、酒水、加床、通讯及政府税金等其它费用需由入住人另行支付。\n\n"
"7.团购券号和密码如果忘记，可以在 “订单管理”中“团购订单”进行查询获取。 \n\n"
"8. 在法律允许的范围内，根据活动的进展情况艺龙旅行网可能对活动的规则/条款作出适当修改/调整。";

@implementation GrouponTipViewCtroller


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (id)init {
	if (self = [super initWithTopImagePath:nil andTitle:@"如何团购" style:_NavNoTelStyle_]) {
		UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT)];
		table.dataSource		= self;
		table.delegate			= self;
		table.backgroundColor	= [UIColor clearColor];
		table.separatorStyle	= UITableViewCellSeparatorStyleNone;
		[self.view addSubview:table];
		[table release];
	}
	
	return self;
}


- (void)backhome {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:ORDER_FILL_ALERT
												   delegate:self 
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:@"确认", nil];
	[alert show];
	[alert release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (0 != buttonIndex) {
		[super backhome];
	}
}

#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGSize size = [tipMessage sizeWithFont:FONT_14 constrainedToSize:CGSizeMake(300, 2000)];
	
	return size.height + 40;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.contentView.backgroundColor = [UIColor clearColor];
		
		UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10, 308, [self tableView:tableView heightForRowAtIndexPath:indexPath] - 20)];
		backView.image = [[UIImage imageNamed:@"white_boder.png"] stretchableImageWithLeftCapWidth:16 topCapHeight:12];
		[cell.contentView addSubview:backView];
		[backView release];
    }
    
	cell.textLabel.text				= tipMessage;
	cell.textLabel.numberOfLines	= 0;
	cell.textLabel.font				= FONT_14;
    
    return cell;
}


@end

