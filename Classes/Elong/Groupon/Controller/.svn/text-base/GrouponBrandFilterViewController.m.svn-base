//
//  GrouponBrandFilterViewController.m
//  ElongClient
//  团购品牌筛选
//  Created by garin on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponBrandFilterViewController.h"

@interface GrouponBrandFilterViewController ()

@end

@implementation GrouponBrandFilterViewController

-(void) dealloc
{
    brandTable.delegate=nil;
    self.brandArr=nil;
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
    brandTable.frame=CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
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
    self.brandArr=brandData_;
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
    
    [brandTable reloadData];
}

-(void) initView
{
    brandTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStylePlain];
    brandTable.backgroundColor=[UIColor whiteColor];
    brandTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    brandTable.dataSource = self;
    brandTable.delegate = self;
    brandTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:brandTable];
    [brandTable release];
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
    return self.brandArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"GrouponBrandCell";
    
    CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
	if (cell == nil) {
		cell = [[[CommonCell alloc] initWithIdentifier:cellId height:50 style:CommonCellStyleChoose] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    cell.textLabel.text = [[self.brandArr safeObjectAtIndex:indexPath.row] safeObjectForKey:@"BrandName"];
    
    cell.cellImage.highlighted = [[self.checkIndexArr safeObjectAtIndex:indexPath.row] boolValue];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.brandArr.count <= 1) {
        return;
    }
    
    [self selectIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(grouponBrandFilterController:index:)])
    {
        [self.delegate grouponBrandFilterController:self index:indexPath.row];
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
    
    [brandTable reloadData];
}

-(void) selectItem:(NSDictionary *)selectedBrand
{
    if (selectedBrand==nil) {
        return;
    }
    
    for (int i=0; i<self.brandArr.count; i++)
    {
        NSDictionary *temDic=[self.brandArr safeObjectAtIndex:i];
        if (temDic==nil)
        {
            continue;
        }
        
        if([[temDic safeObjectForKey:@"BrandId"] intValue]==[[selectedBrand safeObjectForKey:@"BrandId"] intValue])
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
