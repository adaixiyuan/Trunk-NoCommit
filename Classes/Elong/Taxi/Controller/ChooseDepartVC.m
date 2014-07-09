//
//  ChooseDepartVC.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-2-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ChooseDepartVC.h"
#import "ElongURL.h"
#import "AddressInfo.h"
#import "TaxiPublicDefine.h"
#import "SearchBarView.h"

#define DELETE_TIP @"是否删除历史记录"

@implementation NSMutableArray (contains)

-(BOOL)containsTheAddress:(AddressInfo *)info{

    for (AddressInfo *model in self) {
        if ([model.name isEqualToString:info.name]) {
            return YES;
            break;
        }
    }
    return NO;
}

@end

@interface ChooseDepartVC ()

@end
//高德-输入后提示
#define REQUEST_INPUT(input,city) [NSString stringWithFormat:@"%@assistant/inputtips?keywords=%@&key=%@&city=%@",GAODE_API_PRE,input,GAODE_KEY,city]
//目的地专用（特定城市 关键词搜索）
#define REQUEST_Address(address,city)  [NSString stringWithFormat:@"%@place/text?keywords=%@&key=%@&offset=10&page=1&city=%@",GAODE_API_PRE,address,GAODE_KEY,city]
//详情请求
#define REQUEST_DETAIL(address_id) [NSString stringWithFormat:@"%@place/detail?id=%@&key=%@&s=rsv3",GAODE_API_PRE,address_id,GAODE_KEY]

@implementation ChooseDepartVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _arounds = [[NSMutableArray alloc] init];
        _searchResults = [[NSMutableArray alloc] init];
        _needLatAndLongtitude = NO;
        _checkSpanCity = NO;
        _entrance = Entrance_Taxi;//默认打车
        _searchCity = @"北京";//默认北京
    }
    return self;
}

-(void)setType:(TaxiDepart_Type)type{

    _type = type;
    
    if (_type == TaxiDepart_start) {
        
        //定位失败
        FastPositioning *fast = [FastPositioning shared];
        NSString *address = fast.addressName;
        if (!STRINGHASVALUE(address)) {
            //
            address = @"未定位成功,点击后再次定位";
            [_arounds addObject:address];
            locatedSuccess = NO;
        }else{
            locatedSuccess = YES;
        }
        
        NSData *data  = [[NSUserDefaults standardUserDefaults] objectForKey:TAXI_START_HIS];
        
        if (data) {
            NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            self.hisyorys = array;
        }else{
            NSMutableArray *array = [[NSMutableArray alloc] init];
            self.hisyorys = array;
            [array release];
        }
    }else if (_type == TaxiDepart_end){
        
        NSData *data = nil;
        if (self.entrance == Entrance_Taxi) {
            data  = [[NSUserDefaults standardUserDefaults] objectForKey:TAXI_END_HIS];
        }else if (self.entrance == Entrance_RentCar){
            data  = [[NSUserDefaults standardUserDefaults] objectForKey:RENT_END_HIS];
        }
        
        if (data) {
            NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            self.hisyorys = array;
        }else{
        
            NSMutableArray *array = [[NSMutableArray alloc] init];
            self.hisyorys = array;
            [array release];
            
        }
    }
    
}
-(int)type{
    return _type;
}

-(void)dealloc{
    if (poiUtil) {
        [poiUtil cancel];
        SFRelease(poiUtil);
    }
    SFRelease(_searchCity);
    SFRelease(_tableView);
    SFRelease(_arounds);
    SFRelease(_hisyorys);
    SFRelease(_searchResults);
    SFRelease(_selected_Address);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    currentld = [[PositioningManager shared] myCoordinate];
    
    UISearchBar *searchBar = [[SearchBarView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	searchBar.delegate = self;
    searchBar.placeholder = (self.type == TaxiDepart_start)?@"输入附近出发地":@"输入目的地";
    searchBar.showsCancelButton = NO;
    [self.view addSubview:searchBar];
    [searchBar release];
    
    searchBarIsActice = NO;
    
    CGFloat tableHeight = MAINCONTENTHEIGHT-44;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 + searchBar.frame.size.height, self.view.bounds.size.width, tableHeight)
                              style:UITableViewStylePlain];
	
	_tableView.backgroundColor = [UIColor whiteColor];
	_tableView.delegate=self;
	_tableView.dataSource=self;
	_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    if (self.type == TaxiDepart_start) {
        FastPositioning *fast = [FastPositioning shared];
        NSString *key = fast.addressName;
        if (STRINGHASVALUE(key)) {
            [self searchAroundByGaodeKeyword:key WithLoading:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark  UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (self.type == TaxiDepart_start) {
        return (searchBarIsActice)?1:2;
    }else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.type == TaxiDepart_start) {

        if (searchBarIsActice) {
            return [_searchResults count];
        }else{
            switch (section) {
                case 0:
                    return [_arounds count];
                    break;
                case 1:
                    return [self.hisyorys count];
                    break;
                default:
                    break;
            }
        }

    }else{
        return (searchBarIsActice)?[_searchResults count]:[self.hisyorys count];
    }

    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 55.0f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    float height;
    if (self.type == TaxiDepart_start) {
        if (section == 1) {
            height = ([self.hisyorys count] == 0)?0:22.0f;
        }else{
            height = 22.0f;
        }
    }else{
    
        height = ([self.hisyorys count] == 0)?0:22.0f;

    }
    
    
    return (searchBarIsActice)?0:height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (searchBarIsActice) {
        return nil;
    }else{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
        label.backgroundColor = RGBACOLOR(245, 245, 245, 1.0);
        label.font = FONT_B15;
        label.textColor = RGBACOLOR(52, 52,52, 1);
        if (self.type == TaxiDepart_start) {
            switch (section) {
                case 0:
                    label.text = @"  当前位置及周边";
                    break;
                 case 1:
                    label.text = @"  历史记录";
                    break;
                default:
                    break;
            }
            return [label autorelease];
        }else{
            if ([self.hisyorys count] != 0) {
                label.text = @"  历史记录";
                return [label autorelease];
            }else{
            
                [label release];
                return nil;
            }
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 52);
        [cell.textLabel setFont:FONT_17];
        cell.detailTextLabel.textColor = RGBCOLOR(118, 118, 118, 1);
        [cell.detailTextLabel setFont:FONT_15];
    }
    
    if (self.type == TaxiDepart_start) {
        //出发地
        AddressInfo *address_dic = nil;
        if (searchBarIsActice) {
            address_dic = [_searchResults objectAtIndex:indexPath.row];
            cell.textLabel.text = address_dic.name;
            cell.detailTextLabel.text = address_dic.address;
        }else{
            if (indexPath.section == 0) {
                if (locatedSuccess) {
                    address_dic = [_arounds objectAtIndex:indexPath.row];
                    cell.textLabel.text = address_dic.name;
                    cell.detailTextLabel.text = address_dic.address;
                }else{
                    
                    cell.textLabel.text = [_arounds objectAtIndex:indexPath.row];
                    
                }
            
            }else if (indexPath.section == 1){
                NSArray *display = [[self.hisyorys reverseObjectEnumerator] allObjects];
                address_dic = [display  objectAtIndex:indexPath.row];
                cell.textLabel.text = address_dic.name;
                cell.detailTextLabel.text = address_dic.address;
            }
        }


    }else{
    
        //目的地
        AddressInfo *address_dic = nil;
        if (searchBarIsActice) {
            address_dic = [_searchResults objectAtIndex:indexPath.row];
        }else{
            NSArray *display = [[self.hisyorys reverseObjectEnumerator] allObjects];
            address_dic = [display objectAtIndex:indexPath.row];
        }
        
        NSLog(@"name is %@  address is %@",address_dic.name,address_dic.address);
        
        cell.textLabel.text = address_dic.name;
        if ([address_dic.address isKindOfClass:[NSString class]]) {
            cell.detailTextLabel.text = address_dic.address;
        }
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (self.type == TaxiDepart_start) {
        if (section == 1) {
            float height = 0;
            if ([self.hisyorys count] != 0) {
                height = 50;
            }
            return (searchBarIsActice)?0:height;
        }
    }else if (self.type == TaxiDepart_end){
        float height = 0;
        if ([self.hisyorys count] != 0) {
            height = 50;
        }
        return (searchBarIsActice)?0:height;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [btn setTitle:@"清除历史记录" forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];//COLOR_NAV_BTN_TITLE RGBACOLOR(22, 126, 251, 1)
    [btn setBackgroundColor:RGBACOLOR(245, 245, 245, 1)];
    [btn addTarget:self action:@selector(deleteTheHistoryData:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.type == TaxiDepart_start) {
        //
        if (section == 1) {
            return btn;
        }
        
    }else if (self.type == TaxiDepart_end){
        return btn;
    }
    return nil;
}

-(void)deleteTheHistoryData:(UIButton *)sender{
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:DELETE_TIP delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        [self.hisyorys removeAllObjects];
        [_tableView reloadData];
        
        if (self.type == TaxiDepart_start) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:TAXI_START_HIS];
            
        }else if (self.type == TaxiDepart_end){
            
            if (self.entrance == Entrance_Taxi) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:TAXI_END_HIS];
            }else if (self.entrance == Entrance_RentCar){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:RENT_END_HIS];
            }
        }
    }
    
}

#pragma  mark
#pragma  mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    AddressInfo *address;
    
    if (self.type == TaxiDepart_start) {
        //出发地
        if (searchBarIsActice) {
            //周边搜索
            address = [_searchResults objectAtIndex:indexPath.row];
            
            if (self.checkSpanCity) {
                self.selected_Address = address;
                //确定选择地方的城市
                [HttpUtil requestURL:REQUEST_DETAIL(address.gaoDe_ID) postContent:nil delegate:self];
            }else{
                [self dealWithTheSelectedAddress:address];
                if (_delegate && [_delegate respondsToSelector:@selector(getTheSelectedAddressInfo:andDepartType:)]) {
                    [_delegate getTheSelectedAddressInfo:address andDepartType:self.type];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }else{
            if (indexPath.section == 0) {
                //高德默认周边
                if (locatedSuccess) {
                    address = [_arounds objectAtIndex:indexPath.row];
                }else{
                    
                    FastPositioning *fast = [FastPositioning shared];
                    [fast fastPositioning];
                
                    self.navigationController.view.userInteractionEnabled = NO;
                    
                    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                    cell.textLabel.text = @"正在定位,请稍候......";
                    cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 52);
                    cell.textLabel.font = FONT_15;
                    [self performSelector:@selector(updateTheArround) withObject:nil afterDelay:3.0];
                    return;
                }
                
            }else{
                //历史记录
                NSArray *array = [[self.hisyorys reverseObjectEnumerator] allObjects];
                address = [array  objectAtIndex:indexPath.row];
            }
            
            // Go ahead
            [self dealWithTheSelectedAddress:address];
            
            if (_delegate && [_delegate respondsToSelector:@selector(getTheSelectedAddressInfo:andDepartType:)]) {
                [_delegate getTheSelectedAddressInfo:address andDepartType:self.type];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        

        
    }else{
        //目的地
        if (searchBarIsActice) {
            //高德搜索
            address = [_searchResults objectAtIndex:indexPath.row];
            
            if (self.checkSpanCity) {
                self.selected_Address = address;
                //确定选择地方的城市
                [HttpUtil requestURL:REQUEST_DETAIL(address.gaoDe_ID) postContent:nil delegate:self];
            }else{
                [self dealWithTheSelectedAddress:address];
                if (_delegate && [_delegate respondsToSelector:@selector(getTheSelectedAddressInfo:andDepartType:)]) {
                    [_delegate getTheSelectedAddressInfo:address andDepartType:self.type];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }

        }else{
            //历史记录
            NSArray *array = [[self.hisyorys reverseObjectEnumerator] allObjects];
            address = [array objectAtIndex:indexPath.row];
            [self dealWithTheSelectedAddress:address];
            if (_delegate && [_delegate respondsToSelector:@selector(getTheSelectedAddressInfo:andDepartType:)]) {
                [_delegate getTheSelectedAddressInfo:address andDepartType:self.type];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)dealWithTheSelectedAddress:(AddressInfo *)info{

//    按 出发地  目的地  机场 分类！
    
    if (![self.hisyorys containsTheAddress:info]) {
        //不包括
        if ([self.hisyorys count] == 5) {
            //
            [self.hisyorys removeObjectAtIndex:0];
        }
            //
            [self.hisyorys addObject:info];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.hisyorys];

    if (self.type == TaxiDepart_start) {
        
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:TAXI_START_HIS];
        
    }else{
        if (self.entrance == Entrance_Taxi) {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:TAXI_END_HIS];
        }else if (self.entrance == Entrance_RentCar){
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:RENT_END_HIS];

        }

    }
    
}

-(void)updateTheArround{
 
    FastPositioning *fast = [FastPositioning shared];
    
    if (STRINGHASVALUE(fast.addressName)) {
        locatedSuccess = YES;
        [self searchAroundByGaodeKeyword:fast.addressName WithLoading:YES];
    }else{
        locatedSuccess = NO;
        [Utils alert:@"定位失败,请重试!"];
        [_tableView reloadData];
    }
    self.navigationController.view.userInteractionEnabled = YES;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
    if (!STRINGHASVALUE(searchBar.text)) {
        searchBarIsActice = NO;
        [_tableView reloadData];
    }else{
        
        //业务层面需要，此处若是从租车入口进来需要用户点击（预估价需要经纬度）
        
        if (!self.needLatAndLongtitude) {
            //输入不为空
            NSString *stringValue = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            AddressInfo *info = [[AddressInfo alloc] init];
            info.name = stringValue;
            [self dealWithTheSelectedAddress:info];
            [info    release];
            
            if (self.type == TaxiDepart_end) {
                if (_delegate && [_delegate respondsToSelector:@selector(getTheUserInputAddress:andDepartType:)]) {
                    [_delegate getTheUserInputAddress:stringValue andDepartType:self.type];
                    [super back];
                }
            }
        }
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
  
    [searchBar resignFirstResponder];
    searchBarIsActice = NO;
    searchBar.showsCancelButton = NO;
    [_tableView reloadData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    searchBarIsActice = YES;
    searchBar.showsCancelButton = YES;
    
    [_tableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    NSLog(@"Input Place Name is %@",searchText);
    
    NSString *stringValue = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (STRINGHASVALUE(stringValue)) {
        [self searchInputTipWithLoading:NO keyword:searchText];
    }else{
        [_searchResults removeAllObjects];
        [_tableView reloadData];
    }

}

#pragma mark
#pragma mark Net-Nav
-(void)searchAroundByGaodeKeyword:(NSString *)keyword WithLoading:(BOOL)yes{

    NSString *postString = nil;
    
    postString = [NSString stringWithFormat:@"%@place/around?keywords=%@&location=%f,%f&key=%@&radius=500&city=",
                  GAODE_API_PRE,
                  keyword,
                  currentld.longitude,
                  currentld.latitude,
                  GAODE_KEY];

    [self searchPoiWithURLString:postString withLoading:yes];
}

-(void)searchInputTipWithLoading:(BOOL)loading keyword:(NSString *)keywiord{

    NSString *city = (STRINGHASVALUE(self.searchCity))?self.searchCity:[[PositioningManager shared] positionCurrentCity];
    if ([city hasPrefix:@"香港"] || [city hasPrefix:@"澳门"]) {
        city = @"1852";//高德对港澳的中文支持不好，需要转化为地区代码
    }
    [self searchPoiWithURLString:REQUEST_Address(keywiord,city) withLoading:NO];

}


- (void)searchPoiWithURLString:(NSString *)url withLoading:(BOOL)yes{
    
    NSString *getUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (USENEWNET) {
        if (poiUtil) {
            [poiUtil cancel];
            SFRelease(poiUtil);
        }
        poiUtil = [[HttpUtil alloc] init];
        [poiUtil connectWithURLString:getUrl
                              Content:nil
                         StartLoading:yes
                           EndLoading:yes
                             Delegate:self];
    }
    // 网络加载符
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark -
#pragma mark NetLink
#pragma mark onPostConnect & onPostConnect

- (void)httpConnectionDidCanceled:(HttpUtil *)util{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSDictionary *root = nil;
    NSString *outStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    root = [outStr JSONValue];
    [outStr release];
    if(util == poiUtil){
        [self dealWithPoiResult:root];
    }else{
        //详情
        [self dealwithDetailRoot:root];
    }
    // 网络加载符
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void) dealWithPoiResult:(NSDictionary *)root{
    
    NSString *status = [root objectForKey:@"status"];
    if (![status isEqualToString:@"1"]) {
        return;
    }

    if (searchBarIsActice) {
        [_searchResults removeAllObjects];
    }else{
            [_arounds removeAllObjects];
    }
    
    NSArray *array = nil;
        array = [root safeObjectForKey:@"pois"];

    if (nil != array  && [array count] > 0) {
        for (int i = 0; i < [array count]; i++) {
            NSDictionary *dic = [array objectAtIndex:i];
                AddressInfo *info = [[AddressInfo alloc] init];
            [info    convertObjectFromGievnDictionary:dic relySelf:YES];
            if (![info.address isKindOfClass:[NSString class]]) {
                info.address = @"";
            }
                if (searchBarIsActice) {
                    info.gaoDe_ID = [dic objectForKey:@"id"];//搜索时可用
                    [_searchResults addObject:info];
                }else{
                    [_arounds addObject:info];
                }
                [info release];
        }
    }
    [_tableView reloadData];
}

-(void)dealwithDetailRoot:(NSDictionary *)root{

    NSString *status = [root objectForKey:@"status"];
    if (![status isEqualToString:@"1"]) {
        return;
    }
    
    NSArray *array = [root objectForKey:@"pois"];
    NSString *city = @"";
    if (nil != array  && [array count] > 0) {
        for (NSDictionary *dic in array) {
            city = [dic objectForKey:@"cityname"];
        }
    }
    
    if (STRINGHASVALUE(city)) {
        self.selected_Address.cityName = city;
    }else{
        self.selected_Address.cityName = self.searchCity;
    }
    
    //记录
    [self dealWithTheSelectedAddress:self.selected_Address];
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(getTheSelectedAddressInfo:andDepartType:)]) {
        [_delegate getTheSelectedAddressInfo:self.selected_Address andDepartType:self.type];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
