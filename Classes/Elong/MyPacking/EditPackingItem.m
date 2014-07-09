//
//  EditPackingItem.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-1-2.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "EditPackingItem.h"
#import "PackingCategory.h"
#import "PackingItem.h"
#import "CTField.h"
#import "PackingDefine.h"

@interface EditPackingItem ()

@end

@implementation EditPackingItem

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //键盘弹起
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisplay:) name:UIKeyboardWillShowNotification
                                                   object:nil];
    }
    return self;
}

-(void)setCategory:(PackingCategory *)category{

    //初始化数据
    if ([category.itemList count] != 0) {
        for (id object in category.itemList) {
            
            if ([object isKindOfClass:[NSDictionary class]]) {
                //
                PackingItem *item = [[PackingItem alloc] init];
                NSArray *keys = [object allKeys];
                for (NSString *key in keys) {
                    if ([object objectForKey:key] != nil) {
                        [item setValue:[object objectForKey:key] forKey:key];
                    }
                }
                self.category.name = category.name;
                [self.category.itemList addObject:item];
                [item release];
            }else{
                //已为实体话对象
                _category = category;
            }
        }
    }else{
        //自定义添加
        _category = category;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SFRelease(_tableView);
    [super dealloc];
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
    
    return [self.category.itemList count]+1;
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
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    if (indexPath.row < [self.category.itemList count]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        PackingItem  *item = [self.category.itemList objectAtIndex:indexPath.row];
        cell.textLabel.text = item.name;
        UIView *v = [cell viewWithTag:100];
        if (v) {
            [v removeFromSuperview];
        }
    }
    if (indexPath.row == [self.category.itemList  count]) {
        UIView *v = [cell viewWithTag:100];
        if (!v) {
            CTField *add = [[CTField alloc] initWithFrame:CGRectMake(0, 0, 320, 43) andType:CT_Setting_edit];
            add.backgroundColor =[UIColor whiteColor];
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
    
    if ([self.category.itemList count] == 0) {
        return NO;
    }else{
        if (indexPath.row == [self.category.itemList count]) {
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
        [self.category.itemList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
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
    
    if ([self.category.itemList count] > 0) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:[self.category.itemList count] inSection:0];
        [_tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [_tableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20-44)];

    
    //保存
    if (STRINGHASVALUE(textField.text)) {
        
        NSString *value = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //检测是否有重复的item
        for (PackingItem *mode  in self.category.itemList) {
            if ([value isEqualToString:mode.name]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已存在,请重新填写" message:nil delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
            }
        }
        PackingItem *new = [[PackingItem alloc] init];
        new.name = value;
        [self.category.itemList addObject:new];
        [new release];
        
        [_tableView reloadData];
    }
    
    textField.text = @"";
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(saveTheModifyCategory:)]) {
        [_delegate saveTheModifyCategory:self.category];
    }
    
}

@end
