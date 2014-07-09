//
//  ShareLoginSetting.m
//  ElongClient
//
//  Created by Ivan.xu on 13-12-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "ShareLoginSetting.h"
#import "ShareKit.h"
#import "ShareTools.h"

#define LoginSwitchTag 1001

@interface ShareLoginSetting ()

@end

@implementation ShareLoginSetting

- (id)init {
    if (self = [super initWithTopImagePath:@"" andTitle:@"分享设置" style:_NavOnlyBackBtnStyle_])
    {
    }
	
    return self;
}

- (void) dealloc{
    [weixinOuthor release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - General Methods

-(void)switchSina:(id)sender
{
    if ([[ServiceConfig share] monkeySwitch])
    {
        // 开着monkey时不发生事件
        return;
    }
    
    UISwitch *loginSwitch = (UISwitch *)sender;
    ShareKit *shareKit = [ShareKit instance];
	ShareTools *shareTools = [ShareTools shared];
	shareTools.contentViewController = self;
	if (loginSwitch.on) {
        [shareKit loginSinaWithType:@"login"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSinaSuccess) name:@"loginSinaSuccess" object:nil];
	}else{
        [shareKit deleteSinaAuthInfo];
	}
    loginSwitch.on = NO;
}

-(void)switchTencent:(id)sender
{
    if ([[ServiceConfig share] monkeySwitch])
    {
        // 开着monkey时不发生事件
        return;
    }
    
    UISwitch *loginSwitch = (UISwitch *)sender;
    ShareKit *shareKit = [ShareKit instance];
	ShareTools *shareTools = [ShareTools shared];
	shareTools.contentViewController = self;
	if (loginSwitch.on) {
        [shareKit loginTencentWithType:@"login"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginTencentSuccess) name:@"loginTencentSuccess" object:nil];
	}else{
        [shareKit deleteTencentAuthInfo];
	}
    loginSwitch.on = NO;
}


- (void) switchWeixin:(id)sender{
    if ([[ServiceConfig share] monkeySwitch])
    {
        // 开着monkey时不发生事件
        return;
    }
    
    UISwitch *loginSwitch = (UISwitch *)sender;
	if (loginSwitch.on) {
        // 唤起微信进行授权
        weixinOuthor = [[WeixinOuthor alloc] init];
        weixinOuthor.delegate = self;
        [weixinOuthor outhor];
	}else{
        [[ElongUserDefaults sharedInstance] removeObjectForKey:USERDEFAULT_WEIXIN_OPENID];
	}
    loginSwitch.on = NO;
}



-(void)loginSinaSuccess{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UISwitch *loginSwitch = (UISwitch *)[cell.contentView viewWithTag:LoginSwitchTag];
    loginSwitch.on = YES;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginSinaSuccess" object:nil];
}

-(void)loginTencentSuccess{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UISwitch *loginSwitch = (UISwitch *)[cell.contentView viewWithTag:LoginSwitchTag];
    loginSwitch.on = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginTencentSuccess" object:nil];
}


#pragma mark - UITableView Delegate and datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"ShareLoginCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell==nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];

        UISwitch *loginSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(305-0, 6, 0, 0)];
        loginSwitch.frame = CGRectMake(305-loginSwitch.frame.size.width, 22-loginSwitch.frame.size.height/2, loginSwitch.frame.size.width, loginSwitch.frame.size.height);
        loginSwitch.tag = LoginSwitchTag;
        [cell.contentView addSubview:loginSwitch];
        [loginSwitch release];
        
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
        
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44-SCREEN_SCALE, 320, SCREEN_SCALE)];
        bottomLine.tag = 4999;
        bottomLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:bottomLine];
        [bottomLine release];
        
        cell.textLabel.font = FONT_15;
        cell.textLabel.highlightedTextColor = cell.textLabel.textColor;
    }
    UIImageView *topLine = (UIImageView *)[cell viewWithTag:4998];
    topLine.hidden = YES;
    if(indexPath.row==0){
        topLine.hidden = NO;
    }
    
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    UISwitch *loginSwitch = (UISwitch *)[cell.contentView viewWithTag:LoginSwitchTag];
    if(indexPath.row==0){
        //新浪微博
        cell.imageView.image = [UIImage imageNamed:@"sina_weibo.png"];
        cell.textLabel.text = @"新浪微博";
        
        [loginSwitch addTarget:self action:@selector(switchSina:) forControlEvents:UIControlEventValueChanged];
        if ([info objectForKey:@"sina_access_tokenV2"] == nil) {
            loginSwitch.on = NO;
        }else if (![[ShareKit instance] checkTime:[info objectForKey:@"SinaLastTime"]]) {
            loginSwitch.on = NO;
        }else{
            loginSwitch.on = YES;
        }
        
    }else if(indexPath.row==1){
        //腾讯微博
        cell.imageView.image = [UIImage imageNamed:@"tencent_weibo.png"];
        cell.textLabel.text = @"腾讯微博";
        
        [loginSwitch addTarget:self action:@selector(switchTencent:) forControlEvents:UIControlEventValueChanged];
        if ([info objectForKey:@"TX_accessToken"] == nil) {
            loginSwitch.on = NO;
        }else if (![[ShareKit instance] checkTime:[info objectForKey:@"TencentLastTime"]]) {
            loginSwitch.on = NO;
        }else{
            loginSwitch.on = YES;
        }
    }else if(indexPath.row == 2){
        // 微信登录
        cell.imageView.image = [UIImage imageNamed:@"tencent_weixin.png"];
        cell.textLabel.text = @"微信授权";
        [loginSwitch addTarget:self action:@selector(switchWeixin:) forControlEvents:UIControlEventValueChanged];
        if ([info objectForKey:USERDEFAULT_WEIXIN_OPENID] == nil) {
            loginSwitch.on = NO;
        }else {
            loginSwitch.on = YES;
        }

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-10, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = FONT_13;
    titleLabel.textColor =[UIColor darkGrayColor];
    [headView addSubview:titleLabel];
    [titleLabel release];
    
    titleLabel.text = @"绑定";
 
    return [headView autorelease];
}


#pragma mark -
#pragma mark WeixinOuthorDelegate
- (void) weixinOuthor:(WeixinOuthor *)weixinOuthor didGetToken:(NSDictionary *)token{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UISwitch *loginSwitch = (UISwitch *)[cell.contentView viewWithTag:LoginSwitchTag];
    loginSwitch.on = YES;
}
@end
