//
//  CashAccountFaqVC.m
//  ElongClient
//  
//
//  Created by 赵 海波 on 13-8-12.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "CashAccountFaqVC.h"

#define kCellTopMargin  (20)
#define kCellTextTopMargin (10)
#define kCellTitleFontSize  (14)
#define kCellTextFontSize   (14)


@interface CashAccountFaqVC ()

@end

@implementation CashAccountFaqVC

- (void)dealloc
{
    [_introductionList release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        NSMutableArray *array = [NSMutableArray array];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic safeSetObject:@"1、什么是艺龙礼品卡？" forKey:@"Title"];
        [dic safeSetObject:@"      艺龙礼品卡是艺龙针对企业福利、年会奖项、活动礼品、商务及个人馈赠发行的用于网上旅游预订的礼品卡，包括“通用礼品卡”和“专用礼品卡”两种。\n"
         "      “通用礼品卡”支持在艺龙购买预付类酒店、国际酒店、团购、机票产品；\n"
         "      “专用礼品卡”支持在艺龙购买除机票以外的预付类酒店、国际酒店、团购产品。" forKey:@"Text"];
        [array addObject:dic];
        
        dic = [NSMutableDictionary dictionary];
        [dic safeSetObject:@"2、如何使用艺龙礼品卡？" forKey:@"Title"];
        [dic safeSetObject:@"      通过艺龙礼品卡上的卡号和密码，可将相应金额充值到“我的艺龙现金账户”\n"
         "1）充值办法：\n"
         "      登录后，进入“我的账户”→“我的艺龙现金账户”→”艺龙礼品卡/红包充值”→输入正确的卡号与密码→充值成功。\n"
         "2）	充值成功后：\n"
         "      购买预付类产品，在支付方式选择页，可使用“我的艺龙现金账户金额”进行支付。"
         "（首次充值礼品卡，您需设置提高安全性的“支付密码”）。" forKey:@"Text"];
        [array addObject:dic];
        
        dic = [NSMutableDictionary dictionary];
        [dic safeSetObject:@"3、什么是红包？" forKey:@"Title"];
        [dic safeSetObject:@"      红包是艺龙通过买赠、活动参与等形式发放给用户，用于减免购买支付的优惠方式。红包可通过艺龙无线客户端、艺龙网站www.elong.com进行使用，适用产品包括国内预付类酒店、机票、团购等，具体可使用产品及使用额度以产品展示为准。红包从形式上分为实体密码券和账户电子券两种，用户可在个人中心查询红包余额及有效日期等信息。" forKey:@"Text"];
        [array addObject:dic];
        
        dic = [NSMutableDictionary dictionary];
        [dic safeSetObject:@"4、礼品卡/红包充值的金额可以提现或充值手机吗？" forKey:@"Title"];
        [dic safeSetObject:@"不能。\n"
         "由礼品卡/红包充值进入“艺龙现金账户”的金额不可以提取现金或充值手机话费，过期作废、不转至积分。" forKey:@"Text"];
        [array addObject:dic];
        
        dic = [NSMutableDictionary dictionary];
        [dic safeSetObject:@"5、如何购买“艺龙礼品卡”？" forKey:@"Title"];
        [dic safeSetObject:@"联系电话：010-58602288-6757\n联系邮箱：giftcard@corp.elong.com\n" forKey:@"Text"];
        [array addObject:dic];
        
        dic = [NSMutableDictionary dictionary];
        [dic safeSetObject:@"6、使用“艺龙现金账户”购买产品，是否提供发票？" forKey:@"Title"];
        [dic safeSetObject:@"当订单总额全部由“艺龙现金账户”支付时，艺龙将不能为您开具发票。" forKey:@"Text"];
        [array addObject:dic];
        
        self.introductionList = array;
        
        int offX = 0;
        UIView *topView = [[UIView alloc] init];
        NSString *titleStr = @"礼品卡说明";
        CGSize size = [titleStr sizeWithFont:FONT_B18];
		if (size.width >= 200) {
			size.width = 195;
		}
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offX + 3, 13, size.width, 18)];
		label.tag = 101;
		label.backgroundColor	= [UIColor clearColor];
		label.font				= FONT_B18;
		label.textColor			= RGBACOLOR(52, 52, 52, 1);
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
        
        UITableView *mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT-20-44) style:UITableViewStylePlain];
        mainTable.dataSource = self;
        mainTable.delegate = self;
        mainTable.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:mainTable];
        [mainTable release];
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
    if(cell==nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:cellName] autorelease];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        
        
        UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        titleLabel.tag = 1024;
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.font = [UIFont boldSystemFontOfSize:kCellTitleFontSize];
        titleLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:titleLabel];
        titleLabel.textColor = RGBACOLOR(52, 52, 52, 1);
        
        
        UILabel *textLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        textLabel.tag = 1025;
        textLabel.numberOfLines = 0;
        textLabel.lineBreakMode = UILineBreakModeWordWrap;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont systemFontOfSize:kCellTextFontSize];
        textLabel.textColor = RGBACOLOR(52, 52, 52, 1);
        [cell.contentView addSubview:textLabel];
    }

    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:1024];
    CGSize titleSize = [[[self.introductionList safeObjectAtIndex:indexPath.row] safeObjectForKey:@"Title"] sizeWithFont:[UIFont boldSystemFontOfSize:kCellTitleFontSize] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    titleLabel.frame = CGRectMake(10, kCellTopMargin, 300, titleSize.height);
    titleLabel.text = [[self.introductionList safeObjectAtIndex:indexPath.row] safeObjectForKey:@"Title"];
    
    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:1025];
    CGSize textSize = [[[self.introductionList safeObjectAtIndex:indexPath.row] safeObjectForKey:@"Text"] sizeWithFont:[UIFont systemFontOfSize:kCellTextFontSize] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    textLabel.frame = CGRectMake(10, kCellTopMargin + titleSize.height + kCellTextTopMargin, 300, textSize.height);
    textLabel.text = [[self.introductionList safeObjectAtIndex:indexPath.row] safeObjectForKey:@"Text"];
    cell.selectionStyle = UITableViewCellEditingStyleNone;

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGSize titleSize = [[[self.introductionList safeObjectAtIndex:indexPath.row] safeObjectForKey:@"Title"] sizeWithFont:[UIFont boldSystemFontOfSize:kCellTitleFontSize] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize textSize = [[[self.introductionList safeObjectAtIndex:indexPath.row] safeObjectForKey:@"Text"] sizeWithFont:[UIFont systemFontOfSize:kCellTextFontSize] constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"%f",kCellTopMargin + titleSize.height + kCellTextTopMargin + textSize.height);
    return kCellTopMargin + titleSize.height + kCellTextTopMargin + textSize.height;
}

@end
