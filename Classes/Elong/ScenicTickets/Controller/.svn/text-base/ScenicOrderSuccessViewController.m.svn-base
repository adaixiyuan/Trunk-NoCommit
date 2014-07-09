//
//  ScenicOrderSuccessViewController.m
//  ElongClient
//
//  Created by jian.zhao on 14-5-19.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicOrderSuccessViewController.h"
#import "AccountManager.h"
@interface ScenicOrderSuccessViewController ()

@end

@implementation ScenicOrderSuccessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_orderTicketName release];
    [_orderNum release];
    [_priceNum release];
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setOrderTicketName:nil];
    [self setOrderNum:nil];
    [self setPriceNum:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,210, SCREEN_WIDTH, 88) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark
#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentiier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentiier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_rightarrow.png"]];
        cell.accessoryView = imageView;
        [imageView release];
        
        cell.textLabel.textColor = RGBACOLOR(54, 54, 54, 1);
        cell.textLabel.font = FONT_13;
        if (indexPath.row == 0) {
            [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)]];
        }
    }
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage noCacheImageNamed:@"viewOrder.png"];
        cell.textLabel.text = @"查看订单";
    }else if (indexPath.row == 1){
        if (IOSVersion_6 && [[AccountManager instanse] isLogin] && [PublicMethods passHotelOn]) {
            cell.textLabel.text = @"添加到Passbook";
            cell.imageView.image = [UIImage noCacheImageNamed:@"addToPassBook.png"];
        }else{
            cell.textLabel.text = @"添加到相册";
        }
    }
    
    return cell;
}

#pragma mark
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSLog(@"You choose is 查看订单");
    }else{
        NSLog(@"Save to PassBook");
    }
}

@end
