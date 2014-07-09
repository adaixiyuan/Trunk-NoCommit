//
//  PackingSetting.m
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "PackingSetting.h"
#import "PackingDefine.h"
#import "PackingCategory.h"
#import "PackingItem.h"
#import "EditPackingLibCategory.h"
#import "AccountManager.h"
#import "LoginManager.h"

@interface PackingSetting ()

@end

#define LAST_UPDATE_TIME @"LAST_UPDATE_TIME"

@implementation PackingSetting

- (void)dealloc
{
    [_tableView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SynchronizePackingData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_synchronizedData release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTheTimeStamp:) name:SYSCHRONIED_PACKING_REFRESH object:nil];
    
    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = RGBACOLOR(248, 248, 248, 1.0);
    [label setFrame:CGRectMake(0, 0, 320, 40)];
    _tableView.tableHeaderView = label;
    [label release];
    
    
    //同步时间显示
    timeStamp = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    timeStamp.font = [UIFont systemFontOfSize:10.0f];
    timeStamp.backgroundColor = [UIColor clearColor];
    
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_UPDATE_TIME];
    if (nil != string) {
        timeStamp.text = [NSString stringWithFormat:@"   上次同步时间:  %@",string];
    }
    _tableView.tableFooterView = timeStamp;
    
}

-(void)updateTheTimeStamp:(id)sender{

    NSString *string = [[NSDate date] stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    timeStamp.text = [NSString stringWithFormat:@"   上次同步时间:  %@",string];
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:LAST_UPDATE_TIME];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//同步旅行清单
-(void)startSynchronizeData{
    if(_synchronizedData==nil){
        _synchronizedData = [[PackingDataSynchronize alloc] init];
    }
    [_synchronizedData start];
}

#pragma  mark
#pragma  mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 50.0f;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = RGBACOLOR(248, 248, 248, 1.0);
        [label setFrame:CGRectMake(0, 0, 320, 40)];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.contentMode = UIViewContentModeBottom;
        return [label autorelease];
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        if (indexPath.row == 0) {
            [self addLineOnView:cell WithPositionIsUp:YES];
        }
        [self addLineOnView:cell WithPositionIsUp:NO];
        
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"编辑清单";
                    break;
                 case 1:
                    cell.textLabel.text = @"初始化清单库";
                    cell.textLabel.textColor = RGBACOLOR(42, 122, 229, 1.0);
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    break;
                default:
                    break;
            }
            break;
         case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"同步服务器";
                    cell.textLabel.textColor = RGBACOLOR(42, 122, 229, 1.0);
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)addLineOnView:(UIView *)view WithPositionIsUp:(BOOL)isUp{

    float y;
    if (isUp) {
        y = CGRectGetMinY(view.frame);
    }else{
        y = CGRectGetMaxY(view.frame)-0.5f;
    }
    [view addSubview:[UIImageView dashedHalfLineWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 1)]];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        //还原操作
        //从Plist读取
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:PACKING_LIB_PLIST ofType:@"plist"];
        NSFileManager *manager = [NSFileManager  defaultManager];
        if (![manager fileExistsAtPath:plistPath]) {
            NSLog(@"cannot find the plist file");
            return;
        }
        NSMutableArray *plistData = [NSMutableArray arrayWithContentsOfFile:plistPath];
        //最终结果(已转化为实体的数组)
        NSMutableArray *category_Array = [self getEntitysFromGivenCategoryArrays:plistData];
        NSData *save = [NSKeyedArchiver archivedDataWithRootObject:category_Array];
        [[NSUserDefaults standardUserDefaults] setObject:save forKey:PACKING_LIB_MODIFY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//从Categorylist到最小的item
-(NSMutableArray *)getEntitysFromGivenCategoryArrays:(NSMutableArray *)array{
    
    //初始化数据，转换成实体对象!
    NSMutableArray *category_Array = [[NSMutableArray alloc] initWithCapacity:[array count]];
    
    for (NSDictionary *dic in array) {
        PackingCategory *category = [[PackingCategory alloc] init];
        NSArray *keys = [dic allKeys];
        for (NSString *key in keys) {
            if ([dic objectForKey:key] != nil) {
                [category setValue:[dic objectForKey:key] forKey:key];
            }
        }
        //解析得到 Category 继续解析 得到Item
        NSMutableArray *item_array = [[NSMutableArray alloc] initWithCapacity:[category.itemList count]];
        for (NSDictionary *object in category.itemList) {
            PackingItem *item = [[PackingItem alloc] init];
            NSArray *keys = [object allKeys];
            for (NSString *key in keys) {
                if ([object objectForKey:key] != nil) {
                    [item setValue:[object objectForKey:key] forKey:key];
                }
            }
            //得到Item
            [item_array addObject:item];
            [item release];
        }
        //解析完毕
        [category.itemList removeAllObjects];
        [category.itemList addObjectsFromArray:item_array];
        [item_array release];
        
        [category_Array addObject:category];
        [category release];
    }
    return [category_Array autorelease];
}

#pragma mark
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //编辑清单
            EditPackingLibCategory *edit = [[EditPackingLibCategory alloc] initWithTopImagePath:nil andTitle:@"编辑清单" style:_NavOnlyBackBtnStyle_];
            [self.navigationController pushViewController:edit animated:YES];
            [edit release];
            
        }else if (indexPath.row == 1){
            //还原清单
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要还原清单库?"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alert show];
            [alert release];
            
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //
            BOOL isLogin = [[AccountManager instanse] isLogin];
            if(isLogin){
                [self startSynchronizeData];
            }else{
                //进入登陆页面
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startSynchronizeData) name:@"SynchronizePackingData" object:nil];
                
                ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
                LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:SynchronizedPackingData];
                [delegate.navigationController pushViewController:login animated:YES];
                [login release];
            }
        }
    }
}

@end
