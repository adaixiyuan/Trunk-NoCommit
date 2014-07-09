//
//  MyPackingList.m
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "MyPackingList.h"
#import "PackingSetting.h"
#import "PackingListCell.h"
#import "PackingModel.h"
#import "PackingCategory.h"
#import "PackingItem.h"
#import "AddTravel.h"
#import "PackingCategoryList.h"
#import "PackingDefine.h"
#import "NSMutableArray+DeepCopy.h"
@interface MyPackingList ()

@end

#define STATISTIC_KEY @"logRecordStatus"

@implementation MyPackingList

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isFristIn = NO;
        [self initTheModuleData];
        [self readTheDefaultData];
        
        //注册通知，接受来自同步成功的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTheUserDefaultData:) name:SYSCHRONIED_PACKING_REFRESH object:nil];
    }
    return self;
}

//从Categorylist到最小的item
-(NSMutableArray *)getEntitysFromGivenCategoryArrays:(NSMutableArray *)array{

    //初始化数据，转换成实体对象!
    NSMutableArray *category_Array = [[NSMutableArray alloc] initWithCapacity:[array count]];
    
    for (NSDictionary *dic in array) {
        PackingCategory *category = [[PackingCategory alloc] init];
        NSArray *keys = [dic allKeys];
        for (NSString *key in keys) {
            if ([dic objectForKey:key] != nil) {
                [category setValue:[dic objectForKey:key] forKey:key];
            }
        }
        //解析得到 Category 继续解析 得到Item
        NSMutableArray *item_array = [[NSMutableArray alloc] initWithCapacity:[category.itemList count]];
        for (NSDictionary *object in category.itemList) {
            PackingItem *item = [[PackingItem alloc] init];
            NSArray *keys = [object allKeys];
            for (NSString *key in keys) {
                if ([object objectForKey:key] != nil) {
                    [item setValue:[object objectForKey:key] forKey:key];
                }
            }
            //得到Item
            [item_array addObject:item];
            [item release];
        }
        //解析完毕
        [category.itemList removeAllObjects];
        [category.itemList addObjectsFromArray:item_array];
        [item_array release];
        
        [category_Array addObject:category];
        [category release];
    }
    return [category_Array autorelease];
}

-(void)initTheModuleData{
    /*
     *初始化plist文件，其一为官方示例 其二为清单库
     主要是将上述文件 实体化并存储在缓存中，以后供后续页面使用
     */
    
    //清单库
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:PACKING_LIB_MODIFY];
    if (data == NULL) {
        //从Plist读取
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:PACKING_LIB_PLIST ofType:@"plist"];
        NSFileManager  *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:plistPath]) {
            NSLog(@"Cannot find the plist file !");
        }
    
        NSMutableArray *plistData = [NSMutableArray arrayWithContentsOfFile:plistPath];
        //最终结果(已转化为实体的数组)
        NSMutableArray *category_Array = [self getEntitysFromGivenCategoryArrays:plistData];
        
        NSData *save = [NSKeyedArchiver archivedDataWithRootObject:category_Array];
        [[NSUserDefaults standardUserDefaults] setObject:save forKey:PACKING_LIB_MODIFY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    /*
     以上是将清单库由plist转化为实体，并存储
     */
    
    //官方示例(模版)
    NSData *offical = [[NSUserDefaults standardUserDefaults] objectForKey:PACKING_TEMPLATE];
    if (offical == NULL) {
        //从Plist读取
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:PACKING_LIST_PLIST ofType:@"plist"];

        NSFileManager  *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:plistPath]) {
            NSLog(@"Cannot find the plist file !");
	}
        

        NSMutableArray *plistData = [NSMutableArray arrayWithContentsOfFile:plistPath];
          _isFristIn = YES;
        //最终结果(已转化为实体的数组)
        
        NSMutableArray *travels_array = [[NSMutableArray alloc] initWithCapacity:[plistData count]];
        for (NSDictionary *dic in plistData) {
            PackingModel *travel = [[PackingModel alloc] init];
            NSArray *keys = [dic allKeys];
            for (NSString *key in keys) {
                if ([dic objectForKey:key] != nil) {
                    [travel setValue:[dic objectForKey:key] forKey:key];
                }
            }
            //解析嵌套的Categorylist
            NSMutableArray *category_Array = [self getEntitysFromGivenCategoryArrays:travel.categoryList];
            [travel.categoryList removeAllObjects];
            [travel.categoryList addObjectsFromArray:category_Array];
            [travels_array addObject:travel];
            [travel release];
        }
        
        NSData *save = [NSKeyedArchiver archivedDataWithRootObject:travels_array];
        [travels_array release];
        [[NSUserDefaults standardUserDefaults] setObject:save forKey:PACKING_TEMPLATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

-(void)readTheDefaultData{
    
    NSData *user = [[NSUserDefaults standardUserDefaults] objectForKey:PACKING_USER_PACKING_LIST];
    if (user == NULL) {
        //第一次进来 没有用户数据，读取默认的数据
        NSData *offical = [[NSUserDefaults standardUserDefaults] objectForKey:PACKING_TEMPLATE];
        self.dataSource = [NSKeyedUnarchiver unarchiveObjectWithData:offical];
        
        int intenationIndex = 0;
        for (PackingModel *model in self.dataSource) {
            if ([model.name isEqualToString:@"国际游模版"]) {
                intenationIndex = [self.dataSource indexOfObject:model];
            }
            if ([model.name isEqualToString:@"国内游模版"]) {
                model.name = @"三亚蜜月行  (示例)";
            }else if ([model.name isEqualToString:@"出差模版"]){
                model.name = @"上海公务出差  (示例)";
            }
        }
        
        [self.dataSource removeObjectAtIndex:intenationIndex];
        
    }else{
        
        self.dataSource = [NSKeyedUnarchiver unarchiveObjectWithData:user];
        
    }
    [self caculateThePackingProgressWithArray:self.dataSource];
    [_tableView reloadData];
    
}

/*
-(void)adjustTheNewBtn{
    
    int MAX_DISPLAY = 0;
    if (SCREEN_4_INCH) {
        MAX_DISPLAY = 5;
    }else{
        MAX_DISPLAY = 4;
    }
    if ([self.dataSource count] >MAX_DISPLAY) {
        [_tableView setContentOffset:CGPointMake(0, ([self.dataSource count]-MAX_DISPLAY)*81) animated:YES];
    }
}
*/


-(void)caculateThePackingProgressWithArray:(NSMutableArray *)array{

    int total = 0;
    int checked = 0;
    for (PackingModel *model in array) {
        //取出类目的list
        for (PackingCategory *category in model.categoryList) {
            //每个类目中items
            total += [category.itemList count];
            //最底层的Item
            for (PackingItem *itemDic in category.itemList) {
                if ([itemDic.isChecked isEqualToString:@"true"]) {
                    checked += 1;
                }
            }
        }
        float progress = (total == 0)?0.0f:(float)checked/total;
        model.progress = progress;
        //计算完之后 归0
        checked = 0;
        total = 0;
    }
}

-(void)dealloc{
    
    SFRelease(_tableView);
    SFRelease(_dataSource);
    [super dealloc];
}

- (void)back
{
    [self updateTheUserDefaultPackingListData];
    [PublicMethods closeSesameInView:self.navigationController.view];
}

-(void)pushSetting{

    //保存数据(prepare for 同步)
    [self updateTheUserDefaultPackingListData];
    
    PackingSetting *setting = [[PackingSetting alloc] initWithTopImagePath:nil andTitle:@"设置" style:_NavOnlyBackBtnStyle_];
    [self.navigationController pushViewController:setting animated:YES];
    [setting release];
}

-(void)reloadTheUserDefaultData:(id)userInfo{
    //从服务器上更新下来的数据
    NSArray *updateArray = [userInfo object];
    
    NSMutableArray *old = [[NSMutableArray alloc] init];
    for (PackingModel*model in self.dataSource) {
        if (![model.isFix isEqualToString:@"1"]) {
            [old addObject:model];
        }
    }
    
    [self.dataSource removeObjectsInArray:old];
    [old release];
    [self.dataSource addObjectsFromArray:updateArray];

    [self  updateTheUserDefaultPackingListData];

}

-(void)updateTheUserDefaultPackingListData{
    //更新数据
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:self.dataSource];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:PACKING_USER_PACKING_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)tapAndRemove:(UIControl *)control{
    
    [control removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    
    NSString  *yes = [[NSUserDefaults standardUserDefaults] objectForKey:@"FIRST_CREATE_TRAVEL"];
    if ([yes isEqualToString:@"YES"]) {
        //引导
        UIControl    *control = [[UIControl  alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        NSLog(@"%d",(int)SCREEN_HEIGHT);
        NSString *pngImage = [NSString stringWithFormat:@"Guide_Packing_%d.png",(int)SCREEN_HEIGHT];
        control.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:pngImage]];
        [control addTarget:self action:@selector(tapAndRemove:) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].delegate.window addSubview:control];
        [control release];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"FIRST_CREATE_TRAVEL"];
    }
    
    if (self.scrollowTop) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
        self.scrollowTop = NO;
    }
}
-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:YES];
    //计算当前完成度
    [self caculateThePackingProgressWithArray:self.dataSource];
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Setting
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"设置" Target:self Action:@selector(pushSetting)];
    
    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0,5, self.view.frame.size.width, SCREEN_HEIGHT-20-44-5) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
    //FooterView
    UIButton *footer = [UIButton buttonWithType:UIButtonTypeCustom];
    [footer setFrame:CGRectMake(0, 0, 320, 85)];
    [footer setBackgroundColor:PACKING_BACKCOLOR];
    
    UIImage *image = [UIImage imageNamed:@"addPacking.png"];
    [footer setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [footer setImage:image forState:UIControlStateNormal];
    [footer setImage:[UIImage imageNamed:@"addPacking_High.png"] forState:UIControlStateHighlighted];
    [footer addTarget:self action:@selector(addNewTravel) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.tableFooterView = footer;
 
    self.scrollowTop = YES;
    
    isDeleted = NO;
}

#pragma mark - HttpUtil Delegate
-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsErrorNoAlert:root]){
        return ;
    }
}

-(void)addNewTravel{
    
    AddTravel *add = [[AddTravel alloc] initWithTopImagePath:nil andTitle:@"添加行程" style:_NavOnlyBackBtnStyle_];
    add.dataSource = self.dataSource;
    [self.navigationController pushViewController:add animated:YES];
    [add release];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshTheUserAlwaysUsedTemplateData:(PackingModel *)model{

    //刷新常用模版库
    NSData *offical = [[NSUserDefaults standardUserDefaults] objectForKey:PACKING_TEMPLATE];
    if (offical == nil) {
        NSLog(@"模版－－数据错误-----");
        return;
    }
    
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:offical];
    
    if ([model.isAlwaysUsed isEqualToString:@"1"]) {
        //添加
        PackingModel *m_model = [model mutableCopy];
        [array addObject:m_model];
        [m_model release];
        
    }else{
        //移除
        int index = 0;
        for (PackingModel *p_model in array) {
            if ([p_model.name isEqualToString:model.name]) {
                index = [array indexOfObject:p_model];
            }
        }
        [array removeObjectAtIndex:index];
    }
    
    NSData *save = [NSKeyedArchiver archivedDataWithRootObject:array];
    [[NSUserDefaults standardUserDefaults] setObject:save forKey:PACKING_TEMPLATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma  mark
#pragma  mark UITableViewDataSource

//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return YES;
//}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = [[self.dataSource reverseObjectEnumerator] allObjects];
    PackingModel *model = [array objectAtIndex:indexPath.row];
    
    if ([model.isAlwaysUsed isEqualToString:@"1"]) {
        if (!isDeleted) {
            [Utils alert:@"示例不可删除"];
        }
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        NSArray *array = [[self.dataSource reverseObjectEnumerator] allObjects];
        [self.dataSource removeObject:[array objectAtIndex:indexPath.row]];
        isDeleted = YES;
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{

    isDeleted = NO;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.dataSource count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 81;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";
    PackingListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PackingListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    NSArray *array = [[self.dataSource reverseObjectEnumerator] allObjects];
    [cell bingThePackingModel:[array objectAtIndex:indexPath.row]];
    
    return cell;
}


#pragma mark
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    NSArray *array = [[self.dataSource reverseObjectEnumerator] allObjects];
    PackingModel *model = [array objectAtIndex:indexPath.row];
    PackingCategoryList *list = [[PackingCategoryList alloc] initWithTopImagePath:nil andTitle:model.name style:_NavOnlyBackBtnStyle_];
    list.packing = model;
    list.isFirstIn = self.isFristIn;
    [self.navigationController pushViewController:list animated:YES];
    [list release];
}

@end
