//
//  QuickAddList.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-1-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "QuickAddList.h"
#import "CategoryListCell.h"
#import "PackingItem.h"
#import "PackingCategoryList.h"
#import "PackingCategory.h"

@interface QuickAddList ()

@end

@implementation QuickAddList

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc{
    SFRelease(enableItem);
    SFRelease(disenableItem);
    SFRelease(_dataSource);
    SFRelease(_tableView);
    [super dealloc];
}

-(void)doneAndSave{
    
    if (self.navigationItem.rightBarButtonItem ==  disenableItem) {
        return;
    }
    
    if ([self.dataSource count]>0) {
        //取出所勾选的
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (PackingItem *item  in self.dataSource) {
            if ([item.isChecked isEqualToString:@"true"]) {
                [array addObject:item];
                item.isChecked = @"false";//这里是选择，所有需要将属性重置
            }
        }
        
        //NSLog(@"%@",self.navigationController.childViewControllers);
        PackingCategoryList *nav = nil;
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[PackingCategoryList class]]) {
                nav = (PackingCategoryList *)vc;
                break;
            }
        }
        
        PackingCategory *category = [[PackingCategory alloc] init];
        category.name = @"自定义";
        category.itemList = array;
        [array release];
        
        nav.customAdd = category;
        [category release];
        [self.navigationController popToViewController:nav animated:YES];
    }
}

-(void)setTheNavRightItem{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, NAVBAR_WORDBTN_WIDTH, NAVBAR_ITEM_HEIGHT)];
    btn.titleLabel.font = FONT_B15;
    btn.titleLabel.textAlignment = UITextAlignmentRight;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0, -16);
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setTitleColor:RGBACOLOR(153, 153, 153, 1) forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(doneAndSave) forControlEvents:UIControlEventTouchUpInside];
    disenableItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn release];

    
    UIButton *btn_ = [[UIButton alloc] initWithFrame:CGRectMake(0,0, NAVBAR_WORDBTN_WIDTH, NAVBAR_ITEM_HEIGHT)];
    btn_.titleLabel.font = FONT_B15;
    btn_.titleLabel.textAlignment = UITextAlignmentRight;
    btn_.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0, -16);
    [btn_ setTitle:@"确认" forState:UIControlStateNormal];
    [btn_ setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [btn_ setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    [btn_ addTarget:self action:@selector(doneAndSave) forControlEvents:UIControlEventTouchUpInside];
    enableItem = [[UIBarButtonItem alloc] initWithCustomView:btn_];
    [btn_ release];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTheNavRightItem];
    
    if (disenableItem) {
        self.navigationItem.rightBarButtonItem = disenableItem;
    }

    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0,5, self.view.frame.size.width, SCREEN_HEIGHT-20-44-5) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark
#pragma  mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1+[self.dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"QuickAddListCell";
    CategoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CategoryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier Type:CELL_QuickAdd] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            [self addLineOnView:cell WithPositionIsUp:YES];
        }
        [self addLineOnView:cell WithPositionIsUp:NO];
        
    }
    
    if (indexPath.row == 0) {
        UIView *v = [cell viewWithTag:100];
        if (v) {
            [v removeFromSuperview];
        }
        //这个始终是 添加项
        [cell addSubview:[self createTheAddField]];
        
    }else{
    
        NSArray *display = [[self.dataSource reverseObjectEnumerator] allObjects];
        
        [cell bingThePackingModel:[display objectAtIndex:indexPath.row-1]];
        
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
    [view addSubview:[UIImageView dashedHalfLineWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 1.0f)]];
}


-(UIView *)createTheAddField{
    
    //320 * 44
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 22, 22)];
    image.image = [UIImage imageNamed:@"add_new_customer.png"];
    [view addSubview:image];
    [image release];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(42, 13, 260, 20)];
    textField.placeholder = @"新建一项";
    textField.font = [UIFont systemFontOfSize:15.0f];
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    [view addSubview:textField];
    [textField release];
    
    view.tag = 100;
    
    return [view autorelease];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    if ([self.dataSource count] > 0) {
        self.navigationItem.rightBarButtonItem = enableItem;
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{

    if (STRINGHASVALUE(textField.text)) {
        //
        //检测数据的唯一性
        NSString *valueString = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        for (PackingItem *model in self.dataSource) {
            if ([model.name isEqualToString:valueString]) {
                //有重复项
                [Utils alert:@"已有此项内容,请重新输入!"];
                return;
            }
        }
        
        PackingItem *item = [[PackingItem alloc] init];
        item.name = textField.text;
        item.isChecked = @"true";
        [self.dataSource addObject:item];
        [item release];
        
        [_tableView reloadData];
        
    }
    
    textField.text = @"";
    [textField resignFirstResponder];
    
    /*
     else{
     
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入的格式不正确" message:nil delegate:nil
     cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil, nil];
     [alert show];
     [alert release];
     }
     */
    
}

@end
