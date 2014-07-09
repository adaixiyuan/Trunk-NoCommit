//
//  FlightSeatRuleVC.m
//  ElongClient
//
//  Created by bruce on 14-3-26.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightSeatRuleVC.h"

// ==================================================================
// 布局参数
// ==================================================================

//控件间距
#define	kFSeatRuleScrollViewHMargin                     10
#define	kFSeatRuleScrollViewVMargin                     10
#define kFSeatRulekScrollCellHMargin					10

//控件字体
#define	kFSeatRuleContentLabelFont                     [UIFont systemFontOfSize:13.0f]

#define FLIGHT_SEAT_RULE     @"●  适用于在艺龙购买电子客票的旅客。目前允许网上办理选位服务条件如下：1）国内航程；2）待选位航程支持在线选位；3）正常出票；4）航班起飞48小时前。\n\n●  婴儿、儿童、残障者、孕妇、患病者或其他需要特殊服务的旅客，请到机场人工柜台办理。\n\n●  为了您和他人的乘机安全，请将刀具、工具、酒类物品（每人每次数量不超过两瓶，重量不超过1公斤）等禁止随身携带的物品办理托运。不允许作为行李运输的物品包括：枪支、弹药、管制刀具、易燃、易爆、毒害、腐蚀性、放射性等危险物品；其他危害飞行安全以及法律、法规、政府命令禁止运输的物品；鲜活易腐物品；包装、形状、重量、体积或者性质不适宜运输的物品。不允许托运的物品包括：现金、有价票证、珠宝、贵重金属及制品、古玩字画、个人电子设备、样品等贵重、易碎或者易损坏物品、锂电池、重要文件和资料、旅行证件等物品及个人需定时服用的处方药等。\n\n●  如锂离子电池大于100瓦特/小时，但不超过160瓦特/小时，装有符合上述容量要求的锂离子电池的电子设备，可以作为交运行李和手提行李运输；符合上述容量要求的锂离子备用电池不允许托运，只允许在手提行李中携带，且不得超过2块；这些备用电池必须单个包装加以保护以防短路。\n\n●  旅客应严格遵守政府主管部门对乘坐民航班机所需有效证件的规定，保证乘机旅客证件的合法性和有效性，如因证件与姓名不符或证件失效等问题产生的后果均由旅客本人负责。\n\n●  如发生临时更换机型等情况，航空公司将会重新安排座位。如与原座位安排不符，敬请谅解。\n\n●  本声明的最终解释权归艺龙所有。\n"


@implementation FlightSeatRuleVC



- (id)init
{
    if (self = [super initWithTopImagePath:@"" andTitle:@"网上办理选位服务协议" style:_NavOnlyBackBtnStyle_])
    {
        
    }
    
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// 创建Root View的子视图
	[self setupViewRootSubs:[self view]];
}


// =======================================================================
// 布局函数
// =======================================================================
// 创建Root View的子界面
- (void)setupViewRootSubs:(UIView *)viewParent
{
    // =======================================================================
	// TableView
	// =======================================================================
    UITableView *tableViewInfo = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [tableViewInfo setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [tableViewInfo setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableViewInfo setSeparatorColor:[UIColor clearColor]];
    [tableViewInfo setDataSource:self];
    [tableViewInfo setDelegate:self];
    [tableViewInfo setShowsVerticalScrollIndicator:NO];
    [tableViewInfo setBackgroundColor:[UIColor clearColor]];
    
    //保存
    [viewParent addSubview:tableViewInfo];
	
}



// 创建车票规则子界面
- (void)setupTableCellIntroduceSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
	// 子窗口高宽
	NSInteger spaceXStart = 0;
	NSInteger spaceXEnd = pViewSize->width;
	NSInteger subsHeight = 0;
	NSInteger spaceYStart = 0;
	
	/* 间隔 */
	spaceXStart += kFSeatRuleScrollViewHMargin;
	spaceXEnd -= kFSeatRuleScrollViewHMargin;
	spaceYStart += kFSeatRuleScrollViewVMargin;
	
    // =======================================================================
	// 车票规则 Label
	// =======================================================================
    if ((FLIGHT_SEAT_RULE != nil) && ([FLIGHT_SEAT_RULE length] > 0))
    {
        CGSize introductionSize = [FLIGHT_SEAT_RULE sizeWithFont:kFSeatRuleContentLabelFont
                                          constrainedToSize:CGSizeMake(spaceXEnd - spaceXStart, CGFLOAT_MAX)
                                              lineBreakMode:UILineBreakModeWordWrap];
        
        // 创建Label
        UILabel *labelIntroduction = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelIntroduction setFrame:CGRectMake(spaceXStart, spaceYStart, introductionSize.width, introductionSize.height)];
        [labelIntroduction setBackgroundColor:[UIColor clearColor]];
        [labelIntroduction setFont:kFSeatRuleContentLabelFont];
        [labelIntroduction setLineBreakMode:UILineBreakModeWordWrap];
        [labelIntroduction setNumberOfLines:0];
        [labelIntroduction setText:FLIGHT_SEAT_RULE];
        
        // 调整子窗口高宽
        spaceYStart += introductionSize.height;
        
        // 保存
        [viewParent addSubview:labelIntroduction];
    }
    
    // 间隔
    spaceYStart += kFSeatRuleScrollViewVMargin;
    
	// =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
	subsHeight = spaceYStart;
    pViewSize->height = subsHeight;
    if(viewParent != nil)
    {
        [viewParent setViewHeight:subsHeight];
    }
}

// =======================================================================
// TabelViewDataSource的代理函数
// =======================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 父窗口尺寸
    CGRect parentFrame = [tableView frame];
    
	// Item
	NSString *reusedIdentifer = @"IntroductionTCID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifer];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:reusedIdentifer];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
		
		// 创建contentView
        CGSize contentViewSize = CGSizeMake(parentFrame.size.width, 0);
        [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
        [self setupTableCellIntroduceSubs:[cell contentView] inSize:&contentViewSize];
	}
	
	return cell;
}

// =======================================================================
// TableViewDelegate的代理函数
// =======================================================================
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 父窗口尺寸
    CGRect parentFrame = [tableView frame];
    
	// Item
	CGSize contentViewSize = CGSizeMake(parentFrame.size.width, 0);
	[self setupTableCellIntroduceSubs:nil inSize:&contentViewSize];
	
	return contentViewSize.height;
}


@end
