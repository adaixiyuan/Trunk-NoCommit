//
//  DebugNetworkViewController.m
//  ElongClient
//
//  Created by Dawn on 14-3-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DebugNetworkViewController.h"
#import "DebugNetworkCell.h"
#import "DebugDataDetailViewController.h"

@interface DebugNetworkViewController (){
@private
    UITableView *networkList;
    UIButton *headBtn;
    UISegmentedControl *segControl;
    UILabel *pageLbl;
    UISwitch *pageSwitch;
}
@property (nonatomic,retain) NSMutableArray *dataKeys;
@property (nonatomic,retain) NSMutableDictionary *data;
@property (nonatomic,retain) NSMutableArray *values;
@property (nonatomic,assign) float max;
@property (nonatomic,copy) NSString *unit;
@property (nonatomic,assign) float total;
@property (nonatomic,assign) NetworkChartType chartType;
@property (nonatomic,copy) NSString *detailKey;
@property (assign) BOOL fromPage;
@end

@implementation DebugNetworkViewController

- (void) dealloc{
    self.dataKeys = nil;
    self.data = nil;
    self.values  = nil;
    self.unit = nil;
    self.detailKey = nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) initWithType:(NetworkChartType)type key:(NSString *)key page:(BOOL)page{
    if (self = [super init]) {
        self.chartType = type;
        self.detailKey = key;
        self.fromPage = page;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.chartType == NetworkChartList) {
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"    取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] autorelease];
    }else{
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"取消    " style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] autorelease];
    }

    
    
    self.dataKeys = [NSMutableArray array];
    self.data = [NSMutableDictionary dictionary];
    self.values = [NSMutableArray array];
    
    
    
    
    segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"耗时",@"数据", nil]];
    segControl.selectedSegmentIndex = 0;
    [segControl addTarget:self action:@selector(segValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segControl];
    [segControl release];
    
    if (self.chartType == NetworkChartDetail) {
        segControl.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, 30);
    }else{
        segControl.frame = CGRectMake(10, 5, SCREEN_WIDTH - 120, 30);
    }
    [self segValueChange:segControl];
    segControl.backgroundColor  = [UIColor whiteColor];
    
    
    
    networkList = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, MAINCONTENTHEIGHT - 40 - 50) style:UITableViewStylePlain];
    networkList.separatorStyle = UITableViewCellSeparatorStyleNone;
    networkList.delegate = self;
    networkList.dataSource = self;
    [self.view addSubview:networkList];
    [networkList release];
    
    headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    headBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [headBtn setTitleColor:RGBACOLOR(52, 52, 52, 1) forState:UIControlStateNormal];
    [headBtn setTitle:[NSString stringWithFormat:@"%.3f%@ 重置",self.total,self.unit] forState:UIControlStateNormal];
    networkList.tableHeaderView = headBtn;
    [headBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    pageSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 5, 60, 30)];
    [pageSwitch addTarget:self action:@selector(pageSwitchValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageSwitch];
    [pageSwitch release];
    pageSwitch.on = self.fromPage;
    
    pageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, pageSwitch.frame.size.height)];
    pageLbl.text = @"按页面";
    pageLbl.backgroundColor = [UIColor clearColor];
    pageLbl.textAlignment = UITextAlignmentRight;
    pageLbl.textColor = RGBACOLOR(52, 52, 52, 1);
    pageLbl.font = [UIFont systemFontOfSize:12.0f];
    [pageSwitch addSubview:pageLbl];
    [pageLbl release];
   
    if (self.chartType == NetworkChartDetail) {
        pageSwitch.hidden = YES;
    }else{
        pageSwitch.hidden = NO;
    }
    
    [self pageSwitchValueChange:pageSwitch];
}
- (void) pageSwitchValueChange:(id)sender{
    if (pageSwitch.on) {
        [self loadKeys:@"From"];
        pageLbl.text = @"按页面";
    }else{
        [self loadKeys:@"Key"];
        pageLbl.text = @"按请求";
    }
    [self segValueChange:nil];
    self.fromPage = pageSwitch.on;
}

- (void)headBtnClick:(id)sender{
    [[ElongHttpRequestCache sharedInstance] removeAllObjects];
    
    [self pageSwitchValueChange:pageSwitch];
    
}

- (void) loadKeys:(NSString *)fkey{
    NSMutableArray *networkArray = [NSMutableArray array];
    [self.dataKeys removeAllObjects];
    [self.data removeAllObjects];
    [self.values removeAllObjects];
    NSLog(@"%@",[[ElongHttpRequestCache sharedInstance] allObjects]);
    for (NSDictionary *dict in [[ElongHttpRequestCache sharedInstance] allObjects]) {
        [networkArray addObject:dict];
    }
    for (NSDictionary *dict in networkArray) {
        if (self.detailKey) {
            NSString *key = [dict objectForKey:fkey];
            if (![key isEqualToString:self.detailKey]) {
                continue;
            }
            NSString *newkey = @"";
            if ([fkey isEqualToString:@"From"]) {
                newkey = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Key"]];
            }else{
                newkey = [NSString stringWithFormat:@"%@%@",key,[[dict objectForKey:@"StartTime"] substringFromIndex:10]];
            }
            
            if ([self.data objectForKey:newkey]) {
                [[self.data objectForKey:newkey] addObject:dict];
            }else{
                [self.data setObject:[NSMutableArray array] forKey:newkey];
                [[self.data objectForKey:newkey] addObject:dict];
            }
            if ([self.dataKeys containsObject:newkey]) {
                continue;
            }
            [self.dataKeys addObject:newkey];
        }else{
            NSString *key = [dict objectForKey:fkey];
            if ([self.data objectForKey:key]) {
                [[self.data objectForKey:key] addObject:dict];
            }else{
                [self.data setObject:[NSMutableArray array] forKey:key];
                [[self.data objectForKey:key] addObject:dict];
            }
            if ([self.dataKeys containsObject:key]) {
                continue;
            }
            [self.dataKeys addObject:key];
        }
    }
}

- (void) cancel{
    [self dismissModalViewControllerAnimated:YES];
}
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) segValueChange:(id)sender{
    NSInteger selectedIndex = segControl.selectedSegmentIndex;
    self.max = 0;
    self.total = 0;
    NSString *dataKey = @"";
    if (selectedIndex == 0) {
        dataKey = @"TimeInterval";
        self.unit = @"s";
    }else if(selectedIndex == 1){
        dataKey = @"DataLength";
        self.unit = @"kb";
    }
    
    [self.values removeAllObjects];
    for (NSString *key in self.dataKeys) {
        float value = 0.0f;
        for (NSDictionary *dict in [self.data objectForKey:key]) {
            if (selectedIndex == 1) {
                value += ([[dict objectForKey:dataKey] floatValue]/1024.0f);
            }else{
                value += [[dict objectForKey:dataKey] floatValue];
            }
        }
        self.total += value;
        if (self.fromPage) {
            
        }else{
            value = (value  + 0.0f)/ [[self.data objectForKey:key] count];
        }
        
        if (value > self.max) {
            self.max = value;
        }
        [self.values addObject:[NSNumber numberWithFloat:value]];
    }
    
    [networkList reloadData];
    
    [headBtn setTitle:[NSString stringWithFormat:@"%.3f%@ 重置",self.total,self.unit] forState:UIControlStateNormal];
}



#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataKeys.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"NetworkCell";
    DebugNetworkCell *cell = (DebugNetworkCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[DebugNetworkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.dataKey = [self.dataKeys objectAtIndex:indexPath.row];
    cell.dataMaxValue = self.max;
    cell.dataValue = [[self.values objectAtIndex:indexPath.row] floatValue];
    cell.unit = self.unit;
    if (segControl.selectedSegmentIndex == 0) {
        if (self.fromPage) {
            cell.thresholdValue = 5;
        }else{
            cell.thresholdValue = 3;
        }
    }else if(segControl.selectedSegmentIndex == 1){
        if (self.fromPage) {
            cell.thresholdValue = 20;
        }else{
            cell.thresholdValue = 10;
        }
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.chartType == NetworkChartDetail) {
        NSString *key = [self.dataKeys objectAtIndex:indexPath.row];
        NSObject *obj = [[self.data objectForKey:key] objectAtIndex:0];
        DebugDataDetailViewController *datadetailVC = [[DebugDataDetailViewController alloc] initWithObject:obj];
        [self.navigationController pushViewController:datadetailVC animated:YES];
        [datadetailVC release];
    }else{
        DebugNetworkViewController *networkVC = [[DebugNetworkViewController alloc] initWithType:NetworkChartDetail key:[self.dataKeys objectAtIndex:indexPath.row] page:self.fromPage];
        
        [self.navigationController pushViewController:networkVC animated:YES];
        [networkVC release];
    }
}

@end
