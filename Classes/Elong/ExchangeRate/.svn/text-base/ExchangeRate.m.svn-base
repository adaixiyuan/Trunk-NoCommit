//
//  ExchangeRate.m
//  ElongClient
//
//  Created by Jian.zhao on 13-12-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "ExchangeRate.h"
#import "RateCell.h"
#import "RateModel.h"
#import "RateList.h"


#define DEFAULT_CURRENT_DATA @"DEFAULT_EXCHANGERATE"//用户当前显示的汇率数据
#define DEFAULT_ORIGIN_EXCHANGE_RATE @"ORIGIN_EXCHANGE_RATE"//原始的汇率数据
#define UPDATE_TIMESTAMP @"UPDATE_TIMESTAMP"

//
#define TIME_FORMART @"yyyy-MM-dd HH:mm:ss"

#define item_Width 36
#define item_Height 34

static int selectedIndex = 0;

@interface ExchangeRate ()

@end

@implementation ExchangeRate

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        dataSource = [[NSMutableArray alloc] init];
        currentDisplay = [[NSMutableArray alloc] init];

        //读取上次操作保存的数据
        [self readTheDefaultSetting];
        
    }
    return self;
}

-(void)readTheDefaultSetting{
    
    //主要是保存上次离开页面时点击过的 币种以及数值
    
    NSData *data =  [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_CURRENT_DATA];
    if (data) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        [currentDisplay removeAllObjects];
        [currentDisplay addObjectsFromArray:array];
        [array release];
    }
    
    if ([currentDisplay count] == 0) {
        //请求网络
        [self laodNetDataWithAlert:YES andRequestCache:NO];
    }
    
    //监测距离上次更新时间,超过24小时，则更新数据
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:UPDATE_TIMESTAMP];
    NSDate *current = [NSDate date];
    NSDate *old = [NSDate dateFromString:string withFormat:TIME_FORMART];
    
    NSTimeInterval interval  = [current timeIntervalSinceDate:old];
    //换算
    int hours = (int)interval/3600;
    if (hours>=24) {
        [self laodNetDataWithAlert:NO andRequestCache:NO];
    }
}

- (void)back
{
    //返回时保存
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentDisplay];
    [[NSUserDefaults  standardUserDefaults] setObject:data forKey:DEFAULT_CURRENT_DATA];
    [[NSUserDefaults  standardUserDefaults] synchronize];
    
    if (_httpUtil) {
        [_httpUtil cancel];
        SFRelease(_httpUtil);
    }
    
    [PublicMethods closeSesameInView:self.navigationController.view];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{

    if (_httpUtil) {
        [_httpUtil cancel];
        SFRelease(_httpUtil);
    }
    
    SFRelease(timeStamp);
    SFRelease(dataSource);
    SFRelease(currentDisplay);
    [_tableView release];
    [super dealloc];
}

-(void)requestTheCacheDataFromNet{

    [self laodNetDataWithAlert:YES andRequestCache:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //刷新按钮
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:CGRectMake(0, 0, item_Width,item_Height )];
    [right setBackgroundImage:[UIImage imageNamed:@"btn_refreshNormal.png"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(requestTheCacheDataFromNet) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:right] autorelease];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 9, SCREEN_WIDTH, SCREEN_HEIGHT-20-9-44-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    //底部显示时间戳的地方
    timeStamp = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44-20-44, SCREEN_WIDTH, 44)];
    timeStamp.backgroundColor = [UIColor clearColor];
    timeStamp.textAlignment = NSTextAlignmentCenter;
    timeStamp.font = [UIFont systemFontOfSize:12.0f];
    timeStamp.textColor = [UIColor lightGrayColor];
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:UPDATE_TIMESTAMP];
    if (nil != string) {
        timeStamp.text = [NSString stringWithFormat:@"最后更新:  %@",string];
    }
    [self.view addSubview:timeStamp];
    
}

-(void)laodNetDataWithAlert:(BOOL)yes andRequestCache:(BOOL)cache{
    
    NSDictionary *req = @{@"forceUpdate":[NSNumber numberWithBool:!cache]};
    
    NSString *paramJson = [req JSONString];
    NSLog(@"汇率模块的请求参数：req is %@",paramJson);
    NSString *url = [PublicMethods composeNetSearchUrl:@"mtools" forService:@"exchangeRates" andParam:paramJson];
    
    if (STRINGHASVALUE(url)) {
            if (_httpUtil) {
                [_httpUtil cancel];
                SFRelease(_httpUtil);
            }
            _httpUtil = [[HttpUtil alloc] init];
            [_httpUtil requestWithURLString:url Content:nil StartLoading:yes EndLoading:yes Delegate:self];
    }
}

#pragma mark 
#pragma mark HttpUti


- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    if ([Utils checkJsonIsError:root]) {
		return;
	}
    
    //Deal With Data
    NSArray *array = [root objectForKey:@"rates"];
    
    if (nil != array && [array count] != 0) {
        //
        NSLog(@"获取成功 汇率列表");
        [dataSource removeAllObjects];//清除旧数据，保存最新的汇率数据
        
        for (int i = 0; i<[array count]; i++) {
            
            RateModel *model = [[RateModel alloc] initWithDictionary:[array objectAtIndex:i]];
            [dataSource addObject:model];
            [model release];
        
        }
        //解析完毕
        NSLog(@"解析完毕的数组 %@",dataSource);
    }
    [self setTheDefaultData];//保存缓存数据
    [self readTheDefaultSetting];
}

-(void)setTheDefaultData{

    if ([dataSource count] != 0) {
        
        if ([currentDisplay count] == 0) {
            //当且仅当 当前无显示时 才缓寸 RMB USD
            for (RateModel *model in dataSource) {
                if ([model.simplyName isEqualToString:@"CNY"] || [model.simplyName isEqualToString:@"USD"]) {
                    [currentDisplay addObject:model];
                }
            }
        }
        
        //默认当前为RMB USD
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentDisplay];
        [[NSUserDefaults  standardUserDefaults] setObject:data forKey:DEFAULT_CURRENT_DATA];
        
        //保存原始的汇率数据
        NSData *origin = [NSKeyedArchiver archivedDataWithRootObject:dataSource];
        [[NSUserDefaults  standardUserDefaults] setObject:origin forKey:DEFAULT_ORIGIN_EXCHANGE_RATE];
        
        //刷新时间
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:TIME_FORMART];
        NSString *string = [formatter stringFromDate:date];
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:UPDATE_TIMESTAMP];
        timeStamp.text = [NSString stringWithFormat:@"最后更新:  %@",string];
        [formatter release];
        
        [[NSUserDefaults standardUserDefaults] synchronize];

        [_tableView reloadData];
    }

}


#pragma  mark 
#pragma  mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return ([currentDisplay count] == 0)?0:3;//始终显示三个。。。
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 76;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifyer = @"Cell_Main";
    RateCell   *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifyer];
    if (cell == nil) {
        cell = [[[RateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifyer] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    if ([currentDisplay count] == 3) {
            //最多三个
        [cell bindingTheModel:[currentDisplay objectAtIndex:indexPath.row]];
   
    }else{
    
        //2个的情况(只有三个和两个的情况)
        if (indexPath.row == 2) {
            //显示加号
            [cell displayTheAddTip];
            
        }else{
            if ([currentDisplay count] != 0) {
                [cell bindingTheModel:[currentDisplay objectAtIndex:indexPath.row]];
            }
        }

    }
    
    return cell;
}

#pragma  mark
#pragma  mark UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedIndex = indexPath.row;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_ORIGIN_EXCHANGE_RATE];
    NSArray *array = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    if ([array count] != 0) {
        RateList  *list = [[RateList alloc] initWithTopImagePath:nil andTitle:@"选择货币" style:_NavOnlyBackBtnStyle_];
        list.delegate = self;
        UINavigationController *nav = [[UINavigationController   alloc] initWithRootViewController:list];
        if (IOSVersion_7) {
            nav.transitioningDelegate = [ModalAnimationContainer shared];
            nav.modalPresentationStyle = UIModalPresentationCustom;
        }
        if (IOSVersion_7) {
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            [self presentModalViewController:nav animated:YES];
        }
        [list release];
        [nav release];
    }
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    //检测有没有键盘 若有 直接回收
    for (int i = 0; i < [currentDisplay count]; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        RateCell *cell = (RateCell *)[_tableView cellForRowAtIndexPath:path];
        [cell.result resignFirstResponder];
    }
}

#pragma mark
#pragma mark  RateList CallBack

-(void)getTheSelectedRateModel:(RateModel *)model{
    
    if (selectedIndex == 2 && [currentDisplay count] == 2) {
        [currentDisplay addObject:model];
    }else{
        [currentDisplay replaceObjectAtIndex:selectedIndex withObject:model];
    }
    
    //更新整个页面的汇率
    NSIndexPath *updateIndex = [NSIndexPath indexPathForRow:[currentDisplay indexOfObject:model] inSection:0];
    [self updateTheRatesWithGivenArray:currentDisplay currentIndex:updateIndex currentInput:@"" Changed:YES];

    
    [_tableView reloadData];
    
}


#pragma mark 
#pragma mark CellDelegate
-(void)shouldBeginTheInputInModel:(RateModel *)model{

    NSIndexPath  *path = [NSIndexPath indexPathForRow:[currentDisplay indexOfObject:model] inSection:0];
    if (path.row == 2) {
        if (!SCREEN_4_INCH) {
            [_tableView setContentOffset:CGPointMake(0, 40) animated:YES];
        }
    }
}

-(void)getUserPrintNumsWithString:(NSString *)string andModel:(RateModel *)aModel{

    NSIndexPath  *path = [NSIndexPath indexPathForRow:[currentDisplay indexOfObject:aModel] inSection:0];
    if ([currentDisplay count] > 1) {
        //当且仅当 当前汇率个数大于1个时 才有计算的价值
        [self updateTheRatesWithGivenArray:currentDisplay currentIndex:path currentInput:string Changed:NO];
    }
    [self adjustTheTableFrame];
}

-(void)adjustTheTableFrame{

    if (_tableView.contentOffset.y > 0) {
        [_tableView setContentOffset:CGPointZero animated:YES];
    }
    
}


/***
    
 display:当前显示的汇率数组
 path:当前选中的tableView的Path
 input:1,手动输入（当前页面输入）2,后一个页面点选传入导致的更改
 changed: ＊＊＊＊＊重要，当前的Model 是主动求变（用户输入） YES ，还是被动改变（已存在汇率，自己被迫适应） NO
 
 ***/


-(void)updateTheRatesWithGivenArray:(NSMutableArray *)display currentIndex:(NSIndexPath *)path currentInput:(NSString *)input Changed:(BOOL)changed{

    RateModel *current = [display objectAtIndex:path.row];//取出当前的
    double currentInput = [input doubleValue];//转换成float
    current.rate = currentInput;
    
    for (RateModel *model in currentDisplay) {
        //![model.simplyName isEqualToString:current.simplyName
        if (model != current) {
            //计算
            if (changed) {
                current.rate = [self calculateTheRatesCurrent:current.simplyName Target:model.simplyName WithGiven:model.rate andSelfChanged:changed];
                break;
            }else{
                model.rate = [self calculateTheRatesCurrent:current.simplyName Target:model.simplyName WithGiven:currentInput andSelfChanged:changed];
            }
        }
    }
    [_tableView reloadData];
}

//输入三个参数 (简称)当前货币 目标货币 兑换数目
-(float)calculateTheRatesCurrent:(NSString *)current Target:(NSString *)target WithGiven:(double)parameter andSelfChanged:(BOOL)changed{
    
    //取出缓存中的原始汇率数据
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_ORIGIN_EXCHANGE_RATE];
    NSArray *array = [NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    if ( [array count] != 0) {
        //
        RateModel *cur = [[[RateModel alloc] init] autorelease];
        RateModel *tar = [[[RateModel alloc] init] autorelease];
        for (RateModel *model in array) {
            if ([model.simplyName isEqualToString:current]) {
                cur = model;
            }
            if ([model.simplyName isEqualToString:target]) {
                tar = model;
            }
        }
        //
        if (changed) {
            double result =  parameter/(tar.rate/cur.rate);
            return result;
        }else {
            double result =  (tar.rate/cur.rate)*parameter;
            return result;
        }
    }else{
        NSLog(@"汇率原始数据有错误！");
    }
    return 0;
}


@end
