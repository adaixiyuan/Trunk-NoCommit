//
//  PackingLib.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-1-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "PackingLib.h"
#import "PackingDefine.h"
#import "PackingCategory.h"
#import "PackingItem.h"
#import "PackingLibRightCell.h"
#import "PackingCategoryList.h"
#import "CTField.h"

#define LEFT_WIDTH     97
#define RIGHT_WIDTH   320-LEFT_WIDTH

@interface PackingLib ()

@end

@implementation PackingLib

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataSource = [[NSMutableArray alloc] init];
        
        //键盘弹起
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisplay:) name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [self readingPackingLibraryFromUserDefault];
    }
    return self;
}

-(void)readingPackingLibraryFromUserDefault{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:PACKING_LIB_MODIFY];
    if (data == NULL) {
        NSLog(@"读取清单库 出现错误!");
        return;
    }
    
    self.dataSource = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //
    allChoose_Dic = [[NSMutableDictionary alloc] init];
    for (PackingCategory *model in self.dataSource) {
        [allChoose_Dic setValue:[NSNumber numberWithBool:NO] forKey:model.name];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SFRelease(allChoose_Dic);
    SFRelease(_dataSource);
    SFRelease(_leftTable);
    SFRelease(_rightTable);
    [super dealloc];
}

-(void)doneAndSave{
    //检测数据 过滤数据!
    NSLog(@"It's Time to check The Data and Up the self.dataSource");
    
    NSMutableArray *target = [[NSMutableArray alloc] init];
    for (PackingCategory *model in self.dataSource) {
        NSMutableArray *selectedItems = [[NSMutableArray alloc] init];
        for (PackingItem *item in model.itemList) {
            if ([item.isChecked isEqualToString:@"true"]) {
                [selectedItems addObject:item];
            }
        }
        if ([selectedItems count] > 0) {
            [model.itemList removeAllObjects];
            [model.itemList addObjectsFromArray:selectedItems];
            [target addObject:model];
        }
        [selectedItems release];
    }
    
    //过滤完数据 重置check
    
    for (PackingCategory *model in target) {
        for (PackingItem *item in model.itemList) {
            item.isChecked = @"false";
        }
    }
    

    PackingCategoryList *nav = nil;
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[PackingCategoryList class]]) {
            nav = (PackingCategoryList *)vc;
            break;
        }
    }
    
    nav.lib_Add = target;//合并数据
    [target release];
    
    [self.navigationController popToViewController:nav animated:YES];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"确认" Target:self Action:@selector(doneAndSave)];
    
    //
    _leftTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LEFT_WIDTH, SCREEN_HEIGHT-20-44) style:UITableViewStylePlain];
    _leftTable.delegate = self;
    _leftTable.dataSource = self;
    _leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTable.scrollIndicatorInsets = UIEdgeInsetsMake(0,0, 0,-15);
    UIImage *backImage = [[UIImage imageNamed:@"gradualLine.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _leftTable.bounds.size.width, _leftTable.bounds.size.height)];
    back.image = backImage;
    _leftTable.backgroundView = back;
    [back release];
    [self.view addSubview:_leftTable];
    
    _rightTable = [[UITableView alloc] initWithFrame:CGRectMake(LEFT_WIDTH, 0, RIGHT_WIDTH, SCREEN_HEIGHT-20-44) style:UITableViewStylePlain];
    _rightTable.delegate = self;
    _rightTable.dataSource = self;
    _rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_rightTable];
    selected_Index = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _leftTable) {
        return [self.dataSource count];
    }else if (tableView ==  _rightTable){
        PackingCategory *category = [self.dataSource objectAtIndex:selected_Index];
        return ([category.itemList count] == 0)?1:[category.itemList count]+2;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == _leftTable) {
        
        static NSString *CellIdentifier = @"LEFT_CELL";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.backgroundColor = [UIColor clearColor];

            UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0,1.5, LEFT_WIDTH, 41)];
            view.image = [UIImage imageNamed:@"Lib_Left_Selected.png"];
            view.backgroundColor = [UIColor clearColor];
            view.tag = 100;
            view.hidden = YES;
            [cell.contentView addSubview:view];
            [view release];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            
            //画线
            if (indexPath.row == 0) {
                [self addLineOnView:cell WithPositionIsUp:YES andIsLeft:YES];
            }
            [self addLineOnView:cell WithPositionIsUp:NO andIsLeft:YES];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        //Confige the Cell
        
        if (indexPath.row == selected_Index) {
            //
            UIView *v = [cell.contentView viewWithTag:100];
            v.hidden = NO;
        }else{
            UIView *v = [cell.contentView viewWithTag:100];
            v.hidden = YES;
        }
        
        PackingCategory *model = [self.dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
        
    }
    else if (tableView == _rightTable)
    {
        static NSString *CellIdentifier = @"RIGHT_CELL";
        PackingLibRightCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[PackingLibRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            
            if (indexPath.row == 0) {
                [self addLineOnView:cell WithPositionIsUp:YES andIsLeft:NO];
            }
            [self addLineOnView:cell WithPositionIsUp:NO andIsLeft:NO];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        //Confige the Cell
        PackingCategory *category = [self.dataSource objectAtIndex:selected_Index];
        if(indexPath.row == 0){
            if ([category.itemList count] == 0) {
                //显示 新加一项
                UIView *v = [cell viewWithTag:100];
                if (!v) {
                    [cell addSubview:[self createTheAddField]];
                }
               
            }else{
                //显示 全选按钮
                UIView *v = [cell viewWithTag:100];
                if (v) {
                    [v removeFromSuperview];
                }
                [cell setTheFirstCellOfAllSelected:[[allChoose_Dic objectForKey:category.name] boolValue]];
            }
        }else{
            if (indexPath.row != [category.itemList count]+1 ) {
                UIView *v = [cell viewWithTag:100];
                if (v) {
                    [v removeFromSuperview];
                }
                [cell bingThePackingModel:[category.itemList objectAtIndex:indexPath.row-1]];
            }else{
                //显示 新加一项
                UIView *v = [cell viewWithTag:100];
                if (!v) {
                    [cell addSubview:[self createTheAddField]];
                }
            }
        }
        return cell;
    }
    return nil;
}

-(void)addLineOnView:(UIView *)view WithPositionIsUp:(BOOL)isUp andIsLeft:(BOOL)left{
    
    float y;
    if (isUp) {
        y = CGRectGetMinY(view.frame);
    }else{
        y = CGRectGetMaxY(view.frame)-0.5f;
    }
    UIView *topLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, y, 320.0f, 0.5f)];
    if (left) {
        topLineView.backgroundColor = [UIColor whiteColor];
    }else{
        topLineView.backgroundColor = [UIColor colorWithRed:188.0f / 255 green:188.0f / 255 blue:188.0f / 255 alpha:1.0f];
    }
    [view addSubview:topLineView];
    [topLineView release];
}

-(UIView *)createTheAddField{

    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
    image.image = [UIImage imageNamed:@"add_blue.png"];
    CTField *textField = [[CTField alloc] initWithFrame:CGRectMake(0, 0, RIGHT_WIDTH, 43) andType:CT_PackingLib_edit];
    textField.placeholder = @"新建一项";
    textField.backgroundColor = [UIColor whiteColor];
    textField.font = [UIFont systemFontOfSize:15.0f];
    textField.delegate = self;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = image;
    textField.returnKeyType = UIReturnKeyDone;
    textField.tag = 100;
    [image release];
    return [textField autorelease];
}

#pragma mark
#pragma mark UITextFieldDelegate


-(void)keyboardWillDisplay:(NSNotification *)aNotification{
    
    NSDictionary* info = [aNotification userInfo];
    
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //键盘的大小
    CGSize keyboardRect = [aValue CGRectValue].size;
    
    CGFloat height = keyboardRect.height;
    
    [_rightTable setFrame:CGRectMake(LEFT_WIDTH, 0, RIGHT_WIDTH, SCREEN_HEIGHT-20-44-height)];
    
    PackingCategory *category = [self.dataSource objectAtIndex:selected_Index];
    if ([category.itemList count] > 0) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:[category.itemList count]+1 inSection:0];
        [_rightTable scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (STRINGHASVALUE(textField.text)) {
        //
        PackingCategory *current = [self.dataSource objectAtIndex:selected_Index];

        //检测数据的唯一性
        NSString *valueString = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        for (PackingItem *model in current.itemList) {
            if ([model.name isEqualToString:valueString]) {
                //有重复项
                [Utils alert:@"已有此项内容,请重新输入!"];
                return;
            }
        }
        self.itemName = textField.text;
        PackingItem *item = [[PackingItem alloc] init];
        item.name = textField.text;
        item.isChecked = @"true";
        [current.itemList addObject:item];
        [item release];
        [_rightTable reloadData];
    }
    textField.text = @"";
    [textField resignFirstResponder];
    [_rightTable setFrame:CGRectMake(LEFT_WIDTH, 0, RIGHT_WIDTH, SCREEN_HEIGHT-20-44)];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    return YES;
}



#pragma mark
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == _leftTable) {
        selected_Index = indexPath.row;
        [_leftTable reloadData];
        [_rightTable reloadData];
    }else{
        //右侧点选//To do Nothing !
    }
}

-(void)chooseAllThePackingItemsOrNot:(BOOL)yes{
    PackingCategory *category = [self.dataSource objectAtIndex:selected_Index];
    
    [allChoose_Dic setValue:[NSNumber numberWithBool:yes] forKey:category.name];;
    
    if ([category.itemList count] > 0) {
        //只有这种case下 才有点选的需要
            //点击的是 全选按钮
            if (yes) {
                //全选
                for (PackingItem *item in category.itemList) {
                    item.isChecked = @"true";
                }
            }else{
                //全不选
                for (PackingItem *item in category.itemList) {
                    item.isChecked = @"false";
                }
        }
        [_rightTable     reloadData];
    }
}



@end
