//
//  DebugNetStatisticsViewController.m
//  ElongClient
//
//  Created by Janven on 14-3-26.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DebugNetStatisticsViewController.h"
#import "DebugNetStatisticsCell.h"
#import "ShareTools.h"

@interface DebugNetStatisticsViewController ()

@end

@implementation DebugNetStatisticsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray *array = [[NSMutableArray alloc] init];
        self.dataSource = array;
        [array release];
        [self prepareTheDataSource];
    }
    return self;
}

-(void)prepareTheDataSource{
    //key值去重
    NSArray *data = [[ElongHttpRequestCache sharedInstance] allObjects];
    NSMutableArray *o_keys = [[NSMutableArray alloc] init];
    NSArray *keys  = [[ElongHttpRequestCache sharedInstance] allKeys];
    for (NSString *key in keys) {
        NSString *realKey = [[key componentsSeparatedByString:@"."] lastObject];
        [o_keys addObject:realKey];
    }
    NSSet *set = [NSSet setWithArray:o_keys];
    
    //遍历数据
    for (NSString *realKey in [set allObjects]) {
        NSMutableArray *value  = [NSMutableArray array];
        for (NSDictionary *dic in data) {
            if ([realKey isEqualToString:[dic objectForKey:@"Key"]]) {
                [value addObject:dic];
            }
        }
        if ([value count] > 1) {
            //多个请求
            NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"TimeInterval" ascending:NO]];
            [value sortUsingDescriptors:sortDescriptors];
            //NSLog(@"排序后的数组%@",value);
            NSDictionary *first = [value objectAtIndex:0];
            NSDictionary *end = [value objectAtIndex:[value count]-1];
            
            NSNumber *max = [NSNumber numberWithFloat:[[first objectForKey:@"TimeInterval"] floatValue]];
            NSNumber *min = [NSNumber numberWithFloat:[[end objectForKey:@"TimeInterval"] floatValue]];
            
            //求均值
            float sum = 0;
            for (NSDictionary *dic in value) {
                sum += [[dic objectForKey:@"TimeInterval"] floatValue];
            }
            
            NSNumber *avarage = [NSNumber numberWithFloat:sum/[value count]];
            NSDictionary *customDic = [NSDictionary dictionaryWithObjectsAndKeys:realKey,@"Key",avarage,@"TimeInterval",max,@"max",min,@"min",[NSNumber numberWithInteger:[value count]],@"count",nil];
            [self.dataSource addObject:customDic];
        }else if([value count] == 1){
        
            NSDictionary *dic = [value objectAtIndex:0];
            NSNumber *num = [NSNumber numberWithFloat:[[dic objectForKey:@"TimeInterval"] floatValue]];
            NSDictionary *customDic = [NSDictionary dictionaryWithObjectsAndKeys:realKey,@"Key",num,@"TimeInterval",num,@"max",num,@"min",[NSNumber numberWithInteger:[value count]],@"count",nil];
            [self.dataSource addObject:customDic];
        }else{
            NSLog(@"DataError");
        }
    }
    [o_keys release];
}

-(void)cancel{

    [self dismissModalViewControllerAnimated:YES];
}

-(void)shareInfo{
    if ([[ServiceConfig share] monkeySwitch])
    {
        // 开着monkey时不发生事件
        return;
    }
    
    NSString *statistics = [self.dataSource JSONStringWithOptions:JKSerializeOptionPretty error:NULL];
    
    if ((statistics != nil) && ([statistics length] > 0))
    {
        if (STRINGHASVALUE(statistics))
        {
            
            ShareTools *shareTools = [ShareTools shared];
            shareTools.contentViewController = self;
            shareTools.contentView = nil;
            shareTools.needLoading = YES;
            
            shareTools.weiBoContent = statistics;
            shareTools.msgContent = statistics;
            shareTools.mailTitle = [NSString stringWithFormat:@"接口统计信息"];
            shareTools.mailContent = statistics;
            [shareTools  showItems];
            
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"    取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] autorelease];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"分享   " style:UIBarButtonItemStylePlain target:self action:@selector(shareInfo)] autorelease];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-44-20-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.dataSource = nil;
    [_tableView release];
    [super dealloc];
}

#pragma mark
#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.dataSource count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";
    DebugNetStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DebugNetStatisticsCell" owner:self options:nil] lastObject];
    }
    [cell dispalyDataWithSource:[self.dataSource objectAtIndex:indexPath.row]];
    return cell;
}


@end
