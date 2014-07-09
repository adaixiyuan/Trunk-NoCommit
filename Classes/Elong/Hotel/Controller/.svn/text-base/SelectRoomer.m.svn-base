//
//  SelectRoomer.m
//  ElongClient
//
//  Created by dengfang on 11-1-28.
//  Copyright 2011 shoujimobile. All rights reserved.
//
#import "SelectRoomer.h"
#import "SelectRoomerEditCell.h"
#import "StringFormat.h"

static NSMutableArray *allRoomers = nil;

@implementation SelectRoomer
@synthesize delegate;


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    ReceiveMeomoryWraning = YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    
    
    
    if (smallLoading) {
        [smallLoading release];
    }
    // 终止加载联系人
    [getRoomerUtil cancel];
    SFRelease(getRoomerUtil);
    
    [selectedPeopleIndexArray release];
	
    [super dealloc];
}


+ (NSMutableArray *)allRoomers  {
	
	@synchronized(self) {
		if(!allRoomers) {
			allRoomers = [[NSMutableArray alloc] init];
		}
	}
	return allRoomers;
}

- (void)back{
    
    [super back];
}

- (void) clickCancel{
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)clickConfirm{
    BOOL haveSelected = NO;
    for (NSDictionary *dict in allRoomers) {
        if ([[dict safeObjectForKey:@"Checked"] boolValue]) {
            haveSelected = YES;
        }
    }
    if (!haveSelected) {
        [PublicMethods showAlertTitle:@"您尚未选择入住人" Message:nil];
        return;
    }
    
    NSInteger count = 0;
    BOOL canBack = YES;
    for (NSMutableDictionary *dict in allRoomers) {
        if ([[dict safeObjectForKey:@"Checked"] boolValue]) {
            if (count>=roomCount) {
                [Utils alert:@"每间房只需选择一位入住人"];
                canBack = NO;
                break;
            }else{
                count++;
            }
        }
    }
    
    if (canBack) {
        if ([delegate respondsToSelector:@selector(selectRoomer:didSelectedArray:)]) {
            [delegate selectRoomer:self didSelectedArray:[SelectRoomer allRoomers]];
        }
        
        if (IOSVersion_7) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    
}



-(void)addFooterView{
	UIView  *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 80)];
    
	// 确定按钮
	UIButton *filterBtn = [UIButton yellowWhitebuttonWithTitle:@"确定" Target:self Action:@selector(clickConfirm) Frame:CGRectMake(20, -20 + 80 - 32, SCREEN_WIDTH - 40, 44)];
	[footerView addSubview:filterBtn];
	
	roomList.tableFooterView = footerView;
	[footerView release];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
    
    
    if (UMENG) {
        // 酒店订单流程中常用旅客信息页面
        [MobClick event:Event_HotelOrder_CustomerList];
    }
}


- (void)setTingAll:(BOOL)requested roomCount:(NSInteger)count  tip:(NSString  *) tip andType:(int)type
{
    if (type == 0) {
        self.selectType = SELECTRENT;
    }else if (type == 1){
        self.selectType = SELECT_SCENICTICKETS;
    }
    self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)] autorelease];
    self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    
    peopleCount = 0;
    
    // 如果已有入住人时，加上房间显示
    selectedPeopleIndexArray = [[NSMutableArray alloc] initWithCapacity:2];
    if ([[SelectRoomer allRoomers] count])
    {
        for (NSDictionary *dic in [SelectRoomer allRoomers])
        {
            if ([[dic safeObjectForKey:@"Checked"] safeBoolValue])
            {
                NSInteger index = [[SelectRoomer allRoomers] indexOfObject:dic];
                [selectedPeopleIndexArray addObject:[NSNumber numberWithInt:index]];
            }
        }
    }
    
    // 列表
    roomList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 20 - 50) style:UITableViewStylePlain];
    roomList.delegate = self;
    roomList.dataSource = self;
    [self.view addSubview:roomList];
    [roomList release];
    roomList.backgroundColor = [UIColor clearColor];
    roomList.backgroundView = nil;
    roomList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    roomList.separatorColor = [UIColor clearColor];
    roomList.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)] autorelease];
    // 列表头部
    UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 12, 40)];
    tips.font = [UIFont systemFontOfSize:12.0f];
    tips.backgroundColor = [UIColor clearColor];
    tips.numberOfLines = 3;
    tips.lineBreakMode = UILineBreakModeCharacterWrap;
    tips.textColor = [UIColor colorWithRed:118.0f/255.0f green:118.0f/255.0f blue:118.0f/255.0f alpha:1];
    tips.text =tip;
    [roomList.tableHeaderView addSubview:tips];
    [tips release];
    
    
    //[self addFooterView];
    
    // 确定按钮
    //self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"确定" Target:self Action:@selector(clickConfirm)];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"取消" Target:self Action:@selector(clickCancel)];
    
    
    // 加载符
    smallLoading = [[SmallLoadingView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50)/2, (self.view.frame.size.height-50) / 2, 50, 50)];
    [self.view addSubview:smallLoading];
    
    
    ReceiveMeomoryWraning = NO;
    
    roomCount = count;
    
    if(!requested){
        [self requestForRoomer];
        // 加载符
        [smallLoading startLoading];
    }else{
        NSInteger count = 0;
        for (NSMutableDictionary *dict in allRoomers) {
            if ([[dict safeObjectForKey:@"Checked"] boolValue]) {
                if (count>=roomCount) {
                    [dict safeSetObject:[NSNumber numberWithBool:NO] forKey:@"Checked"];
                }else{
                    count++;
                }
            }
        }
        
    }
    
    // 确定按钮
    UIView *confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 50, SCREEN_WIDTH, 50)];
    confirmView.backgroundColor = RGBACOLOR(62, 62, 62, 1);
    [self.view addSubview:confirmView];
    [confirmView release];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(SCREEN_WIDTH/2, 7, SCREEN_WIDTH/2 - 10, 50 - 14);
    [confirmBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_normal.png"] forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_press.png"] forState:UIControlStateHighlighted];
    [confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
    [confirmView addSubview:confirmBtn];
    
    tips0 = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, SCREEN_WIDTH - 125 - 20, 30)];
    tips0.font = [UIFont boldSystemFontOfSize:14.0f];
    tips0.textColor = [UIColor whiteColor];
    
    tips0.text = (self.selectType == SELECTRENT)?@"还需选择       乘车人":@"还需选择       购票人";
    [confirmView addSubview:tips0];
    tips0.backgroundColor = [UIColor clearColor];
    [tips0 release];
    
    remainLbl = [[UILabel alloc] initWithFrame:CGRectMake(65, 2, 30, 30)];
    remainLbl.font = [UIFont boldSystemFontOfSize:14.0f];
    remainLbl.textAlignment = UITextAlignmentCenter;
    remainLbl.textColor = RGBACOLOR(245, 113, 25, 1);
    [confirmView addSubview:remainLbl];
    [remainLbl release];
    remainLbl.text = @"1位";
    remainLbl.backgroundColor = [UIColor clearColor];
    
    UILabel *tips1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 24, SCREEN_WIDTH - 125 - 20 , 20)];
    tips1.font =  [UIFont systemFontOfSize:11.0f];
    tips1.textColor = [UIColor whiteColor];
    tips1.text = (self.selectType == SELECTRENT)?@"每辆车只需选择一位乘车人":@"每张票只能选择一位购票人";//
    tips1.backgroundColor = [UIColor clearColor];
    [confirmView addSubview:tips1];
    [tips1 release];
    
    [self uploadRemain];
}

- (id) initWithRequested:(BOOL)requested roomCount:(NSInteger)count{
    if (self = [super init]) {
        if (self=[super initWithTopImagePath:nil andTitle:_string(@"s_selectroomer") style:_NavOnlyBackBtnStyle_]) {
            self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)] autorelease];
            self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
            
            peopleCount = 0;
            
            // 如果已有入住人时，加上房间显示
            selectedPeopleIndexArray = [[NSMutableArray alloc] initWithCapacity:2];
            if ([[SelectRoomer allRoomers] count])
            {
                for (NSDictionary *dic in [SelectRoomer allRoomers])
                {
                    if ([[dic safeObjectForKey:@"Checked"] safeBoolValue])
                    {
                        NSInteger index = [[SelectRoomer allRoomers] indexOfObject:dic];
                        [selectedPeopleIndexArray addObject:[NSNumber numberWithInt:index]];
                    }
                }
            }
            
            // 列表
            roomList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 20 - 50) style:UITableViewStylePlain];
            roomList.delegate = self;
            roomList.dataSource = self;
            [self.view addSubview:roomList];
            [roomList release];
            roomList.backgroundColor = [UIColor clearColor];
            roomList.backgroundView = nil;
            roomList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            roomList.separatorColor = [UIColor clearColor];
            roomList.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)] autorelease];
            // 列表头部
            UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 12, 40)];
            tips.font = [UIFont systemFontOfSize:12.0f];
            tips.backgroundColor = [UIColor clearColor];
            tips.numberOfLines = 3;
            tips.lineBreakMode = UILineBreakModeCharacterWrap;
            tips.textColor = [UIColor colorWithRed:118.0f/255.0f green:118.0f/255.0f blue:118.0f/255.0f alpha:1];
            tips.text = @"请选择真实入住人，以保证后续正确审核、返现";
            [roomList.tableHeaderView addSubview:tips];
            [tips release];
            
            
            //[self addFooterView];
            
            // 确定按钮
            //self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"确定" Target:self Action:@selector(clickConfirm)];
            
            self.navigationItem.hidesBackButton = YES;
            
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"取消" Target:self Action:@selector(clickCancel)];
            
            
            // 加载符
            smallLoading = [[SmallLoadingView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 50)/2, (self.view.frame.size.height-50) / 2, 50, 50)];
            [self.view addSubview:smallLoading];
            
            
            ReceiveMeomoryWraning = NO;
            
            roomCount = count;
            
            if(!requested){
                [self requestForRoomer];
                // 加载符
                [smallLoading startLoading];
            }else{
                NSInteger count = 0;
                for (NSMutableDictionary *dict in allRoomers) {
                    if ([[dict safeObjectForKey:@"Checked"] boolValue]) {
                        if (count>=roomCount) {
                            [dict safeSetObject:[NSNumber numberWithBool:NO] forKey:@"Checked"];
                        }else{
                            count++;
                        }
                    }
                }
                
            }
            
            // 确定按钮
            UIView *confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 50, SCREEN_WIDTH, 50)];
            confirmView.backgroundColor = RGBACOLOR(62, 62, 62, 1);
            [self.view addSubview:confirmView];
            [confirmView release];
            
            UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            confirmBtn.frame = CGRectMake(SCREEN_WIDTH/2, 7, SCREEN_WIDTH/2 - 10, 50 - 14);
            [confirmBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_normal.png"] forState:UIControlStateNormal];
            [confirmBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_press.png"] forState:UIControlStateHighlighted];
            [confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
            [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
            [confirmBtn addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
            [confirmView addSubview:confirmBtn];
            
            tips0 = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, SCREEN_WIDTH - 125 - 20, 30)];
            tips0.font = [UIFont boldSystemFontOfSize:14.0f];
            tips0.textColor = [UIColor whiteColor];
            tips0.text = @"还需选择       入住人";
            [confirmView addSubview:tips0];
            tips0.backgroundColor = [UIColor clearColor];
            [tips0 release];
            
            remainLbl = [[UILabel alloc] initWithFrame:CGRectMake(65, 2, 30, 30)];
            remainLbl.font = [UIFont boldSystemFontOfSize:14.0f];
            remainLbl.textAlignment = UITextAlignmentCenter;
            remainLbl.textColor = RGBACOLOR(245, 113, 25, 1);
            [confirmView addSubview:remainLbl];
            [remainLbl release];
            remainLbl.text = @"1位";
            remainLbl.backgroundColor = [UIColor clearColor];
            
            UILabel *tips1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 24, SCREEN_WIDTH - 125 - 20 , 20)];
            tips1.font =  [UIFont systemFontOfSize:11.0f];
            tips1.textColor = [UIColor whiteColor];
            tips1.text = @"每间房只需选择一位入住人";
            tips1.backgroundColor = [UIColor clearColor];
            [confirmView addSubview:tips1];
            [tips1 release];
            
            [self uploadRemain];
            
        }
        
        return self;
    }
    return self;
}

// 请求联系人信息
- (void)requestForRoomer {
    JCustomer *customer = [MyElongPostManager customer];
    [customer clearBuildData];
    [customer setCustomerType:3];
    
    getRoomerUtil = [[HttpUtil alloc] init];
    [getRoomerUtil connectWithURLString:MYELONG_SEARCH
                                Content:[customer requesString:NO]
                           StartLoading:NO
                             EndLoading:NO
                             AutoReload:YES
                               Delegate:self];
}


#pragma mark -
#pragma mark 保存
-(NSString *)checkName:(NSString *)name_{
    NSString *name = [name_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([StringFormat isContainedNumber:name] ||
		[StringFormat isContainedIllegalChar:name]){
		return @"请输入正确的姓名";
	}else if ([name length] == 0) {
		return @"请输入姓名";
	}else if (![[NSPredicate predicateWithFormat:@"SELF MATCHES '[/a-zA-Z\u4e00-\u9fa5\\\\s]{1,50}'"] evaluateWithObject:name]) {
        return @"请输入正确的姓名";
    }
    
    NSMutableArray *roomerArray = [SelectRoomer allRoomers];
    for (NSDictionary *dict in roomerArray) {
        if ([[dict safeObjectForKey:@"Name"] isEqualToString:name]) {
            return @"该姓名已存在";
        }
    }
    
    return nil;
}

- (void) saveBtnClick:(id)sender
{
    editCell = (SelectRoomerEditCell *)[roomList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *name = editCell.nameTextField.text;
    NSString *msg = [self checkName:name];
	if (msg) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
		[alert show];
		[alert release];
		return ;
	}
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *parts = [name componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    NSString *theString = [filteredArray componentsJoinedByString:@" "];
    
    NSMutableArray *roomerArray = [SelectRoomer allRoomers];
    BOOL canBeChoosed = NO;         // 标记新增乘客是否能被选中,大于房间总数时是不能被选中的
    
    NSInteger count = 0;
    for (NSMutableDictionary *dict in allRoomers) {
        if ([[dict safeObjectForKey:@"Checked"] boolValue]) {
            count++;
        }
    }
    if(count < roomCount)
    {
        canBeChoosed = YES;
        [self uploadRemain];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:theString,@"Name",[NSNumber numberWithBool:canBeChoosed],@"Checked", nil];
    [roomerArray insertObject:dict atIndex:0];
    
    [editCell endEdit];
    [editCell.nameTextField resignFirstResponder];
    
    [roomList performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
    
    UMENG_EVENT(UEvent_Hotel_FillOrder_RoomerAdd)
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (editCell) {
        [editCell keyboardBack];
    }
}


#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//[self setTabViewHeight];
    if (section == 0) {
        return 1;
    }else{
        return [[SelectRoomer allRoomers] count];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 54;
    }else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        // 编辑入住人
        static NSString *selectRoomerEditIdentifier = @"SelectRoomerEditCellIdentifier";
        SelectRoomerEditCell *cell = (SelectRoomerEditCell *)[tableView dequeueReusableCellWithIdentifier:selectRoomerEditIdentifier];
        if (cell == nil) {
            cell = [[[SelectRoomerEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectRoomerEditIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            
            if (self.selectType == SELECTRENT)
            {
                cell.nameTextField.placeholder = @"新增常用乘车人";
            }else if (self.selectType == SELECT_SCENICTICKETS){
                cell.nameTextField.placeholder = @"新增常用购票人";
            }
            
            
            [cell.saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (allRoomers==nil|allRoomers.count == 0) {
            [cell addBtnClick:nil];
        }
        editCell = cell;
        
        return cell;
    }else if(indexPath.section == 1){
        // 选择入住人
        static NSString *selectRoomerCellIdentifier = @"SelectRoomerCellIdentifier";
        SelectRoomerCell *cell = (SelectRoomerCell *)[tableView dequeueReusableCellWithIdentifier:selectRoomerCellIdentifier];
        if (cell == nil) {
            
            cell = [[[SelectRoomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectRoomerCellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        if ([self tableView:tableView numberOfRowsInSection:indexPath.section] == 1) {
            cell.cellType = 2;
        }else{
            if (indexPath.row == 0) {
                cell.cellType = -1;
            }else if(indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] -1){
                cell.cellType = 1;
            }else{
                cell.cellType = 0;
            }
        }
        
        NSUInteger row = [indexPath row];
        NSDictionary *dict = [[SelectRoomer allRoomers] safeObjectAtIndex:row];
        if ([dict safeObjectForKey:@"Checked"] && [[dict safeObjectForKey:@"Checked"] boolValue]) {
            [cell setChecked:YES];
            
        }else{
            [cell setChecked:NO];
        }
        
        if ([selectedPeopleIndexArray containsObject:[NSNumber numberWithInt:indexPath.row]] &&
            roomCount > 1)
        {
            // 设置“房间x入住人”
            [cell setRoomIndex:[selectedPeopleIndexArray indexOfObject:[NSNumber numberWithInt: indexPath.row]] + 1];
        }
        else
        {
            [cell setRoomIndex:0];
        }
        
        [cell setName:[dict safeObjectForKey:@"Name"]];
        
        return cell;
    }
    return nil;
}

- (void) uploadRemain{
    peopleCount = 0;
    for (NSMutableDictionary *dict in allRoomers) {
        if ([[dict safeObjectForKey:@"Checked"] boolValue]) {
            peopleCount++;
        }
    }
    remainLbl.text = [NSString stringWithFormat:@"%d位",roomCount - peopleCount];
    
}

//select cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    
    if (editCell) {
        [editCell keyboardBack];
    }
    
    NSMutableDictionary *dict = (NSMutableDictionary *)[[SelectRoomer allRoomers] safeObjectAtIndex:indexPath.row];
    BOOL formerChecked = [[dict safeObjectForKey:@"Checked"] boolValue];
    [dict safeSetObject:[NSNumber numberWithBool:!formerChecked] forKey:@"Checked"];
    
    if (formerChecked == NO)
    {
        if ([selectedPeopleIndexArray count] < roomCount)
        {
            [selectedPeopleIndexArray addObject:[NSNumber numberWithInt:indexPath.row]];
        }
    }
    else
    {
        [selectedPeopleIndexArray removeObject:[NSNumber numberWithInt:indexPath.row]];
    }
    NSLog(@"%@", selectedPeopleIndexArray);
    
    NSInteger count = 0;
    for (NSMutableDictionary *dict in allRoomers) {
        if ([[dict safeObjectForKey:@"Checked"] boolValue]) {
            count++;
        }
    }
    if(count > roomCount){
        //[Utils alert:@"每间房填写一个入住人"];
        [self  didSelectAlert];
        
        [dict safeSetObject:[NSNumber numberWithBool:NO] forKey:@"Checked"];
    }
    else
    {
        [self uploadRemain];
        [tableView reloadData];
    }
}

- (void) didSelectAlert
{
    [Utils alertQuiet:@"每间房只需选择一位入住人"];
    
}
#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    if (util == getRoomerUtil) {
        [smallLoading stopLoading];
        
        if ([delegate respondsToSelector:@selector(setRequestOver:)]) {
            [delegate setRequestOver:YES];
        }
        
        NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary *root = [string JSONValue];
        if ([Utils checkJsonIsError:root]) {
            return ;
        }
        NSArray *customers = [root safeObjectForKey:@"Customers"];
        
        for (NSDictionary *customer in customers) {
            if ([customer safeObjectForKey:@"Name"]!=[NSNull null]) {
                NSString *name = [customer safeObjectForKey:@"Name"];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:name,@"Name",[NSNumber numberWithBool:NO],@"Checked", nil];
                [[SelectRoomer allRoomers] addObject:dict];
            }
        }
        
        isLoaded = YES;
        
        [roomList reloadData];
    }
}


- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error {
    if (util == getRoomerUtil) {
        // 请求失败时处理同无联系人的情况
        [smallLoading stopLoading];
    }
}


- (void)httpConnectionDidCanceled:(HttpUtil *)util {
    if (util == getRoomerUtil) {
        // 请求取消时处理同无联系人的情况
        [smallLoading stopLoading];
    }
}
@end
