//
//  ItemsViewController.m
//  Home
//
//  Created by Dawn on 13-12-6.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "HomeItemsViewController.h"
#import "HomeItem.h"
#import "HomeAdView.h"
#import "AdviceAndFeedback.h"
#import "HomeItemRequest.h"

#define kNewLabelTag        9999

@interface HomeItemsViewController ()
@property (nonatomic,retain) HomeLayout *homeLayout;
@property (nonatomic,retain) HomeLayout *staticLayout;
@property (nonatomic,retain) NSMutableArray *itemArray;
@end

@implementation HomeItemsViewController

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    self.homeLayout = nil;
    self.itemArray = nil;
    self.delegate = nil;
    self.staticLayout = nil;
    if (logUtil) {
        [logUtil cancel];
        [logUtil release];
        logUtil = nil;
    }
    [super dealloc];
}


- (id) initWithHomeLayout:(HomeLayout *)layout{
    if (self = [super initWithTopImagePath:nil andTitle:@"定制首页" style:_NavOnlyBackBtnStyle_]) {
        self.homeLayout = layout;
        HomeItem *scrollableItem = nil;
        for (HomeItem *item in self.homeLayout.items) {
            if (item.scrollable) {
                scrollableItem = item;
                break;
            }
        }
        
        // 先读取之前已有数据
        self.itemArray = [NSMutableArray array];
        for (HomeItem *item in scrollableItem.subitems) {
            HomeItem *newItem = [item copy];
            newItem.selected = YES;
            [self.itemArray addObject:newItem];
            [newItem release];
        }
        
        // 增加新的
        self.staticLayout = [[[HomeLayout alloc] initWithDefaultFileName:@"HomeItems"] autorelease];
        for (HomeItem *nitem in self.staticLayout.items) {
            BOOL exist = NO;
            for (HomeItem *oitem in scrollableItem.subitems) {
                if (oitem.tag == nitem.tag) {
                    exist = YES;
                    break;
                }
            }
            if (!exist) {
                nitem.selected = NO;
                nitem.superItem = scrollableItem;
                [self.itemArray addObject:nitem];
            }
        }
        
        UITableView *itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 20) style:UITableViewStylePlain];
        itemTableView.delegate = self;
        itemTableView.dataSource = self;
        [self.view addSubview:itemTableView];
        [itemTableView release];
        itemTableView.allowsSelectionDuringEditing = YES;
        itemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        itemTableView.backgroundColor = [UIColor clearColor];
        
        //
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"完成" Target:self Action:@selector(saveBtnClick:)];
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"取消" Target:self Action:@selector(cancelBtnClick:)];
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
}

- (void) cancelBtnClick:(id)sender{
    if(IOSVersion_7){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
    if ([self.delegate respondsToSelector:@selector(homeItemsVCDismiss:)]) {
        [self.delegate homeItemsVCDismiss:self];
    }
}

- (void) addToolsBtnClick:(id)sender{
    AdviceAndFeedback *feedback = [[AdviceAndFeedback alloc] initWithTopImagePath:nil andTitle:@"意见反馈" style:_NavLeftBtnImageStyle_];
    [self.navigationController pushViewController:feedback animated:YES];
    [feedback release];
}

- (void) saveBtnClick:(id)sender{
    if (DEBUGBAR_SWITCH) {
        // 如果开着调试控制台，进行拦截
        if ([[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_DEBUG_MODULES]) {
            NSArray *itemArray = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_DEBUG_MODULES];
            for (NSNumber *tag in itemArray) {
                if ([tag intValue] == -1) {
                    return;
                }
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(homeItemsVC:didEndEditWithItems:)]) {
        NSMutableArray *newItemArray = [NSMutableArray array];
        NSMutableArray *itemIdArray = [NSMutableArray array];
        for (int i = 0;i < self.itemArray.count;i++) {
            HomeItem *item = [self.itemArray objectAtIndex:i];
            if (item.deletable && item.selected) {
                // 记录日志
                NSInteger tag = item.tag;
                [itemIdArray addObject:[NSNumber numberWithInteger:tag]];
            }
            if (item.deletable && !item.selected) {
                
            }else{
                [newItemArray addObject:item];
            }
        }
        [self.delegate homeItemsVC:self didEndEditWithItems:newItemArray];
        
        
        /*
         FLIGHT_INFO("1", "FlightTrend"),
         
         TRAVEL_PACKAGE("2", "TravelPacket"),
         
         EXCHANGE_RATE("3", "ExchangeRates"),
         
         TAKETAXI("4", "TakeTaxi"),
         
         HOTEL("5","Hotel"),
         
         FLIGHT("6","Flight"),
         
         TUAN("7","Tuan"),
         
         TRAIN("8","Train"),
         
         UNKNOWN("-1","Unknown")
         */
        if (itemIdArray.count) {
            NSMutableArray *logItems = [NSMutableArray array];
            for (NSNumber *item in itemIdArray) {
                [logItems addObject:[NSNumber numberWithInt:[PublicMethods getHomeItemType:item.intValue]]];
            }
            
            if (logUtil) {
                [logUtil cancel];
                [logUtil release];
                logUtil = nil;
            }
            HomeItemRequest *request = [[HomeItemRequest alloc] init];
            request.logRecords = logItems;
            request.logRecordStatus = nil;
            
            NSString *url = [PublicMethods composeNetSearchUrl:@"mtools"
                                                    forService:@"doLog"
                                                      andParam:[request requestForLog]];
            logUtil = [[HttpUtil alloc] init];
            [logUtil requestWithURLString:url Content:nil StartLoading:NO EndLoading:NO Delegate:self];
            
            [request release];
            
            // 记录选择项
            if (UMENG) {
                [MobClick event:Event_Home_Tools label:[itemIdArray componentsJoinedByString:@","]];
            }
        }
        
    }
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
    
    
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeItem *item = (HomeItem *)[self.itemArray objectAtIndex:indexPath.row];
    if (item.deletable) {
        return 70;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if (sourceIndexPath != destinationIndexPath) {
        
        id object = [self.itemArray objectAtIndex:sourceIndexPath.row];
        [object retain];
        [self.itemArray removeObjectAtIndex:sourceIndexPath.row];
        if (destinationIndexPath.row > [self.itemArray count]) {
            [self.itemArray addObject:object];
        }
        else {
            [self.itemArray insertObject:object atIndex:destinationIndexPath.row];
        }
        [object release];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeItem *item = (HomeItem *)[self.itemArray objectAtIndex:indexPath.row];
    if (item.deletable) {
        item.selected = !item.selected;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}



#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.itemArray.count;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"ItemCell";
    HomeItemCell *cell = (HomeItemCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[HomeItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor =  [UIColor whiteColor];
        
        UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, cell.titleLbl.frame.origin.y - 1, 100, cell.titleLbl.frame.size.height)];
        newLabel.textColor = [UIColor redColor];
        newLabel.text = @"New !";
        newLabel.font = FONT_15;
        newLabel.tag = kNewLabelTag;
        newLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:newLabel];
        [newLabel release];
    }
    
    HomeItem *item = (HomeItem *)[self.itemArray objectAtIndex:indexPath.row];
    cell.titleLbl.text = item.title;
    cell.detailLbl.text = item.subtitle;
    
    UILabel *newLabel = (UILabel *)[cell.contentView viewWithTag:kNewLabelTag];
    // 本期用车加上New的标题
    if([cell.titleLbl.text isEqualToString:@"用车"]){
        newLabel.hidden = NO;
        newLabel.text = @"  New !";
    }else{
        newLabel.hidden = YES;
    }
    
    
    if (item.deletable) {
        cell.selectable = YES;
    }else{
        cell.selectable = NO;
        cell.hidden = YES;
    }
    cell.checked = item.selected;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
  
    return proposedDestinationIndexPath;
}

#pragma mark -
#pragma mark HttpDelegate
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    if (logUtil == util) {
        NSDictionary *infoDict = [PublicMethods unCompressData:responseData];
        NSLog(@"%@",infoDict);
        return;
    }
}

@end
