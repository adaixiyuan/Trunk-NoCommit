//
//  TrainOrderTicketRuleVC.m
//  ElongClient
//
//  Created by bruce on 13-12-21.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainOrderTicketRuleVC.h"
#import "AttributedLabel.h"

// ==================================================================
// 布局参数
// ==================================================================

//控件间距
#define	kTOrderRuleScrollViewHMargin					10
#define	kTOrderRuleScrollViewVMargin					10
#define kTOrderRulekScrollCellHMargin					10

//控件字体
#define	kTOrderRuleContentLabelFont                     [UIFont systemFontOfSize:13.0f]



#define TICKET_RULE     @"取票：\n1）确认出票成功后，您需携带预订时使用的有效身份证件前往火车站售票窗口或代售点换取纸质车票后乘车，部分高铁动车车次支持刷二代身份证直接检票乘车。\n2）二代身份证无法自动识别或者使用其他有效身份证购买的，需出示乘车人有效身份证原件和窗口取票号（短信中以大写字母E开头的号码）到车站窗口或代售点办理换票手续。\n3）代售点收取代售费5元/张。另外车站售票窗口取异地票，火车站将收取代售费5元/张。此项收费与艺龙无关。\n4）暂无配送服务。\n\n退改签：\n1）艺龙暂不提供改签服务,需您自行携带购票时使用的有效证件原件和火车票。在火车发车前前去始发地火车站窗口办理.如果改签过程中产生的应退票款,我们将会在3-20个工作日内原渠道退还.\n2）特别提示：铁路局规定车票只能改签一次；已经改签的车票不能再次改签，但可在改签后车票载明的列车开车前退票。\n\n退款：\n1）订单已出票且未换取纸质车票，在发车前4小时可以在“我的艺龙”中在线申请退票。我们在线退票处理时间是7:00-23:00.非工作时间或者已取票的乘客，如需退票，请凭购票时的有效证件在发车前到火车站退票窗口办理退票。\n2）根据铁路局退票规定：退票手续费收取：票面乘车站开车时间前48小时以上的按票价5%计，24小时以上、不足48小时的按票价10%计，不足24小时的按票价20%计。并按照最低 2元/张收取退票费。最终退款以铁路局实退为准。\n\n无票、取消订单到账说明：\n由于各铁路局相关政策、火车票票源紧张等原因，支付后无法保证100%出票成功。\n1）无票或取消订单退款到账说明：退款到帐时间约为3-21天（15个工作日内）；应退票款按银行规定时限退还至购票时所使用的银行卡（原渠道返还），请注意查收。\n2）特别注意事项:若您看到订单状态为“已退款”但久未收到退款,由于退款涉及个人账号隐私，请您凭当时支付的交易号咨询相应支付宝平台客服热线:\n     支付宝平台客服热线：95188(7*24小时服务，需支付交易号)\n3）如需退票报销凭证，请凭购票所使用的乘车人有效身份证件原件和订单号码在办理退票之日起10日到车站退票窗口索取。"

@implementation TrainOrderTicketRuleVC




- (id)init
{
    if (self = [super initWithTopImagePath:@"" andTitle:@"取票退票规则" style:_NavOnlyBackBtnStyle_])
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
	[tableViewInfo release];
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
	spaceXStart += kTOrderRuleScrollViewHMargin;
	spaceXEnd -= kTOrderRuleScrollViewHMargin;
	spaceYStart += kTOrderRuleScrollViewVMargin;
	
    // =======================================================================
	// 车票规则 Label
	// =======================================================================
    if ((TICKET_RULE != nil) && ([TICKET_RULE length] > 0))
    {
        CGSize introductionSize = [TICKET_RULE sizeWithFont:kTOrderRuleContentLabelFont
                                          constrainedToSize:CGSizeMake(spaceXEnd - spaceXStart, CGFLOAT_MAX)
                                              lineBreakMode:UILineBreakModeWordWrap];
        
        // 创建Label
        AttributedLabel *labelIntroduction = [[AttributedLabel alloc] initWithFrame:CGRectMake(spaceXStart, spaceYStart, introductionSize.width, introductionSize.height+kTOrderRuleScrollViewVMargin*2) wrapped:YES];
        [labelIntroduction setText:TICKET_RULE];
        [labelIntroduction setBackgroundColor:[UIColor clearColor]];
        [labelIntroduction setFont:kTOrderRuleContentLabelFont fromIndex:0 length:[TICKET_RULE length]];
        [labelIntroduction setColor:[UIColor redColor] fromIndex:611 length:38];
        [labelIntroduction setColor:[UIColor redColor] fromIndex:666 length:61];
        
        // 调整子窗口高宽
        spaceYStart += introductionSize.height+kTOrderRuleScrollViewVMargin*2;
        
        // 保存
        [viewParent addSubview:labelIntroduction];
        [labelIntroduction release];
    }
    
    // 间隔
    spaceYStart += kTOrderRuleScrollViewVMargin;
    
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
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:reusedIdentifer] autorelease];
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


- (void)dealloc
{
    [super dealloc];
}

@end
