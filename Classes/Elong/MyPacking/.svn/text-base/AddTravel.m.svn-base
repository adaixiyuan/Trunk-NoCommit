//
//  AddTravel.m
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-31.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "AddTravel.h"
#import "AddPackingList.h"
#import "SelecteColor.h"
#import "PackingModel.h"
#import "PackingDefine.h"
#import "MyPackingList.h"

@interface AddTravel ()

@end

@implementation AddTravel

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _color = @"红色";
        _type = @"空白清单";
        _categoryList = [[NSMutableArray alloc] init];
        
        [self readDefaultData];
    }
    return self;
}

-(void)dealloc{
    
    [_colorIndex release];
    [_dataSource release];
    [_categoryList release];
    [_color release];
    [_type release];
    [nameField release];
    [_tableView release];
    [_templateType release];
    [super dealloc];
}

-(void)setTemplateType:(NSMutableArray *)aTempateType{

    if (_templateType) {
        [_templateType release];
    }
    _templateType = [aTempateType retain];
}

-(NSMutableArray *)templateType{

    return _templateType;
}


-(void)readDefaultData{

    NSData *offical = [[NSUserDefaults standardUserDefaults] objectForKey:PACKING_TEMPLATE];
    if (offical == NULL) {
        NSLog(@"添加行程页面－－数据错误-----");
        return;
    }
    self.templateType = [NSKeyedUnarchiver unarchiveObjectWithData:offical];
}

-(BOOL)checkTheTravelNameIsExist:(NSString *)name{

    for (PackingModel*model in self.dataSource) {
        if ([model.name isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}

-(void)back{
    
    MyPackingList *nav = nil;
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[MyPackingList class]]) {
            nav = (MyPackingList *)vc;
            break;
        }
    }
    nav.scrollowTop = YES;
    [self.navigationController popToViewController:nav animated:YES];
}


-(void)doneAndSave{

    if (STRINGHASVALUE(nameField.text)) {
        
        if (![self checkTheTravelNameIsExist:nameField.text]) {
            //创建新的Travel
            PackingModel *model = [[PackingModel alloc] init];
            model.name = nameField.text;
            model.color = self.colorIndex;
            model.categoryList = _categoryList;
            [self.dataSource addObject:model];
            [model release];
            
            //检测是否是第一个用户所建的行程，以便提供用户引导
            NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"FIRST_CREATE_TRAVEL"];
            if (!string) {
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"FIRST_CREATE_TRAVEL"];
            }
        
            [self back];
        }else{
            
            [Utils alert:@"您输入的行程名称已经存在,请重新输入"];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未输入行程名称" message:nil delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"确定" Target:self Action:@selector(doneAndSave)];

    
    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0,10, self.view.frame.size.width, SCREEN_HEIGHT-20-44-10) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
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
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
        if (indexPath.row == 0) {
            [self addLineOnView:cell WithPositionIsUp:YES];
        }
        [self addLineOnView:cell WithPositionIsUp:NO];
        
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    

        switch (indexPath.row) {
            case 0:
                //
                cell.textLabel.text = @"行程名称";
                [cell.contentView addSubview:[self createTheInputField]];
                break;
            case 1:
                cell.textLabel.text = @"清单类型";
                cell.detailTextLabel.text = self.type;
                cell.detailTextLabel.textColor = RGBACOLOR(153, 153, 153, 1);
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 2:
                cell.textLabel.text = @"颜色";
                cell.detailTextLabel.text = self.color;
                
                switch ([self.colorIndex intValue]) {
                    case 0:
                        cell.detailTextLabel.textColor = PACKING_RED;
                        break;
                    case 1:
                        cell.detailTextLabel.textColor = PACKING_ORANGE;
                        break;
                     case 2:
                        cell.detailTextLabel.textColor = PACKING_GREEN;
                        break;
                      case 3:
                        cell.detailTextLabel.textColor = PACKING_BLUE;
                        break;
                    case 4:
                        cell.detailTextLabel.textColor = PACKING_GRAY;
                        break;
                    default:
                        break;
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }
    return cell;
}

-(UIView *)createTheInputField{
    
    if (!nameField) {
        nameField = [[UITextField alloc] initWithFrame:CGRectMake(120, 10, 170, 30)];
        nameField.delegate = self;
        nameField.placeholder = @"请填写您的行程";
        nameField.textAlignment = NSTextAlignmentRight;
        
    }
    return nameField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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

#pragma  mark
#pragma  mark  UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.row == 1) {
        
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        [titles addObject:@"空白清单"];
        
        int selected = 0;
        for (PackingModel *model in self.templateType) {
            [titles addObject:model.name];
            if ([model.name isEqualToString:self.type]) {
                selected = [self.templateType indexOfObject:model]+1;
            }
        }
        
        SelecteColor *color = [[SelecteColor alloc] initWithDefaultColor:selected delegate:self titles:titles Type:List_Type];
        [titles release];
        
        UINavigationController *nav = [[UINavigationController    alloc] initWithRootViewController:color];
        if (IOSVersion_7) {
            nav.transitioningDelegate = [ModalAnimationContainer shared];
            nav.modalPresentationStyle = UIModalPresentationCustom;
        }
        if (IOSVersion_7) {
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            [self presentModalViewController:nav animated:YES];
        }
        [color release];
        [nav release];
        
        
    }else if (indexPath.row == 2){
        NSArray *array = [NSArray arrayWithObjects:@"红色",@"橙色",@"绿色",@"蓝色",@"紫色",nil];
        
        SelecteColor *color = [[SelecteColor alloc] initWithDefaultColor:[self.colorIndex intValue] delegate:self titles:array Type:List_Color];
        UINavigationController *nav = [[UINavigationController    alloc] initWithRootViewController:color];
        if (IOSVersion_7) {
            nav.transitioningDelegate = [ModalAnimationContainer shared];
            nav.modalPresentationStyle = UIModalPresentationCustom;
        }
        if (IOSVersion_7) {
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            [self presentModalViewController:nav animated:YES];
        }
        [color release];
        [nav release];
    }
}

-(void)getTheSelectedColor:(NSString *)color{

  //  NSLog(@"selectedColor is %d",[color intValue]);
    
    self.colorIndex = color;
    switch ([color intValue]) {
        case 0:
            self.color = @"红色";
            break;
         case 1:
            self.color = @"橙色";
            break;
         case 2:
            self.color = @"绿色";
            break;
         case 3:
            self.color = @"蓝色";
            break;
           case 4:
            self.color = @"紫色";
            break;
        default:
            break;
    }
    [_tableView reloadData];
}

-(void)getTheSelectedType:(NSString *)aType{

   // NSLog(@"selectedType is %@",aType);
    self.type = aType;
    if ([_categoryList count] != 0) {
        [_categoryList removeAllObjects];
    }
    
    for (PackingModel *model in self.templateType) {
            if ([model.name isEqualToString:aType]) {
                [_categoryList addObjectsFromArray:model.categoryList];
        }
    }
    
    [_tableView reloadData];

}

@end
