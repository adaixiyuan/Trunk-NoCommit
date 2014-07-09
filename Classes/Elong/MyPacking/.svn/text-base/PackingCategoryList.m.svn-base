//
//  PackingCategoryList.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-1-2.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "PackingCategoryList.h"
#import "PackingModel.h"
#import "PackingCategory.h"
#import "PackingItem.h"
#import "CategoryListCell.h"
#import "AddPackingList.h"
#import "CategoryListBottomBar.h"
#import "MyPackingList.h"

#define  ARROW_UP   [UIImage imageNamed:@"packing_arrow_up.png"]
#define  ARROW_DOWN  [UIImage imageNamed:@"packing_arrow_down.png"]


@interface NSMutableArray (contains)

-(id)containsObjectsWithGivenName:(id )_object;


@end

@implementation NSMutableArray (contains)

-(id)containsObjectsWithGivenName:(id )_object{

    for (id object in self) {
        if ([[object valueForKey:@"_name"] isEqualToString:[_object valueForKey:@"_name"]]) {
            return object;
        }
    }
    return nil;
}


@end

@interface PackingCategoryList ()

@end

@implementation PackingCategoryList

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isOpen = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)back{

    MyPackingList *nav = nil;
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[MyPackingList class]]) {
            nav = (MyPackingList *)vc;
            break;
        }
    }
    nav.isFristIn = NO;
    [self.navigationController popToViewController:nav animated:YES];
}

-(void)dealloc{
    SFRelease(_customAdd);
    SFRelease(_lib_Add);
    SFRelease(_tableView);
    SFRelease(isOpen);
    SFRelease(_packing);
    [super dealloc];
}

#pragma mark
#pragma mark  Set Get Methord

-(void)setPacking:(PackingModel *)packing{
    if (_packing) {
        [_packing release];
    }
    _packing = [packing retain];
    //初始化 isOpen
    for (int i=0; i<[self.packing.categoryList count]; i++) {
        PackingCategory *model = [self.packing.categoryList objectAtIndex:i];
        //YES为隐藏 默认第一项展开
        [isOpen setValue:[NSNumber numberWithBool:(i==0)?NO:YES] forKey:model.name];
    }
}

-(PackingModel *)packing{
    return _packing;
}

-(void)setCustomAdd:(PackingCategory *)model{

    if (_customAdd) {
        [_customAdd release];
    }
    _customAdd = [model retain];
    
    //比对并更新界面
    BOOL hasIt = NO;
    for (PackingCategory *category in self.packing.categoryList) {
        //有－－－－合并
        if ([category.name isEqualToString:_customAdd.name]) {
            [category.itemList addObjectsFromArray:_customAdd.itemList];
            hasIt = YES;
        }
    }
    //没有－－－有元素 添加
    if (!hasIt) {
        if ([_customAdd.itemList count] > 0) {
            [self.packing.categoryList addObject:_customAdd];
        }
    }
    
    [_tableView reloadData];
}

-(PackingCategory *)customAdd{
    return _customAdd;
}


-(void)mergerThePackingLibAddData:(NSMutableArray *)array{

    NSMutableArray *need_category = [[NSMutableArray alloc] init];
    for (PackingCategory *add_ in array) {
        
        PackingCategory *old = [self.packing.categoryList containsObjectsWithGivenName:add_];
        if (old) {
            //has
            for (PackingItem *item in add_.itemList) {
                PackingItem *need_add = [old.itemList containsObjectsWithGivenName:item];
                if (!need_add) {
                    [old.itemList addObject:item];
                }
            }
       
        }else{
            //No
            [need_category addObject:add_];
        }

    }
    
    [self.packing.categoryList addObjectsFromArray:need_category];
    [need_category release];
}


-(void)setLib_Add:(NSMutableArray *)lib_Add{

    if (_lib_Add) {
        [_lib_Add release];
    }
    
    _lib_Add = [lib_Add retain];
    
    [self mergerThePackingLibAddData:self.lib_Add];
    
    [_tableView reloadData];
    
    
    //合并从清单库传来的数据（IMP）
    /*
     *将相同的数据项 从新的里面删除 然后将新的加到旧的里面（相同的Category下面的Item 处理方式）
     *没有的Category 直接加到数组
     */
    
    /*
    NSMutableArray *sameCategory = [[NSMutableArray alloc] init];
    
    for (PackingCategory *origin in self.packing.categoryList) {
        for (PackingCategory *new in self.lib_Add) {
            if ([new.name isEqualToString:origin.name]) {
                //合并Category 下面的Item
                NSMutableArray *sameItem = [[NSMutableArray alloc] init];
                for (PackingItem *item_new in new.itemList) {
                    for (PackingItem *item_old in origin.itemList) {
                        if ([item_old.name isEqualToString:item_new.name]) {
                            [sameItem addObject:item_new];
                        }
                    }
                }
                [new.itemList removeObjectsInArray:sameItem];
                [sameItem release];
                [origin.itemList addObjectsFromArray:new.itemList];
                [sameCategory addObject:new];
            }
        }
    }
    [self.lib_Add removeObjectsInArray:sameCategory];
    [sameCategory    release];
    //将重复的合并删除
    [self.packing.categoryList addObjectsFromArray:self.lib_Add];
    [_tableView reloadData];
    */
}
-(NSMutableArray *)lib_Add{
    return _lib_Add;
}

-(void)addNewCategoryList{

    self.isFirstIn = NO;
    AddPackingList *list = [[AddPackingList alloc] initWithTopImagePath:nil andTitle:@"新建清单" style:_NavOnlyBackBtnStyle_];
    [self.navigationController pushViewController:list animated:YES];
    [list release];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    if (self.isFirstIn) {
        //
        //添加引导
        UIControl *control = [[UIControl  alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        control.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"Guide_Packing_Add%d.png",(int)SCREEN_HEIGHT]]];
        [control addTarget:self action:@selector(tapAndRemove:) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].delegate.window addSubview:control];
        [control release];
    }
    
    UIView *v = [self.view viewWithTag:100];
    if ([self.packing.categoryList count] == 0) {
        v.hidden = YES;
    }else{
        v.hidden = NO;
    }
    
}
-(void)tapAndRemove:(UIControl *)control{
    
    [control removeFromSuperview];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(14, 14, 14, 14)];
    [btn setImage:[UIImage imageNamed:@"add_PackingList.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addNewCategoryList) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    

    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, SCREEN_HEIGHT-20-44-45) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    hide_complete = NO;

    //底部栏
    CategoryListBottomBar *bar = [[CategoryListBottomBar alloc] initWithFrame:CGRectMake(0,_tableView.frame.size.height, SCREEN_WIDTH, 45)];
    bar.backgroundColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1];
    bar.delegate = self;
    bar.tag = 100;
    [self.view addSubview:bar];
    [bar release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark BottomBarDelegate

-(void)hideTheCompleteItemOrNot:(BOOL)yes{

    hide_complete = yes;
    [_tableView reloadData];
    
}
-(void)tapTheEditButtonWithStatus:(BOOL)status{

    [_tableView setEditing:status animated:YES];

}


#pragma  mark
#pragma  mark UITableViewDataSource

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    return _tableView.editing;
}

//设置tableview是否可编辑
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //这里是关键：这样写才能实现既能禁止滑动删除Cell，又允许在编辑状态下进行删除
    if (!tableView.editing)
        return UITableViewCellEditingStyleNone;
    else {
        return UITableViewCellEditingStyleDelete;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        PackingCategory *model = [self.packing.categoryList objectAtIndex:indexPath.section] ;
        [model.itemList removeObjectAtIndex:indexPath.row];
        
        if ([model.itemList count] == 0) {
            [self.packing.categoryList removeObjectAtIndex:indexPath.section];
            [tableView deleteSections: [NSIndexSet indexSetWithIndex: indexPath.section] withRowAnimation:UITableViewRowAnimationBottom];
            [_tableView reloadData];
            
        }else{
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return [self.packing.categoryList count];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    PackingCategory *model = [self.packing.categoryList objectAtIndex:section] ;
    BOOL hide = [[isOpen objectForKey:model.name] boolValue];
    
    if (hide) {
        return 0;
    }else{
        if (hide_complete) {
            
            int unCompleted = 0;
            for (PackingItem *item in model.itemList) {
                if (![item.isChecked isEqualToString:@"true"]) {
                    unCompleted += 1;
                }
            }
            return unCompleted;
        }else{
            return [model.itemList count];
        }
        
    }
    
}

-(void)refreshTheTableOnSectionNum{

    [_tableView reloadData];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    CategoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CategoryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier Type:CELL_CategoryList] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        [self addLineOnView:cell WithPositionIsUp:NO];
    }
    PackingCategory *model = [self.packing.categoryList objectAtIndex:indexPath.section] ;
    
    if (hide_complete) {
        
        //重新排列的NSArray
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (PackingItem *item in model.itemList) {
            if (![item.isChecked isEqualToString:@"true"]) {
                [array addObject:item];
            }
        }
        
        [cell bingThePackingModel:[array objectAtIndex:indexPath.row]];
        [array release];
    }else{
        [cell bingThePackingModel:[model.itemList objectAtIndex:indexPath.row]];
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
    UIView *topLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, y, 320.0f, 0.5f)];
    topLineView.backgroundColor = [UIColor colorWithRed:144.0f / 255 green:187.0f / 255 blue:243.0f / 255 alpha:1.0f];
    [view addSubview:topLineView];
    [topLineView release];
}


#pragma  mark
#pragma  mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIButton  *view = [UIButton buttonWithType:UIButtonTypeCustom];
    view.backgroundColor = [UIColor whiteColor];
    [view setFrame:CGRectMake(0, 0, 320, 44)];
    
    //
    PackingCategory *category = [self.packing.categoryList objectAtIndex:section];
    //
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(27, 10, 150, 24)];
    name.backgroundColor = [UIColor clearColor];
    name.adjustsFontSizeToFitWidth = YES;
    name.textColor = RGBACOLOR(52, 52, 52, 1.0);
    name.font = [UIFont systemFontOfSize:16.0f];
    name.text = category.name;
    [view addSubview:name];
    [name release];
    
    UILabel *chected = [[UILabel alloc] initWithFrame:CGRectMake(200, 12, 20, 20)];
    chected.backgroundColor = [UIColor clearColor];
    chected.adjustsFontSizeToFitWidth = YES;
    chected.textColor = RGBACOLOR(254, 88, 88, 1.0);
    chected.font = [UIFont systemFontOfSize:15.0f];
    chected.text = [NSString stringWithFormat:@"%d",[self getTheIsCheck:@"true" WithCategory:category]];
    chected.textAlignment = NSTextAlignmentRight;
    [view addSubview:chected];
    [chected release];
    
    UILabel *total = [[UILabel alloc] initWithFrame:CGRectMake(220, 12, 20, 20)];
    total.backgroundColor = [UIColor clearColor];
    total.adjustsFontSizeToFitWidth = YES;
    total.textColor = RGBACOLOR(153, 153, 153, 1.0);
    total.font = [UIFont systemFontOfSize:15.0f];
    total.text = [NSString stringWithFormat:@"/%d",[self getTheIsCheck:nil WithCategory:category]];
    [view addSubview:total];
    [total release];
    
    //
    UIEdgeInsets insets = UIEdgeInsetsMake(19.5, 291, 19.5, 20);
    [view setImageEdgeInsets:insets];
    
    BOOL yes = [[isOpen objectForKey:category.name] boolValue];
    [view setImage:(yes)? ARROW_DOWN:ARROW_UP forState:UIControlStateNormal];
    [view addTarget:self action:@selector(handleTheTableSection:) forControlEvents:UIControlEventTouchUpInside];
    view.tag = section;
    
    [self addLineOnView:view WithPositionIsUp:NO];

    return view;
}

-(int)getTheIsCheck:(NSString *)aString WithCategory:(PackingCategory *)category{

    if (aString == nil) {
        return [category.itemList count];
    }
    int num = 0;
    for (PackingItem *item in category.itemList) {
        if ([item.isChecked isEqualToString:aString]) {
            num += 1;
        }
    }
    return num;
}


-(void)handleTheTableSection:(UIButton *)sender{
    if ([sender currentImage] == ARROW_DOWN) {
        [sender setImage:ARROW_UP forState:UIControlStateNormal];
    }else{
        [sender setImage:ARROW_DOWN forState:UIControlStateNormal];
    }
    PackingCategory *model = [self.packing.categoryList objectAtIndex:sender.tag];
    BOOL yes = [[isOpen objectForKey:model.name] boolValue];
    [isOpen setValue:[NSNumber numberWithBool:!yes] forKey:model.name];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
}

@end
