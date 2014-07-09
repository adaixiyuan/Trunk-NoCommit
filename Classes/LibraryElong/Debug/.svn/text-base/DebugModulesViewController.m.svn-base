//
//  DebugModulesViewController.m
//  ElongClient
//
//  Created by Dawn on 14-3-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DebugModulesViewController.h"
#import "HomeLayout.h"
#import "HomeItem.h"

@interface DebugModulesViewController (){
@private
    UITableView *moduleList;
}
@property (nonatomic,retain) NSMutableArray *layoutItemArray;
@property (nonatomic,retain) NSMutableArray *itemArray;
@end

@implementation DebugModulesViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    self.layoutItemArray = nil;
    self.itemArray = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"    取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"确定    " style:UIBarButtonItemStylePlain target:self action:@selector(confirm)] autorelease];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.itemArray = [NSMutableArray array];
    if ([[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_DEBUG_MODULES]) {
        self.itemArray =[NSMutableArray arrayWithArray:[[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_DEBUG_MODULES]];
    }
    
    self.layoutItemArray = [NSMutableArray array];
    
    HomeLayout *itemLayout = [[[HomeLayout alloc] initWithDefaultFileName:@"HomeItems"] autorelease];
    HomeLayout *homeLayout = [[[HomeLayout alloc] initWithDefaultFileName:@"HomeLayout"] autorelease];
    
    NSMutableArray *titemArray = [NSMutableArray array];
    
    
    for (HomeItem *item in homeLayout.items) {
        if (item.actions.count) {
            [titemArray addObjectsFromArray:item.actions];
        }else if(item.subitems.count){
            
        }else{
            [titemArray addObject:item];
        }
    }
    
    for (HomeItem *item in itemLayout.items) {
        if (item.actions.count) {
            [titemArray addObjectsFromArray:item.actions];
        }else if(item.subitems.count){
            
        }else{
            [titemArray addObject:item];
        }
    }
    
    for (HomeItem *item in titemArray) {
        BOOL exist = NO;
        for (HomeItem *fitem in self.layoutItemArray) {
            if (item.tag == fitem.tag) {
                exist = YES;
                break;
            }
        }
        if (!exist) {
            [self.layoutItemArray addObject:item];
        }
    }
    
    HomeItem *newItem = [[HomeItem alloc] init];
    newItem.tag = -1;
    newItem.title = @"私人定制模块保存";
    [self.layoutItemArray addObject:newItem];
    [newItem release];

    
    moduleList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 50) style:UITableViewStylePlain];
    moduleList.dataSource = self;
    moduleList.delegate = self;
    [self.view addSubview:moduleList];
    [moduleList release];
    
}

- (void) cancel{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) confirm{
    if (self.itemArray) {
        [[ElongUserDefaults sharedInstance] setObject:self.itemArray forKey:USERDEFAULT_DEBUG_MODULES];
    }
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.layoutItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ModuleCell";
    UITableViewCell *cell =  (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HomeItem *item = (HomeItem *)[self.layoutItemArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 1);
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryNone;
    for (NSNumber *tag in self.itemArray) {
        if ([tag intValue] == item.tag) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.text = @"禁用";
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeItem *item = (HomeItem *)[self.layoutItemArray objectAtIndex:indexPath.row];
    BOOL exist = NO;
    for (NSNumber *tag in self.itemArray) {
        if ([tag intValue] == item.tag) {
            [self.itemArray removeObject:tag];
            exist = YES;
            break;
        }
    }
    if (!exist) {
        [self.itemArray addObject:NUMBER(item.tag)];
    }
    [moduleList reloadData];
}

@end
