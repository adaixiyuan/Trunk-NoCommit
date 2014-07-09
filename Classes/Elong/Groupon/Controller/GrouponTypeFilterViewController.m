//
//  GrouponTypeFilterViewController.m
//  ElongClient
//
//  Created by garin on 14-2-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponTypeFilterViewController.h"

@interface GrouponTypeFilterViewController ()

@end

@implementation GrouponTypeFilterViewController

-(void) dealloc
{
    typeTable.delegate=nil;
    self.typeArr=nil;
    self.checkIndexArr=nil;
    
    [super dealloc];
}

-(id) initWithFrame:(CGRect) frame_
{
    if (self = [super init])
    {
        self.view.frame=frame_;
        
        self.view.backgroundColor=[UIColor whiteColor];
        
        [self initView];
    }
    
    return self;
}

-(void) resizeWithFrame:(CGRect) frame_
{
    self.view.frame=frame_;
    typeTable.frame=CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
}

-(void) setFailViewUI:(BOOL) hidden showTxt:(NSString *) showTxt
{
    if (failView==nil)
    {
        failView = [[UILabel alloc] initWithFrame:self.view.bounds];
        failView.backgroundColor=[UIColor whiteColor];
        failView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        failView.font = [UIFont systemFontOfSize:12];
        failView.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:failView];
        [failView release];
    }
    
    failView.text=showTxt;
    
    if (!hidden)
    {
        [self.view bringSubviewToFront:failView];
        failView.hidden=NO;
    }
    else
    {
        failView.hidden=YES;
    }
}

-(void) startLoadingView
{
    if (loadingView==nil)
    {
        loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2-20, self.view.frame.size.height / 2-20, 40, 40)];
        loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:loadingView];
        [loadingView release];
    }
    
    [loadingView startAnimating];
}

-(void) endLoadingView
{
    [loadingView stopAnimating];
}

-(void) fillData:(NSArray *) brandData_
{
    self.typeArr=brandData_;
    //是否选中的索引
    self.checkIndexArr=[NSMutableArray array];
    
    for (int i=0; i<brandData_.count; i++)
    {
        //默认选中第一项
        if (i==0)
        {
            [self.checkIndexArr addObject:[NSNumber numberWithBool:YES]];
        }
        else
        {
            [self.checkIndexArr addObject:[NSNumber numberWithBool:NO]];
        }
    }
    
    [typeTable reloadData];
}

-(void) initView
{
    typeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStylePlain];
    typeTable.backgroundColor=[UIColor whiteColor];
    typeTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    typeTable.dataSource = self;
    typeTable.delegate = self;
    typeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:typeTable];
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
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.typeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"GrouponTypeCell";
    
    CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
	if (cell == nil) {
		cell = [[[CommonCell alloc] initWithIdentifier:cellId height:50 style:CommonCellStyleChoose] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    cell.textLabel.text = [[self.typeArr safeObjectAtIndex:indexPath.row] safeObjectForKey:@"CategoryName"];
    
    cell.cellImage.highlighted = [[self.checkIndexArr safeObjectAtIndex:indexPath.row] boolValue];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.typeArr.count <= 1) {
        return;
    }
    
    [self selectIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(grouponTypeFilterController:index:)])
    {
        [self.delegate grouponTypeFilterController:self index:indexPath.row];
    }
}

//选中某一项
-(void) selectIndex:(int) index
{
    for (int i=0; i<self.checkIndexArr.count; i++)
    {
        if (index==i)
        {
            [self.checkIndexArr replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
        }
        else
        {
            [self.checkIndexArr replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
        }
    }
    
    [typeTable reloadData];
}

-(void) selectItem:(NSDictionary *)selectedBrand
{
    if (selectedBrand==nil) {
        return;
    }
    
    for (int i=0; i<self.typeArr.count; i++)
    {
        NSDictionary *temDic=[self.typeArr safeObjectAtIndex:i];
        if (temDic==nil)
        {
            continue;
        }
        
        if([[temDic safeObjectForKey:@"CategoryId"] intValue]==[[selectedBrand safeObjectForKey:@"CategoryId"] intValue])
        {
            [self selectIndex:i];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
