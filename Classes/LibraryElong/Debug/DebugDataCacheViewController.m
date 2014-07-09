//
//  DebugDataCacheViewController.m
//  ElongClient
//
//  Created by Dawn on 14-2-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DebugDataCacheViewController.h"
#import "DebugDataListViewController.h"

@interface DebugDataCacheViewController (){
@private
    UITableView *dataList;
}
@property (nonatomic,retain) NSArray *dataArray;
@end

@implementation DebugDataCacheViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    self.dataArray = nil;
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"    取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] autorelease];
    
    self.dataArray = [NSArray arrayWithObjects:[ElongSingleton sharedInstance],[ElongKeychain sharedInstance],[ElongMemoryCache sharedInstance],[ElongDataCache sharedInstance],[ElongHttpRequestCache sharedInstance],[ElongUserDefaults sharedInstance], nil];
    
    dataList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 50) style:UITableViewStylePlain];
    dataList.delegate = self;
    dataList.dataSource = self;
    
    [self.view addSubview:dataList];
    [dataList release];
}

- (void) cancel{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id<ElongCacheDebugProtocol> delegate = [self.dataArray objectAtIndex:indexPath.row];
    DebugDataListViewController *dataListVC = [[DebugDataListViewController alloc] initWith:delegate];
    [self.navigationController pushViewController:dataListVC animated:YES];
    [dataListVC release];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ClassIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    cell.textLabel.text = [NSString stringWithUTF8String:object_getClassName([self.dataArray objectAtIndex:indexPath.row])];
    return cell;
}


@end
