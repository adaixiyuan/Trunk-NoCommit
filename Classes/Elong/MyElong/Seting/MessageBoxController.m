//
//  MessageBoxController.m
//  ElongClient
//
//  Created by 赵岩 on 13-5-23.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "MessageBoxController.h"
#import "MessageCell.h"
#import "MessageManager.h"
#import "Notification.h"
#import "MessageContentViewController.h"


@interface MessageBoxController (){
    HomeAdNavi *homeAdNavi;
    UITableView *mainTable;
}


@end

@implementation MessageBoxController

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [homeAdNavi release];
    [super dealloc];
}

- (id)init{
    if (self = [super init:@"" style:_NavOnlyBackBtnStyle_]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 19)];
		label.backgroundColor	= [UIColor clearColor];
		label.font				= FONT_B18;
		label.textColor			= [UIColor blackColor];
		label.text				= @"消息中心";
		label.textAlignment		= UITextAlignmentCenter;
		self.navigationItem.titleView = label;
		[label release];
        
        homeAdNavi = [[HomeAdNavi alloc] init];
    }
    return self;
}

-(void)updateUIWithFrame:(CGRect)aFrame{
    mainTable.frame  = aFrame;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)loadView{
    [super loadView];
    
    mainTable = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.backgroundColor = [UIColor clearColor];
    mainTable.dataSource = self;
    mainTable.delegate = self;
    [self.view addSubview:mainTable];

    mainTable.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)] autorelease];
    mainTable.tableHeaderView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 30)];
    label.text = @"提示：消息盒子只保存最近20条消息";
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
    [label setTextColor:[UIColor colorWithRed:0.3294 green:0.3294 blue:0.3294 alpha:1.0]];
    [mainTable.tableHeaderView addSubview:label];
    [label release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification) name:NOTI_RECEIVEREMOTENOTIFICATION object:nil];
    
    [self updateEditBtn];
}

- (void) updateEditBtn{
    if ([[MessageManager sharedInstance] messageCount]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"编辑" Target:self Action:@selector(edit)];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)receiveRemoteNotification{
    [mainTable reloadData];
    [self updateEditBtn];
}

// 编辑消息列表
- (void) edit{
    //判断是不是可以删
    BOOL isCanBeEditing = NO;
    if ([[MessageManager sharedInstance] messageCount]) {
        isCanBeEditing = YES;
    }
    
    //如果可编辑
    if(isCanBeEditing){
        if(mainTable.isEditing){
            [mainTable setEditing:NO animated:YES];
            self.navigationItem.rightBarButtonItem =  [UIBarButtonItem navBarRightButtonItemWithTitle:@"编辑" Target:self Action:@selector(edit)];
        }else{
            [mainTable setEditing:YES animated:YES];
            self.navigationItem.rightBarButtonItem =  [UIBarButtonItem navBarRightButtonItemWithTitle:@"完成" Target:self Action:@selector(edit)];
        }
    }
}

#pragma mark UITableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[MessageManager sharedInstance] messageCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MessageCell";
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        cell.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = [bgView autorelease];
        
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
    }
    float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    cell.messageLabel.frame = CGRectMake(10, 5, SCREEN_WIDTH - 50, height - 20 - 5);
    cell.timeLabel.frame = CGRectMake(10, height - 20, SCREEN_WIDTH - 50, 20);
    cell.bottomLine.frame = CGRectMake(0, height - 1, SCREEN_WIDTH, SCREEN_SCALE);
    cell.icon.frame = CGRectMake(SCREEN_WIDTH - 30, 0, 10, height);
    cell.arrow.frame = CGRectMake(SCREEN_WIDTH - 20, 0, 10, height);
    
    int index = [[MessageManager sharedInstance] messageCount]-1-indexPath.row;
    EMessage *m = [[MessageManager sharedInstance] getMessageByIndex:index];        //倒序显示
    
    cell.messageLabel.text = m.body;
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm";
    NSString *time = [formatter stringFromDate:m.time];
    cell.timeLabel.text = time;
    cell.icon.hidden = m.hasRead;
    
    if(indexPath.row==0){
        cell.topLine.hidden = NO;
    }else{
        cell.topLine.hidden = YES;
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int index = [[MessageManager sharedInstance] messageCount]-1-indexPath.row;
    EMessage *m = [[MessageManager sharedInstance] getMessageByIndex:index];        //倒序显示
    NSString *message = m.body;
    
    CGSize size = CGSizeMake(SCREEN_WIDTH - 50, 1000);
    CGSize newsize = [message sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
    
    return newsize.height + 5 + 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int index = [[MessageManager sharedInstance] messageCount] - 1 - indexPath.row;
    EMessage *message = [[MessageManager sharedInstance] getMessageByIndex:index];
    
    MessageCell *cell = (MessageCell *)[tableView cellForRowAtIndexPath:indexPath];
    message.hasRead = YES;
    [cell setHasRead:YES];
    [[MessageManager sharedInstance] save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_MESSAGECOUNT object:nil];     //通知更新消息条数
    
    
    //BOOL islogin = [[AccountManager instanse] isLogin];
    //BOOL loginNeeded = [homeAdNavi loginNeeded:message.url]; // && (islogin || (!islogin && !loginNeeded))
    if(STRINGHASVALUE(message.url)){
        if ([message.url rangeOfString:@"goto"].length) {
            [homeAdNavi adNaviJumpUrl:message.url title:@"消息内容" active:YES];
        }else{
            [homeAdNavi adNaviJumpUrl:[NSString stringWithFormat:@"gotourl:%@",message.url] title:@"消息内容" active:YES];
        }
    }else{
        MessageContentViewController *messageContentViewCtrl = [[MessageContentViewController alloc] initWithEMessage:message];
        ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.navigationController pushViewController:messageContentViewCtrl animated:YES];
        [messageContentViewCtrl release];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        // 删除消息
        int index = [[MessageManager sharedInstance] messageCount] - 1 - indexPath.row;
        EMessage *message = [[MessageManager sharedInstance] getMessageByIndex:index];
        [[MessageManager sharedInstance] removeMessage:message];
        [mainTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self updateEditBtn];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_MESSAGECOUNT object:nil];     //通知更新消息条数
    }
}

@end
