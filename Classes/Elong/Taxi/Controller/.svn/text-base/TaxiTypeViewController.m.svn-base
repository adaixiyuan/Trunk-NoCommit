//
//  TaxiTypeViewController.m
//  ElongClient
//
//  Created by nieyun on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiTypeViewController.h"
#import "TaxiFillCtrl.h"
#import "TaxiTypeCell.h"
#import "TaxiFillManager.h"
#import "EvaluteModel.h"
#import "RentCarChargesInfoViewController.h"
#import "LzssUncompress.h"
@implementation TaxiTypeViewController


- (void)dealloc
{
    [_totalAr release];
    setFree(_renCarManager)
    SFRelease(_table);
    [modelAr release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _table = [[UITableView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44-20) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view  addSubview:_table];
    _renCarManager = [[RentCarExplainManager alloc]init];
    [self  modelArMake];
    
    [self  initexplainButton];
    
}

- (void) modelArMake
{
    modelAr = [[NSMutableArray  alloc]init];
    for (NSDictionary  *dic  in  self.totalAr)
    {
        TaxiTypeModel  *model = [[TaxiTypeModel  alloc]initWithDataDic:dic];
        [modelAr addObject:model];
        [model release];
    }
}

- (void) initexplainButton
{
    UIButton  *favBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_WORDBTN_WIDTH, NAVBAR_ITEM_HEIGHT)] autorelease];
    favBtn.exclusiveTouch = YES;
    favBtn.adjustsImageWhenDisabled = NO;
    favBtn.titleLabel.font = FONT_B15;
	[favBtn setTitle:@"资费说明" forState:UIControlStateNormal];
    [favBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [favBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
	[favBtn addTarget:self action:@selector(explainAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:favBtn] autorelease];
}

- (void)explainAction
{//资费说明 by lc
    NSLog(@"资费说明");
    NSLog(@"代驾明细.....上半部分");
    [self.renCarManager resetself];  //参数要修改
    
    TaxiFillManager * taxiFillManager = [TaxiFillManager shareInstance];
    
    NSString *cityCode = [taxiFillManager currentCityCode];
    NSString *productType = [taxiFillManager productType];
    NSString *airPortCode = [taxiFillManager airPortCode];
    
    NSDictionary *jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:cityCode,@"cityCode",productType,@"productType",airPortCode,@"airPortCode",nil];
    NSString *jsonString = [jsonDic  JSONString];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"rentCar/getCarType" andParam:jsonString];
    _curRequestType = explainStep1_request;
    if (STRINGHASVALUE(url)) {
        [HttpUtil  requestURL:url postContent:Nil delegate:self];
    }
}

#pragma mark-TableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modelAr.count;
}
- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString  *str = @"cell";
   TaxiTypeCell  *cell = [tableView  dequeueReusableCellWithIdentifier:str];
    if (!cell)
    {
        cell =  [[[NSBundle  mainBundle] loadNibNamed:@"TaxiTypeCell" owner:self options:nil]lastObject];
    }
    cell.model = modelAr[indexPath.row];
    return cell;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    TaxiTypeModel  *model = modelAr[indexPath.row];
    
    TaxiFillManager  *manager = [TaxiFillManager shareInstance];
    
    manager.evalueRqModel.carTypeCode = model.carTypeCode;
    
    if ([model.serviceSupportor  isEqual:[NSNull  null]])
    {
        manager.evalueRqModel.serviceSupportor = @"";
    }else
    {
        manager.evalueRqModel.serviceSupportor = model.serviceSupportor;
    }
    
    manager.fillRqModel.carTypeBrand = model.carTypeBrand;
    
    [TaxiFillManager shareInstance].carTypeName = model.carTypeName;
   
    /**
     *  有目的地则请求
     */
        NSDictionary  *dic = [manager.evalueRqModel  convertDictionaryFromObjet];
        
        NSString  *jsonStr = [dic  JSONString];
       
        NSLog(@"%@",jsonStr);
        
        NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools"forService:@"rentCar/getEstimatedPrice" andParam:jsonStr];
        
        [HttpUtil  requestURL:url postContent:nil delegate:self];
   
    
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    
    NSDictionary  *root = [PublicMethods  unCompressData:responseData];
    NSLog(@"%@",root);
    if ([Utils checkJsonIsError:root])
    {
        return ;
    }
    
    //~lc{
    if (_curRequestType == explainStep1_request) {
        _curRequestType =explainStep2_request;
        [self.renCarManager parseStep1Reqestdict:root];
        //参数固定
        NSDictionary *jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:@"RentCar",@"channel",@"CarTypeList",@"page",@"ExpenseDescription",@"positionId",@"Iphone",@"productLine",nil];
        NSString *jsonString = [jsonDic  JSONString];
        NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"contentResource" andParam:jsonString];
        if (STRINGHASVALUE(url)) {
            [HttpUtil  requestURL:url postContent:Nil delegate:self];
        }
        return;
    }
    
    if (_curRequestType ==explainStep2_request) {
        _curRequestType = default_request;
        
        [self.renCarManager parseStep2Reqestdict:root];
        
        TaxiFillManager *manager = [TaxiFillManager shareInstance];
        NSString *city = manager.carUseCity;
        NSString *productType = manager.productType;
        NSString *userType = @"";
        if ([@"0201" isEqualToString:productType]) {
            userType = @"接机";
        }else if ([@"0202" isEqualToString:productType]){
            userType = @"送机";
        }
        NSString *fullstring = [NSString stringWithFormat:@"%@-%@",city,userType];
        //title要修改
        NSString *fullHTMLString = [self.renCarManager packageHTML:fullstring tip1Array:self.renCarManager.carTypeArray figureRule:self.renCarManager.figureRule rangeRule:self.renCarManager.rangeRule tip2Array:self.renCarManager.explainArray];
        RentCarChargesInfoViewController *carChargesVC = newObject(RentCarChargesInfoViewController);
        carChargesVC.fullhtmlString = fullHTMLString;
        [self.navigationController pushViewController:carChargesVC animated:YES];
        [carChargesVC release];
        return;
    }
    //~lc}
    [self  jumpToFillCtrl:root];
   
    
}

- (void)jumpToFillCtrl :(NSDictionary  *)root
{
    TaxiFillCtrl  *ctrl = [[TaxiFillCtrl  alloc]initWithTitle:@"填写订单" style:NavBarBtnStyleOnlyBackBtn];

    if (root)
    {
        EvaluteModel  *eModel = [[EvaluteModel  alloc]initWithDataDic:[root  objectForKey:@"estimatedDetail"]];
        
        ctrl.eModel = eModel;
        
        [eModel  release];

    }
    
    NSIndexPath  *indexPath = [_table  indexPathForSelectedRow];
    
    TaxiTypeModel  *tModel = modelAr[indexPath.row];
    
    ctrl.typeModel = tModel;
    
    [self.navigationController  pushViewController:ctrl animated:YES];
    
    [ctrl release];
    
    
}
- (void)httpConnectionDidCanceled:(HttpUtil *)util{
    //重置请求类型
    if (_curRequestType==explainStep1_request||_curRequestType==explainStep2_request) {
        _curRequestType = default_request;
    }
    
}
- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error{
    if (_curRequestType==explainStep1_request||_curRequestType==explainStep2_request) {
        _curRequestType = default_request;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
