//
//  UserInfoSettingVC.m
//  ElongClient
//
//  Created by 赵 海波 on 13-7-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "UserInfoSettingVC.h"
#import "GroupStyleCell.h"
#import "JCustomer.h"
#import "MyElongPostManager.h"
#import "ElongURL.h"
#import "Customers.h"
#import "Card.h"
#import "Address.h"
#import "MyElongCenter.h"

#define GETCUSTOM_STATE 2
#define GETCARD_STATE 3
#define GETADDRESS_STATE 4

@interface UserInfoSettingVC ()

@end

@implementation UserInfoSettingVC

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self.view window] == nil) {
        self.view = nil;
    }
}

- (id)init
{
    self = [super initWithTopImagePath:@"" andTitle:@"常用信息设置" style:_NavNormalBtnStyle_];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundView = nil;
    [self.view addSubview:table];
    [table release];
    
    
}


#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, 18, 5, 9)];
        rightArrow.image = [UIImage imageNamed:@"ico_rightarrow.png"];
        cell.accessoryView =rightArrow;
        [rightArrow release];
        
        UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
        bgView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = bgView;
        [bgView release];
        
        UIImageView *selectedBgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        selectedBgView.image = COMMON_BUTTON_PRESSED_IMG;
        cell.selectedBackgroundView  = selectedBgView;
        [selectedBgView release];
        
        //第一行
        UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)];
        topLine.tag = 4998;
        topLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:topLine];
        [topLine release];
        
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44- SCREEN_SCALE, 320, SCREEN_SCALE)];
        bottomLine.tag = 4999;
        bottomLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:bottomLine];
        [bottomLine release];
        
        cell.textLabel.font = FONT_15;
        cell.textLabel.highlightedTextColor = cell.textLabel.textColor;
    }
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"常用旅客信息";
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = @"常用信用卡信息";
    }
    else
    {
        cell.textLabel.text = @"常用地址信息";
    }
    
    UIImageView *topLine = (UIImageView *)[cell viewWithTag:4998];
    topLine.hidden = YES;
    if(indexPath.row==0){
        topLine.hidden = NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            // 点击常用旅客
            m_netstate = GETCUSTOM_STATE;
			JCustomer *jcus = [MyElongPostManager customer];
			[jcus clearBuildData];
			[Utils request:MYELONG_SEARCH req:[jcus requesString:YES] delegate:self];
            
            UMENG_EVENT(UEvent_UserCenter_Home_Passengers)
        }
            break;
        case 1:
        {
            // 点击常用信用卡
            m_netstate = GETCARD_STATE;
			JCard *jcard=[MyElongPostManager card];
			[jcard clearBuildData];
			[Utils request:MYELONG_SEARCH req:[jcard requesString:YES] delegate:self];
            
            UMENG_EVENT(UEvent_UserCenter_Home_CreditCards)
        }
            break;
        case 2:
        {
            // 点击常用地址
            m_netstate = GETADDRESS_STATE;
			JGetAddress *jads=[MyElongPostManager getAddress];
			[jads clearBuildData];
			[Utils request:MYELONG_SEARCH req:[jads requesString:YES] delegate:self];
            
            UMENG_EVENT(UEvent_UserCenter_Home_Addresses)
        }
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark iHttp

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSDictionary *root = [PublicMethods unCompressData:responseData];
    	
	if ([Utils checkJsonIsError:root]) {
		return ;
	}
    
    switch (m_netstate) {
        case GETCUSTOM_STATE:
        {
            // 进入常用旅客页
            NSArray *customerArray = [root safeObjectForKey:@"Customers"];
            [[MyElongCenter allUserInfo] removeAllObjects];
            if (ARRAYHASVALUE(customerArray)) {
                [[MyElongCenter allUserInfo] addObjectsFromArray:customerArray];
            }
            
            Customers *customers = [[Customers alloc] initWithTopImagePath:@"" andTitle:@"常用旅客信息" style:_NavOnlyBackBtnStyle_];
            [self.navigationController pushViewController:customers animated:YES];
            [customers release];
        }
            break;
        case GETCARD_STATE:
        {
            // 进入常用信用卡页
            NSArray *cardArray;
            if ([root safeObjectForKey:@"CreditCards"] == [NSNull null]) {
                cardArray = [[[NSArray alloc] initWithObjects:nil] autorelease];
            }
            else {
                cardArray = [root safeObjectForKey:@"CreditCards"];
            }
            
            [[MyElongCenter allCardsInfo] removeAllObjects];
            [[MyElongCenter allCardsInfo] addObjectsFromArray:cardArray];
            
            Card *card = [[Card alloc] init];
            
            [self.navigationController pushViewController:card animated:YES];
            [card release];
        }
            break;
        case GETADDRESS_STATE:
        {
            // 进入常用地址页
            NSArray *addressArray = [root safeObjectForKey:@"Addresses"];
            [[MyElongCenter allAddressInfo] removeAllObjects];
            if (ARRAYHASVALUE(addressArray)) {
                [[MyElongCenter allAddressInfo] addObjectsFromArray:addressArray];
            }
            Address *address = [[Address alloc] initWithTopImagePath:@"" andTitle:@"常用地址信息" style:_NavOnlyBackBtnStyle_];
            [self.navigationController pushViewController:address animated:YES];
            [address release];
        }
            break;
        default:
            break;
    }
}

@end
