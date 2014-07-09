//
//  AddPackingList.m
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-31.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "AddPackingList.h"
#import "PackingLib.h"
#import "QuickAddList.h"

@interface AddPackingList ()

@end

@implementation AddPackingList

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _alwaysDataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc{
    SFRelease(_tableView);
    SFRelease(_alwaysDataSource);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0,10, self.view.frame.size.width, SCREEN_HEIGHT-20-44-10) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark
#pragma  mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2+[self.alwaysDataSource count];
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
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"从清单库添加";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"自定义快速添加";
    }else{
        
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
//    UIView *topLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, y, 320.0f, 0.5f)];
//    topLineView.backgroundColor = [UIColor colorWithRed:188.0f / 255 green:188.0f / 255 blue:188.0f / 255 alpha:1.0f];
//    [view addSubview:topLineView];
//    [topLineView release];
    [view addSubview:[UIImageView dashedHalfLineWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 1.0f)]];

}

#pragma  mark
#pragma  mark  UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        //Packing library
        PackingLib *lib = [[PackingLib alloc] initWithTopImagePath:nil andTitle:@"清单库" style:_NavOnlyBackBtnStyle_];
        [self.navigationController pushViewController:lib animated:YES];
        [lib release];
        

    }else if (indexPath.row == 1){
        //Quick Add

        QuickAddList *quick = [[QuickAddList alloc] initWithTopImagePath:nil andTitle:@"自定义快速添加" style:_NavOnlyBackBtnStyle_];
        [self.navigationController pushViewController:quick animated:YES];
        [quick release];
    }
}

@end
