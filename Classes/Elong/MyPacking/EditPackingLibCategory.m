//
//  EditPackingLibCategory.m
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-31.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "EditPackingLibCategory.h"
#import "PackingCategory.h"
#import "PackingItem.h"
#import "PackingDefine.h"
#import "EditPackingItem.h"
#import "CTField.h"

@interface EditPackingLibCategory ()

@end

@implementation EditPackingLibCategory

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataSource = [[NSMutableArray alloc] init];
        [self readingDataFromUserStorge];

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //键盘弹起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisplay:) name:UIKeyboardWillShowNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //保存数据源
    if (self.dataSource) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.dataSource];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:PACKING_LIB_MODIFY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)dealloc{
    SFRelease(_dataSource);
    SFRelease(_tableView);
    [super dealloc];
}

-(void)readingDataFromUserStorge{

    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:PACKING_LIB_MODIFY];
    if (data == NULL) {
        NSLog(@"plist 文件 读取错误");
        }
        //缓存中读取
        self.dataSource = [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

-(void)setEditStatus:(UIButton *)sender{
    edited = !edited;
    [_tableView setEditing:edited animated:YES];
    if (edited) {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    edited = NO;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"编辑" Target:self Action:@selector(setEditStatus:)];
    
    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, SCREEN_HEIGHT-20-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    header.backgroundColor = PACKING_BACKCOLOR;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 260, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"关闭添加清单时您不希望看到的预设项";
    label.textColor = RGBACOLOR(153, 153, 153, 1);
    label.adjustsFontSizeToFitWidth = YES;
    [header addSubview:label];
    [label release];
    
    [self addLineOnView:header  WithPositionIsUp:NO];
    
    _tableView.tableHeaderView = header;
    [header release];
}


#pragma  mark
#pragma  mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSource count]+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

        [self addLineOnView:cell WithPositionIsUp:NO];
        
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row < [self.dataSource count]) {
        UIView *v = [cell viewWithTag:100];
        if (v) {
            [v removeFromSuperview];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        PackingCategory *category = [self.dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = category.name;
    }
    
    if (indexPath.row == [self.dataSource count]) {

        UIView *v = [cell viewWithTag:100];
        if (!v) {
            CTField *add = [[CTField alloc] initWithFrame:CGRectMake(0, 0, 320, 43) andType:CT_Setting_edit];
            add.backgroundColor = [UIColor whiteColor];
            add.leftViewMode = UITextFieldViewModeAlways;
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_blue.png"]];
            [image setFrame:CGRectMake(0,0, 13, 13)];
            add.leftView = image;
            add.leftViewMode = UITextFieldViewModeAlways;
            add.delegate = self;
            add.returnKeyType = UIReturnKeyDone;
            add.tag = 100;
            [image release];
            add.placeholder = @" 新建一项";
            [cell addSubview:add];
            [add release];
            
        }
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
    topLineView.backgroundColor = [UIColor colorWithRed:188.0f / 255 green:188.0f / 255 blue:188.0f / 255 alpha:1.0f];
    [view addSubview:topLineView];
    [topLineView release];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.dataSource count] == 0) {
        return NO;
    }else{
        if (indexPath.row == [self.dataSource count]) {
            return NO;
        }
    }
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (edited) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row < [self.dataSource count]) {
        //
        PackingCategory *category = [self.dataSource objectAtIndex:indexPath.row];
        EditPackingItem *item = [[EditPackingItem alloc] initWithTopImagePath:nil andTitle:category.name style:_NavOnlyBackBtnStyle_];
        item.category = category;
        item.delegate = self;
        [self.navigationController pushViewController:item animated:YES];
        [item release];
    }
    
}

-(void)saveTheModifyCategory:(PackingCategory *)model{

    for (PackingCategory *category in self.dataSource) {
        if ([category.name isEqualToString:model.name]) {
            int index = [self.dataSource indexOfObject:category];
            [self.dataSource replaceObjectAtIndex:index withObject:model];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark
#pragma mark UITextFieldDelegate

-(void)keyboardWillDisplay:(NSNotification *)aNotification{

    NSDictionary* info = [aNotification userInfo];
    
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //键盘的大小
    CGSize keyboardRect = [aValue CGRectValue].size;
    
    CGFloat height = keyboardRect.height;
    
    [_tableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20-44-height)];
    
    if ([self.dataSource count] > 0) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:[self.dataSource count] inSection:0];
        [_tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [_tableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20-44)];

    
    //保存
    if (STRINGHASVALUE(textField.text)) {
        
        NSString *value = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //检测是否有重复的Category
        for (PackingCategory *mode  in self.dataSource) {
            if ([value isEqualToString:mode.name]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已存在,请重新填写" message:nil delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
            }
        }
        PackingCategory *new = [[PackingCategory alloc] init];
        new.name = value;
        [self.dataSource addObject:new];
        [new release];
        
        [_tableView reloadData];
    }
    
    textField.text = @"";
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}


@end
