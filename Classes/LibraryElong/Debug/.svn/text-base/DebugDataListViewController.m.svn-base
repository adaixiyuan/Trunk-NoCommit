//
//  DebugDataListViewController.m
//  ElongClient
//
//  Created by Dawn on 14-2-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DebugDataListViewController.h"
#import "ElongCacheDebugProtocol.h"
#import "DebugDataDetailViewController.h"

@interface DebugDataListViewController ()
@property (nonatomic,assign) id<ElongCacheDebugProtocol>delegate;
@property (nonatomic,retain) NSArray *allKeys;
@end

@implementation DebugDataListViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    self.allKeys = nil;
    
    [super dealloc];
}

- (id) initWith:(id<ElongCacheDebugProtocol>)cache{
    if (self = [super init]) {
        self.delegate = cache;
        self.allKeys = [self.delegate allKeys];
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        UITableView *dataList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 50) style:UITableViewStylePlain];
        dataList.delegate = self;
        dataList.dataSource = self;
        
        [self.view addSubview:dataList];
        [dataList release];
        
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"取消    " style:UIBarButtonItemStyleDone target:self action:@selector(cancel)] autorelease];
    }
    return self;
}

- (void) cancel{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allKeys.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KeyCell"];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"KeyCell"] autorelease];
    }
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = [self.allKeys objectAtIndex:indexPath.row];
    if ([self.delegate isKindOfClass:[ElongHttpRequestCache class]]) {
        NSDictionary *dict = [self.delegate objectForKey:[self.allKeys objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@[%.2fkb %.3fs]",[dict objectForKey:@"From"],[[dict objectForKey:@"DataLength"] floatValue]/1024.0f,[[dict objectForKey:@"TimeInterval"] floatValue]];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [self.allKeys objectAtIndex:indexPath.row];
    
    DebugDataDetailViewController *datadetailVC = [[DebugDataDetailViewController alloc] initWithObject:[self.delegate objectForKey:key]];
    [self.navigationController pushViewController:datadetailVC animated:YES];
    [datadetailVC release];
}


@end