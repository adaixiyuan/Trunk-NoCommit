//
//  FlightListViewController.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-3-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightListViewController.h"
#import "SearchBarView.h"
#import "RentFlightCell.h"
#import "TaxiPublicDefine.h"
#import "RentFlight.h"
#import "TaxiUtils.h"

#define SEARCHBAR_TAG 100
#define Tip_Internationnal @"暂不支持国际航班的接机服务"
#define  Tip_Error @"请输入正确的航班号"
#define Tip_NoSupport @"暂不支持此航班降落机场的接机服务"
#define DELETE_TIP @"是否删除历史记录"

@interface NSMutableArray (contains)

-(BOOL)containsFlight:(id)anObject;

-(int)indexOfFlight:(id)object;

@end

@implementation NSMutableArray (contains)

-(BOOL)containsFlight:(id)anObject{
    
    RentFlight *flight = (RentFlight *)anObject;
    for (RentFlight *model in self) {
        if ([model.flight isEqualToString:flight.flight]) {
            return YES;
        }
    }
    return NO;
}

-(int)indexOfFlight:(id)object{
    
    RentFlight *flight = (RentFlight *)object;
    for (RentFlight *model in self) {
        if ([model.flight isEqualToString:flight.flight]) {
            return [self indexOfObject:model];
        }
    }
    return -1;
}
@end

@interface FlightListViewController ()

@end

@implementation FlightListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray *array = [[NSMutableArray alloc] init];
        self.dataSource = array;
        [array release];
        
        NSMutableArray *array_ = [[NSMutableArray alloc] init];
        self.historySource = array_;
        [array_ release];
        [self.historySource addObjectsFromArray:[TaxiUtils getRentCarHistoryWithGivenType:RentHistory_Flight]];
        
        self.flightNo = @"";
        
        searchActive = NO;

    }
    return self;
}

-(void)dealloc{
    if (httpUti) {
        [httpUti cancel];
        SFRelease(httpUti);
    }
    self.dataSource = nil;
    self.time = nil;
    self.flightNo = nil;
    self.historySource = nil;
    [_tableView release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UISearchBar *searchBar = [[SearchBarView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	searchBar.delegate = self;
    searchBar.placeholder = @"请输入航班号";
    searchBar.showsCancelButton = NO;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    searchBar.tag = SEARCHBAR_TAG;
    searchBar.keyboardType = UIKeyboardAppearanceAlert;
    [self.view addSubview:searchBar];
    [searchBar release];
    
    CGFloat tableHeight = MAINCONTENTHEIGHT-44;
    
    searchBarHeight = searchBar.frame.size.height;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 + searchBarHeight, self.view.bounds.size.width, tableHeight)
                                              style:UITableViewStylePlain];
	
	_tableView.backgroundColor = [UIColor whiteColor];
	_tableView.delegate=self;
	_tableView.dataSource=self;
	_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return (searchActive)?[self.dataSource count]:[self.historySource count];
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (searchActive)?0:([self.historySource count] == 0)?0:22;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return (searchActive)?0:([self.historySource count] == 0)?0:50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    label.backgroundColor = RGBACOLOR(245, 245, 245, 1.0);
    label.font = FONT_B15;
    label.textColor = RGBACOLOR(52, 52,52, 1);
    label.text = @"  历史";
    return [label autorelease];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [btn setTitle:@"删除历史记录" forState:UIControlStateNormal];
    [btn setTitleColor:RGBACOLOR(22, 126, 251, 1) forState:UIControlStateNormal];
    [btn setBackgroundColor:RGBACOLOR(245, 245, 245, 1)];
    [btn addTarget:self action:@selector(deleteTheHistoryData:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";
    RentFlightCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == Nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RentFlightCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (searchActive) {
        RentFlight *flight = [self.dataSource objectAtIndex:indexPath.row];
        [cell bindTheDisplayModel:flight];
    }else{
        NSArray *reverse = [[self.historySource reverseObjectEnumerator] allObjects];
        RentFlight *flight = [reverse objectAtIndex:indexPath.row];
        [cell bindTheDisplayModel:flight];
    }
    return cell;
}

-(void)deleteTheHistoryData:(UIButton *)sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:DELETE_TIP delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [self.historySource removeAllObjects];
        [TaxiUtils saveTheHistoryData:self.historySource Type:RentHistory_Flight];
        [_tableView reloadData];
    }
}


#pragma mark
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (searchActive) {
        RentFlight *flight = [self.dataSource objectAtIndex:indexPath.row];
        
        if (!STRINGHASVALUE(flight.destCityCode)) {
            [Utils alert:Tip_NoSupport];
            return;
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(getTheSelectedAirport:andFlightNum:)]) {
            [_delegate getTheSelectedAirport:flight andFlightNum:flight.flight];
        }
        
        if ([self.historySource containsFlight:flight]) {
            [self.historySource replaceObjectAtIndex:[self.historySource indexOfFlight:flight] withObject:flight];
        }else{
            if ([self.historySource count]>=5) {
                [self.historySource replaceObjectAtIndex:4 withObject:flight];
            }else{
                [self.historySource addObject:flight];
            }
        }
        
        [TaxiUtils saveTheHistoryData:self.historySource Type:RentHistory_Flight];

    }else{
        NSArray *array = [[self.historySource reverseObjectEnumerator] allObjects];
        RentFlight *flight = [array objectAtIndex:indexPath.row];
        if (_delegate && [_delegate respondsToSelector:@selector(getTheSelectedAirport:andFlightNum:)]) {
            [_delegate getTheSelectedAirport:flight andFlightNum:flight.flight];
        }
        
    }
    [self back];
}


#pragma  mark
#pragma  mark  UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    searchActive = YES;
    [self.dataSource removeAllObjects];
    [_tableView reloadData];
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

    searchBar.showsCancelButton = NO;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchActive = NO;
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [_tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *convert = [searchBar.text uppercaseString];
    if ([TaxiUtils getTheFlightTypeByGivenString:convert] == International_Flight) {
        [Utils alert:Tip_Internationnal];
    }else if ([TaxiUtils getTheFlightTypeByGivenString:convert] == Error_Flight){
        [Utils alert:Tip_Error];
    }else if ([TaxiUtils getTheFlightTypeByGivenString:convert] == Inner_Flight){
        [searchBar resignFirstResponder];
        [self searchTheFlightWithUserInput:convert];
    }
}

-(void)searchTheFlightWithUserInput:(NSString *)string{

    NSDictionary *req = @{@"productType":RENT_PICKER,@"flightNo":string,@"flyDate":self.time};
    NSString *paramJson = [req JSONString];
    
    NSString *url = [PublicMethods composeNetSearchUrl:RENTCAR_URL forService:@"getAirportByFlightNo" andParam:paramJson];
    
    if (STRINGHASVALUE(url)) {
        if (httpUti) {
            [httpUti cancel];
            SFRelease(httpUti);
        }
        httpUti = [[HttpUtil alloc] init];
        [httpUti requestWithURLString:url Content:nil StartLoading:YES EndLoading:YES Delegate:self];
    }
}

#pragma mark
#pragma mark HTTP------------Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    
    NSDictionary  *root = [PublicMethods  unCompressData:responseData];
    if ([Utils checkJsonIsError:root])
    {
        return ;
    }
    self.flightNo = [root objectForKey:@"flightNo"];
    NSArray *array = [root objectForKey:@"flights"];
    if ([array count] > 0) {
        [self.dataSource removeAllObjects];
    }
    for (NSDictionary *dic in array) {
        RentFlight *flight = [[RentFlight alloc] init];
        [flight convertObjectFromGievnDictionary:dic relySelf:YES];
        if (!STRINGHASVALUE(flight.srcCity)) {
            flight.srcCity = flight.srcName;
        }
        if (!STRINGHASVALUE(flight.destCity)) {
            flight.destCity = flight.destName;
        }
        flight.flight = self.flightNo;
        [self.dataSource addObject:flight];
        [flight release];
    }
    [_tableView reloadData];
}
@end
