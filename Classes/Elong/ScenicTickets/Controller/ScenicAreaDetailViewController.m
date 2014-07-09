//
//  ScenicAreaDetailViewController.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-5-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicAreaDetailViewController.h"
#import "ScenicTicketsPublic.h"
#import "ScenicUtils.h"
#import "ScenicDetail.h"
#import "ScenicSimpleCell.h"
#import "ClassAddition.h"
#import "ScenicRecommand.h"
#import "ScenicBookingTable.h"
#import "UIViewExt.h"
#import "ScenicWebViewController.h"
#import "ScenicThumbnailPicVC.h"
#import "ScenicLocationMapVC.h"
#import "ScenicIntroCell.h"
#import "UIImageView+WebCache.h"

#define TAG_BookingTable 1001
#define TAG_Booking_BottomLine 1002

#define Booking_SectionHeight 44
#define Booking_CellHeight 65

#define Scenery_Height 155

@interface ScenicAreaDetailViewController ()

@end

@implementation ScenicAreaDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.type = ScenicTicketType_CanBooking;
        //self.type = ScenicTicketType_NoBooking;
        
//        self.scenerySummary = @"全新的北京杜莎夫人蜡像馆，位于前门大街，是默林娱乐集团2014年建立的新景点之一，预计于2014年5月底开幕。杜莎夫人蜡像馆进驻前门，除了能让观众与世界级的明星们零距离接触、互动、合影，还融入了北京当地特色，充分体现了东西方传统文化与现代艺术的碰撞与交融。馆内设有8个主题区,其中特设北京独有的“中国精神”展区。准备好加入北京最具吸引力的互动体验了吗？我们诚邀您到访京城最热门的杜莎夫人蜡像馆，与众多光芒耀眼的名人们面对面!";

        NSString *html = @"<div class='tcbuyNotice'><strong>开放时间<>:09:00-24:00<br/><strong>取票地点<>:烟台海昌雨岱山温泉前台<br/><strong>入园凭证<>:同程网预订成功确认订单短信。<br/><strong>特惠政策<>:<p>A.免票政策：身高1.2米以下的儿童免费。<br/>B.优惠政策：1.2米-1.4米之间的儿童购景区优惠票<span style=\"color: #ff0000;\">（上述优惠政策，需到景区自行购买）</span>。</p><br/><strong>退改规则<>:<p><span style=\"color: #333333;\">①如需修改出游日期，请登录同程旅游订单中心自行修改，或重新预订门票。<br/>②如需取消订单，请您登录同程旅游订单中心取消或回复同程旅游短信取消。<br/></span></p><p align=\"left\"><span style=\"color: #333333;\">&nbsp;</span></p><p>&nbsp;</p><br/><strong>温馨提示<>:<p>①预订门票包含：岩盘浴大厅、汤池、特色蒸房、洗漱用品、休息大厅。<br/>②另付费项目：饮料、茶水、餐饮、裕服。<br/><span style=\"color: #ff0000;\">③每名成人仅限带一名1.2米以下同性别儿童入馆，超出儿童需购买儿童票。</span><br/>④门票当天有效，出园后需再入园，请再次购票。<br/>⑤为保证取票、入园顺利，预订时请务必填写真实姓名、手机号码等信息。</p></div>";
        
        self.orderTip = [ScenicUtils flattenHTML:html trimWhiteSpace:YES];

    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.mainImageURL = nil;
    [_heightArray release];
    self.scenicDetail = nil;
    [_tableView release];
    self.scenerySummary = nil;
    self.orderTip = nil;
    setFree(_bookingTable);
    [super dealloc];
}

#pragma  mark
#pragma  mark  /****************Http****************/

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    
    
    NSDictionary  *root = [PublicMethods  unCompressData:responseData];
    
    if ([Utils checkJsonIsError:root])
    {
        return ;
    }
}

#pragma  mark
#pragma  mark  /***************UIRelated*********************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getHeightFromGivenScenicDetail:self.scenicDetail];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, NAVBAR_ITEM_WIDTH, NAVBAR_ITEM_HEIGHT)];
    [btn setImage:[UIImage imageNamed:@"favBtn_blue.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"favBtn_have.png"] forState:UIControlStateDisabled];
    [btn addTarget:self action:@selector(collectTheFavScenery:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    
	// Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44-20) style:UITableViewStylePlain];
    _tableView.delegate  = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

#pragma mark
#pragma mark /***************Events*********************/

-(void)collectTheFavScenery:(id)sender{

    //
    
}

-(void)tapTheImageBtn{
    //九宫格显示图片
    ScenicThumbnailPicVC *thumbnail = [[ScenicThumbnailPicVC alloc] initWithTitle:@"图片展示" style:NavBarBtnStyleOnlyBackBtn];
    NSLog(@"%d",[_scenicDetail retainCount]);
    [thumbnail setExtInfoOfImageList:self.scenicDetail.extInfoOfImageList ImageList:self.scenicDetail.imageList];
    [self.navigationController pushViewController:thumbnail animated:YES];
    [thumbnail release];
}

-(void)adjustBookingTableHeightWithOpenDic:(NSDictionary *)openDic andDataSource:(NSDictionary *)dataSource{

    int sub_open = 0;
    NSArray *array = [openDic allKeys];
    for (NSString *key in array) {
        NSNumber *value = [openDic objectForKey:key];
        if (![value boolValue]) {
            NSArray *countNum = [dataSource objectForKey:key];
            sub_open += [countNum count];
        }
    }
    CGFloat height = sub_open*Booking_CellHeight+Booking_SectionHeight*[array count];
    [_heightArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%f",height]];
    [_tableView reloadData];
}

-(void)getHeightFromGivenScenicDetail:(ScenicDetail *)detail{

    NSMutableArray *array = nil;
    
    CGFloat location_height = [ScenicUtils getTheStringHeight:detail.sceneryAddress FontSize:13.0f Width:260];
    CGFloat notice_height = [ScenicUtils getTheStringHeight:detail.buyNotie FontSize:13.0f Width:200];
    if (self.type == ScenicTicketType_CanBooking) {
        int section_num = [detail.policyList count];
        CGFloat booking_height = section_num *Booking_SectionHeight;
        array = [[NSMutableArray alloc] initWithObjects:
                    @"88",
                 [NSString stringWithFormat:@"%f",MAX(60, location_height)],
                 [NSString stringWithFormat:@"%f",MAX(44, notice_height)],
                 [NSString stringWithFormat:@"%f",MAX(44, booking_height)],
                 nil];
    }else{
        if (detail.nearbySceneryList && [detail.nearbySceneryList count] != 0) {
            CGFloat near_height = Scenery_Height;
            array = [[NSMutableArray alloc] initWithObjects:
                     @"88",
                     [NSString stringWithFormat:@"%f",MAX(60, location_height)],
                     [NSString stringWithFormat:@"%f",MAX(44, near_height)],
                     nil];
        }
    }
    if (array) {
        _heightArray = [[NSMutableArray alloc] init];
        [_heightArray addObjectsFromArray:array];
        [array release];
        
        [_tableView reloadData];
        
    }else{
        NSLog(@"There is An Error When you get the Table Content height !");
    }
}

//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 15;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark
#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return (self.type == ScenicTicketType_CanBooking)?4:3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [[_heightArray objectAtIndex:indexPath.section] floatValue];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (self.type == ScenicTicketType_CanBooking) {
        return 15;
    }else{
        if (section == 2) {
            return 30;
        }else{
            return 15;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.type == ScenicTicketType_NoBooking) {
        if (section == 2) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
            label.backgroundColor = [UIColor clearColor];
            label.font = FONT_12;
            label.text = @"    抱歉,本景点不支持门票预订,我们为您推荐以下景点:";
            return [label autorelease];
        }else{
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
            v.backgroundColor    = [UIColor clearColor];
            return [v autorelease];
        }
    }else{
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        v.backgroundColor    = [UIColor clearColor];
        return [v autorelease];
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {

    static NSString *CellIdentifier0 = ScenicSimpleCell_Loaction;
    static NSString *CellIdentifier1 = ScenicSimpleCell_Intro;
    static NSString *CellIdentifier2 = ScenicSimpleCell_Notice;
    static NSString *CellIdentifier3 = @"";
    if (self.type == ScenicTicketType_CanBooking) {
        CellIdentifier3 = ScenicCell_Booking;
    }else{
        CellIdentifier3 = ScenicCell_Recommand;
    }
    
    CGFloat height = [[_heightArray objectAtIndex:indexPath.section] floatValue];
    
    if (indexPath.section == 0) {
        ScenicIntroCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ScenicIntroCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        [cell.mainImage setImageWithURL:[NSURL URLWithString:self.mainImageURL] placeholderImage:nil options:SDWebImageCacheMemoryOnly];
        cell.scenicIntro.text = self.scenerySummary;
        return cell;
    }else if (indexPath.section == 1){
        ScenicSimpleCell *cell = (ScenicSimpleCell *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier0];
        if (cell == nil) {
            cell = [[[ScenicSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier0 Height:height] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.location.text = self.scenicDetail.sceneryAddress;
        return cell;
        
    }else if (indexPath.section == 2){
        if (self.type == ScenicTicketType_CanBooking) {
            ScenicSimpleCell *cell = (ScenicSimpleCell *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier2];
            if (cell == nil) {
                cell = [[[ScenicSimpleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2 Height:height] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.simpleNotice.text = self.scenicDetail.buyNotie;
            cell.height = height;
            return cell;
        }else{
            //不可预订
            ScenicRecommand *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ScenicRecommand" owner:self options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.height = height;
            
            cell.type = ScenicRecommandType_Around;
            cell.TypeName.text = @"附近景点推荐";
            [cell bindSceneryModelArray:self.scenicDetail.nearbySceneryList];
            return cell;
        }
    }else if (indexPath.section == 3){
        
        if (self.type == ScenicTicketType_CanBooking) {
            //
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3] autorelease];
                [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)]];
            }
            if (!_bookingTable) {
                _bookingTable = [[ScenicBookingTable alloc] initWithFrame:CGRectMake(0, SCREEN_SCALE, SCREEN_WIDTH,height-SCREEN_SCALE*2) andArray:self.scenicDetail.policyList];
                _bookingTable.delegate = self;
                [cell addSubview:_bookingTable];
            }
            [_bookingTable setHeight:height];

            return cell;
        }
    }
    return nil;
}

#pragma  mark
#pragma  mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        //Summary
        ScenicWebViewController *web = [[ScenicWebViewController alloc] initWithTitle:@"简介" style:NavBarBtnStyleNormalBtn];
        web.webHtml = @"<h4 class=\"intro_head\">去<font size=\"+0\">烟台海昌雨岱山温泉</font>的N大理由</h4><!-- 简介模块头部 --><ul class=\"reason_ul\"><!-- 理由无序列表 --><li><span>理由1</span><p>烟台海昌雨岱山温泉水取自地下1800米，含有丰富的矿物质及人体所需的锶离子、硫离子、偏硅酸和碳酸氢根等多种微量元素，符合理疗温泉水质标准，其中锶离子的含量高达138.5mg/L。</p></li><li><span>理由2</span><p>在温度42℃-50℃、湿度50-60%的环境内，岩盘浴大厅内铺就的自然矿石板可完全释放出对人体有益的远红外线和高浓度负氧离子，促使皮肤深层大量排汗，可有效排出体内毒素，有减轻关节疼痛、加快新陈代谢、增强细胞活力、提高免疫力、降低血脂、消除疲劳之功效。</p></li><li><span>理由3</span><p>烟台海昌雨岱山温泉拥有功能齐全的榻榻米客房，客房的装饰风格古意淡然，格调高雅、宽畅明亮。其中包含豪华单人房、豪华标准房、温泉海景套房等。每个房间都拥有独立的露天观景平台和温泉泡池，将温泉水直接引入客房。</p></li></ul><h4 class=\"intro_head\">同程驴友这样评价<font size=\"+0\">烟台海昌雨岱山温泉</font></h4><div class=\"assess_div\"><!-- 评论 --><dl class=\"assess\"><dd>早就听说泡温泉对身体有益，今天去了雨岱山温泉，感觉真的很棒。</dd><dt>&mdash; &mdash;狼</dt></dl><dl class=\"assess\"><dd>第一次浸温泉哦，还不错啦，订了票，比前台买票便宜哦。</dd><dt>&mdash; &mdash;胡茬</dt></dl><dl class=\"assess\"><dd>感觉很棒，可以介绍朋友来玩，环境各方面都很棒。</dd><dt>&mdash; &mdash;蓄势腾飞</dt></dl></div><h4 class=\"intro_head\"><font size=\"+0\">烟台海昌雨岱山温泉</font>详情</h4><dl class=\"intro_information\"><!-- 简介信息 --><dt><span>游玩景点</span>烟台海昌雨岱山温泉</dt><dd><!-- 景区介绍 --><p>烟台海昌雨岱山温泉水取自地下1800米，含有丰富的矿物质及人体所需的锶离子、硫离子、偏硅酸和碳酸氢根等多种微量元素，符合理疗温泉水质标准，其中锶离子的含量高达138.5mg/L。</p><div><img style=\"width: 900px; height: 500px;\" src=\"http://upload.17u.com/uploadfile/2013/12/11/2/201312111437224413710.jpg\" alt=\"\" /> <span></span></div><div>&nbsp;</div></dd><dd><div><img style=\"width: 900px; height: 500px;\" src=\"http://upload.17u.com/uploadfile/2013/12/11/2/201312111437189586132.jpg\" alt=\"\" /> <span></span></div></dd><dt><span>游玩景点</span>烟台海昌雨岱山温泉</dt><dd><!-- 景区介绍 --><p>在温度42℃-50℃、湿度50-60%的环境内，岩盘浴大厅内铺就的自然矿石板可完全释放出对人体有益的远红外线和高浓度负氧离子，促使皮肤深层大量排汗，可有效排出体内毒素，有减轻关节疼痛、加快新陈代谢、增强细胞活力、提高免疫力、降低血脂、消除疲劳之功效。</p><div><img style=\"width: 900px; height: 500px;\" src=\"http://upload.17u.com/uploadfile/2013/12/11/2/201312111437156225760.jpg\" alt=\"\" /> <span></span></div><div>&nbsp;</div></dd><dd><div><img style=\"width: 900px; height: 500px;\" src=\"http://upload.17u.com/uploadfile/2013/12/11/2/201312111437106399961.jpg\" alt=\"\" /> <span></span></div></dd><dt><span>游玩景点</span>烟台海昌雨岱山温泉</dt><dd><!-- 景区介绍 --><p>烟台海昌雨岱山温泉拥有功能齐全的榻榻米客房，客房的装饰风格古意淡然，格调高雅、宽畅明亮。其中包含豪华单人房、豪华标准房、温泉海景套房等。每个房间都拥有独立的露天观景平台和温泉泡池，将温泉水直接引入客房。</p><div><img style=\"width: 900px; height: 500px;\" src=\"http://upload.17u.com/uploadfile/2013/12/11/2/201312111437122676401.jpg\" alt=\"\" /> <span></span></div><div>&nbsp;</div></dd><dd><div><img style=\"width: 900px; height: 500px;\" src=\"http://upload.17u.com/uploadfile/2013/12/11/2/201312111437070961905.jpg\" alt=\"\" /> <span></span></div></dd></dl><h4 class=\"intro_head\"><font size=\"+0\">烟台海昌雨岱山温泉</font>温馨提示</h4><ul class=\"list_square\"><li>请遵守温泉制度，听从温泉工作人员安排。</li></ul>";
        [self.navigationController pushViewController:web animated:YES];
        [web     release];
        
        
    }else if (indexPath.section == 1) {
        ScenicLocationMapVC *map = [[ScenicLocationMapVC alloc] initWithTitle:@"地图" style:NavBarBtnStyleOnlyBackBtn];
        [self.navigationController pushViewController:map animated:YES];
        [map release];
    }else if (indexPath.section == 2){
        if (self.type == ScenicTicketType_CanBooking) {
            //购买须知
            ScenicWebViewController *web = [[ScenicWebViewController alloc] initWithTitle:@"购买须知" style:NavBarBtnStyleNormalBtn];
            NSString *html = @"<div class='tcbuyNotice'><strong>开放时间<>:09:00-24:00<br/><strong>取票地点<>:烟台海昌雨岱山温泉前台<br/><strong>入园凭证<>:同程网预订成功确认订单短信。<br/><strong>特惠政策<>:<p>A.免票政策：身高1.2米以下的儿童免费。<br/>B.优惠政策：1.2米-1.4米之间的儿童购景区优惠票<span style=\"color: #ff0000;\">（上述优惠政策，需到景区自行购买）</span>。</p><br/><strong>退改规则<>:<p><span style=\"color: #333333;\">①如需修改出游日期，请登录同程旅游订单中心自行修改，或重新预订门票。<br/>②如需取消订单，请您登录同程旅游订单中心取消或回复同程旅游短信取消。<br/></span></p><p align=\"left\"><span style=\"color: #333333;\">&nbsp;</span></p><p>&nbsp;</p><br/><strong>温馨提示<>:<p>①预订门票包含：岩盘浴大厅、汤池、特色蒸房、洗漱用品、休息大厅。<br/>②另付费项目：饮料、茶水、餐饮、裕服。<br/><span style=\"color: #ff0000;\">③每名成人仅限带一名1.2米以下同性别儿童入馆，超出儿童需购买儿童票。</span><br/>④门票当天有效，出园后需再入园，请再次购票。<br/>⑤为保证取票、入园顺利，预订时请务必填写真实姓名、手机号码等信息。</p></div>";
            web.webHtml = html;
            [self.navigationController pushViewController:web animated:YES];
            [web release];
        }
    }
}
@end
