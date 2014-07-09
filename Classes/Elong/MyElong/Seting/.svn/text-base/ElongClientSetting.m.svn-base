//
//  ElongClientSetting.m
//  ElongClient
//
//  Created by Ivan.xu on 13-12-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "ElongClientSetting.h"
#import "SettingManager.h"
#import "AdviceAndFeedback.h"
#import "FAQ.h"
#import "ShareLoginSetting.h"
#import "Update.h"
#import "AboutElongCtrl.h"
#import "LoadingView.h"

#define CELL_SWITCH_TAG 1003
static long UMFLastInterval;
static BOOL UMFEnabled;
@interface ElongClientSetting ()
@property (nonatomic,retain) NSArray *items;
@end

@implementation ElongClientSetting

- (void)dealloc
{
    self.items = nil;
    [umengUFPVC release];
    [_tableView release];
    [m_update release];
    [weixinOuthor release];
    [super dealloc];
}

- (id)init:(NSString *)name style:(NavBtnStyle)style
{
    if (self = [super init:name style:style]) {
        imageCacheSize = 0;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cacheStateIsDoing = YES;
    
    //umeng数据
    self.items = [NSArray arrayWithObjects:@"意见反馈", @"使用帮助", @"版本更新", @"关于艺龙",nil];
    
    if (UMFEnabled) {
        self.items = [NSArray arrayWithObjects:@"意见反馈", @"使用帮助", @"版本更新", @"关于艺龙",@"推荐应用",nil];
    }
    
    if ([[NSDate date] timeIntervalSince1970] - UMFLastInterval > 60 * 60) {
        self.items = [NSArray arrayWithObjects:@"意见反馈", @"使用帮助", @"版本更新", @"关于艺龙",nil];
        UMFEnabled = NO;
        
        // UMeng 推荐应用
        umengUFPVC = [UMengUFPViewController alloc];
        umengUFPVC.delegate = self;
        [umengUFPVC initWithTopImagePath:nil andTitle:@"推荐应用" style:_NavNoTelStyle_];
    }
    
    
    
	// Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = YES;
    [self.view addSubview:_tableView];
    
    m_update = [[Update alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];   //版本更新初始化
    
    // 进入后开始计算缓存大小
    [self startGetImageCacheSize];
}


- (void)startGetImageCacheSize
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(queue, ^{
        imageCacheSize = [[CacheManage manager] getCacheSizeOfImage];
        cacheStateIsDoing = NO;
		
		dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
		});
	});
}


// 清除图片缓存
- (void)clearImageCache
{
    [[LoadingView sharedLoadingView] showAlertMessageNoCancel];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(queue, ^{
        [[CacheManage manager] clearImageCache];
		
		dispatch_async(dispatch_get_main_queue(), ^{
            [[LoadingView sharedLoadingView] hideAlertMessage];
            [self startGetImageCacheSize];
		});
	});
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UMengUFPViewControllerDelegate
- (void) umengUFPVC:(UMengUFPViewController *)ufpVC statusEnable:(BOOL)enable{
    if (enable) {
        self.items = [NSArray arrayWithObjects:@"意见反馈", @"使用帮助", @"版本更新", @"关于艺龙",@"推荐应用",nil];
    }else{
        self.items = [NSArray arrayWithObjects:@"意见反馈", @"使用帮助", @"版本更新", @"关于艺龙",nil];
    }
    [_tableView reloadData];
    
    UMFLastInterval =  [[NSDate date] timeIntervalSince1970];
    UMFEnabled = enable;
    
    umengUFPVC.delegate = nil;
    NSLog(@"%@",(enable?@"UFP success...":@"UFP error...."));
}

#pragma mark - General methods
-(void)clickDisplayHotelPicSwitch:(id)sender{
	UISwitch *swc=sender;
	//[[SettingManager instanse] setDisplayPhotoIn2G:swc.on];
    [[SettingManager instanse] setDisplayHotelPic:swc.on];
}

- (void) switchWeixin:(id)sender{
    if ([[ServiceConfig share] monkeySwitch])
    {
        // 开着monkey时不发生事件
        return;
    }
    
    UISwitch *loginSwitch = (UISwitch *)sender;
	if (loginSwitch.on) {
        // 微信
        if(![WXApi isWXAppInstalled]){
            [PublicMethods showAlertTitle:nil Message:@"未发现微信客户端，请您先下载微信"];
            loginSwitch.on = NO;
            return;
        }
        if (![WXApi isWXAppSupportApi]) {
            [PublicMethods showAlertTitle:nil Message:@"您微信客户端版本过低，请您更新微信版本"];
            loginSwitch.on = NO;
            return;
        }
        // 唤起微信进行授权
        weixinOuthor = [[WeixinOuthor alloc] init];
        weixinOuthor.delegate = self;
        [weixinOuthor outhor];
	}else{
        [[ElongUserDefaults sharedInstance] removeObjectForKey:USERDEFAULT_WEIXIN_OPENID];
	}
    loginSwitch.on = NO;
}


#pragma mark - UITableView Delegate and datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 3;
    }
    else if (section == 1)
    {
        return 1;
    }
    else{
        return self.items.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"SettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell==nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
        
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
        
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44-SCREEN_SCALE, 320, SCREEN_SCALE)];
        bottomLine.tag = 4999;
        bottomLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:bottomLine];
        [bottomLine release];
        
        cell.textLabel.font = FONT_15;
        cell.textLabel.highlightedTextColor = cell.textLabel.textColor;
        cell.detailTextLabel.highlightedTextColor = cell.detailTextLabel.textColor;
        cell.detailTextLabel.font = FONT_13;
        
        UISwitch *cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(305-51, 6, 0, 0)];
        cellSwitch.frame = CGRectMake(305-cellSwitch.frame.size.width, 22-cellSwitch.frame.size.height/2, cellSwitch.frame.size.width, cellSwitch.frame.size.height);
        cellSwitch.tag = CELL_SWITCH_TAG;
        [cell.contentView addSubview:cellSwitch];
        [cellSwitch release];
    }
    UIImageView *topLine = (UIImageView *)[cell viewWithTag:4998];
    topLine.hidden = YES;
    if(indexPath.row==0){
        topLine.hidden = NO;
    }
    
    UISwitch *cellSwitch = (UISwitch *)[cell viewWithTag:CELL_SWITCH_TAG];
    cellSwitch.hidden = YES;    //默认隐藏switch
    cell.accessoryView.hidden = NO;

    if(indexPath.section==0){
        if(indexPath.row==0){
            cell.textLabel.text = @"显示酒店列表图片";
            cell.accessoryView.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cellSwitch.hidden = NO;
            [cellSwitch setOn:[[SettingManager instanse] displayHotelPic]];
            [cellSwitch addTarget:self action:@selector(clickDisplayHotelPicSwitch:) forControlEvents:UIControlEventValueChanged];
        }else if(indexPath.row==1){
            cell.textLabel.text = @"分享设置";
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"微信授权";
            cell.accessoryView.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cellSwitch.hidden = NO;
            [cellSwitch addTarget:self action:@selector(switchWeixin:) forControlEvents:UIControlEventValueChanged];
            if ([[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_WEIXIN_OPENID] == nil) {
                cellSwitch.on = NO;
            }else {
                cellSwitch.on = YES;
            }
            cell.textLabel.text = @"微信授权";
        }
    }
    else if(indexPath.section == 1)
    {
        //cell.accessoryView.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"点击清空缓存";
        
        if (cacheStateIsDoing)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"正在计算缓存大小..."];
        }
        else
        {
            if (imageCacheSize > 0)
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f  MB", imageCacheSize/1024.0/1024.0];
            }
            else
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"0  MB"];
            }
        }
    }
    else if(indexPath.section == 2){
        if(indexPath.row==0){
            cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
        }else if(indexPath.row==1){
            cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
        }else if(indexPath.row==2){
            cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
            NSString *version = [[[NSBundle mainBundle] infoDictionary] safeObjectForKey:(NSString *)kCFBundleVersionKey];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"当前版本为:V%@",version];
        }else if(indexPath.row==3){
            cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
        }else{
            cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
        }
    }
    
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
    titleLabel.textColor =[UIColor grayColor];
    [headView addSubview:titleLabel];
    [titleLabel release];
    
    if(section == 0)
    {
        titleLabel.text = @"设置";
    }else if(section == 1)
    {
        titleLabel.text = @"清除缓存";
    }
    else if (section == 2)
    {
        titleLabel.text = @"其他";
    }
    
    return [headView autorelease];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat sectionHeaderHeight = [self tableView:_tableView heightForHeaderInSection:0];
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0){
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y,0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight){
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section==0){
        if(indexPath.row==1){
            //分享设置
            ShareLoginSetting *shareSetting = [[ShareLoginSetting alloc] init];
            [self.navigationController pushViewController:shareSetting animated:YES];
            [shareSetting release];
        }
    }
    else if (indexPath.section == 1)
    {
        // 有缓存数据时清空缓存
        [self clearImageCache];
        
        UMENG_EVENT(UEvent_UserCenter_Setting_ClearCache)
    }
    else if(indexPath.section==2){
        if(indexPath.row==0){
            //意见反馈
            AdviceAndFeedback *advfeed = [[AdviceAndFeedback alloc] initWithTopImagePath:@"" andTitle:@"意见反馈" style:_NavLeftBtnImageStyle_];
			[self.navigationController pushViewController:advfeed animated:YES];
			[advfeed release];
        }else if(indexPath.row==1){
            //使用帮助
            FAQ *faq = [[FAQ alloc] initWithTopImagePath:@"" andTitle:@"使用帮助" style:_NavNoTelStyle_];
			[self.navigationController pushViewController:faq animated:YES];
			[faq release];
        }else if(indexPath.row==2){
            //版本更新
            [m_update checkUpdateFromServer];
        }else if(indexPath.row==3){
            if (UMENG) {
                // UMeng 关于我们
                [MobClick event:Event_AboutUs];
            }
            //关于艺龙
            AboutElongCtrl *controller = [[AboutElongCtrl alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }else if(indexPath.row == 4){
            if ([[ServiceConfig share] monkeySwitch]){
                // 开着monkey时不发生事件
                return;
            }
            
            if (!umengUFPVC) {
                umengUFPVC = [UMengUFPViewController alloc];
                umengUFPVC.delegate = nil;
                [umengUFPVC initWithTopImagePath:nil andTitle:@"推荐应用" style:_NavNoTelStyle_];
                [self.navigationController pushViewController:umengUFPVC animated:YES];
                [umengUFPVC release];
                umengUFPVC = nil;
            }else{
                [self.navigationController pushViewController:umengUFPVC animated:YES];
                [umengUFPVC release];
                umengUFPVC = nil;
            }
        }
    }
}


#pragma mark -
#pragma mark WeixinOuthorDelegate
- (void) weixinOuthor:(WeixinOuthor *)weixinOuthor didGetToken:(NSDictionary *)token{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UISwitch *weixinAuthorSwitch = (UISwitch *)[cell.contentView viewWithTag:CELL_SWITCH_TAG];
    weixinAuthorSwitch.on = YES;
}

@end
