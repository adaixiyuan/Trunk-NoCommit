//
//  DebugServerListViewController.m
//  ElongClient
//
//  Created by Dawn on 14-2-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DebugServerListViewController.h"

static const int serverList[] = {
    @"http://mobile-api2011.elong.com",
    @"http://172.21.19.69/openapi",
    @"http://172.21.16.76/openapitest",
    @"http://192.168.9.225",
    @"http://192.168.14.60",
    @"http://192.168.14.51",
    @"http://172.21.11.52",
    @"http://172.21.12.59/openapi",
    @"http://192.168.9.227",
    @"http://211.151.235.38",
    @"http://172.21.20.21",
    @"http://172.21.19.69/openapi",
    @"http://192.168.14.67",
    @"http://192.168.14.64",
    @"http://192.168.14.53",
    @"http://192.168.14.60"
};

@interface DebugServerListViewController (){
@private
    UITextField *urlField;
    UISwitch *monkeySwitch;
    UISwitch *httpsSwitch;
}
@end

@implementation DebugServerListViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 顶栏
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"    取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"确定    " style:UIBarButtonItemStyleDone target:self action:@selector(confirm)] autorelease];
    
    
    // 地址显示栏
    urlField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 40)];
    urlField.borderStyle = UITextBorderStyleRoundedRect;
    urlField.placeholder = @"Server URL";
    urlField.text = [[ServiceConfig share] serverURL];
    urlField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    urlField.font = FONT_14;
    [self.view addSubview:urlField];
    [urlField release];
    
    
    // 地址选择表
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, MAINCONTENTHEIGHT - 50 - 50 - 50)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView release];
    
    // monkey开关
    monkeySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(15, tableView.frame.origin.y + tableView.frame.size.height + 10, 50, 30)];
    [self.view addSubview:monkeySwitch];
    monkeySwitch.on = [[ServiceConfig share] monkeySwitch];
    [monkeySwitch release];
    
    UILabel *pageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, monkeySwitch.frame.size.height)];
    pageLbl.text = @"禁止下单";
    pageLbl.textAlignment = UITextAlignmentRight;
    pageLbl.backgroundColor = [UIColor clearColor];
    pageLbl.textColor = RGBACOLOR(52, 52, 52, 1);
    pageLbl.font = [UIFont systemFontOfSize:12.0f];
    [monkeySwitch addSubview:pageLbl];
    [pageLbl release];
    
    // https 开关
    httpsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(170, tableView.frame.origin.y + tableView.frame.size.height + 10, 50, 30)];
    [self.view addSubview:httpsSwitch];
    httpsSwitch.on = !([[ServiceConfig share] httpsSwitch]);
    [httpsSwitch release];
    
    pageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, monkeySwitch.frame.size.height)];
    pageLbl.text = @"关闭HTTPS";
    pageLbl.textAlignment = UITextAlignmentRight;
    pageLbl.backgroundColor = [UIColor clearColor];
    pageLbl.textColor = RGBACOLOR(52, 52, 52, 1);
    pageLbl.font = [UIFont systemFontOfSize:12.0f];
    [httpsSwitch addSubview:pageLbl];
    [pageLbl release];


}

- (void) cancel{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) confirm{
    ServiceConfig *config = [ServiceConfig share];
    config.serverURL = urlField.text;
    config.monkeySwitch = monkeySwitch.on;
    config.httpsSwitch = !httpsSwitch.on;
    
    [[NSUserDefaults standardUserDefaults] setObject:urlField.text forKey:SERVERURL];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:monkeySwitch.on] forKey:MONKEY_SWITCH];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //取反
    [[ElongUserDefaults sharedInstance] setObject:[NSNumber numberWithBool:!httpsSwitch.on] forKey:HTTPS_SWITCH];
    
    [self cancel];
}

#pragma mark -
#pragma mark UITableViewDelegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sizeof(serverList)/sizeof(serverList[0]);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    cell.textLabel.text = serverList[indexPath.row];
    cell.textLabel.font = FONT_14;
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    urlField.text = serverList[indexPath.row];
}

@end
