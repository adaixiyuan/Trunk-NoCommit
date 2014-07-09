    //
//  CustomAB.m
//  QuickContacts
//
//  Created by 赵 海波 on 12-8-1.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomAB.h"
#import "ABContact.h"
#import "CustomPerson.h"
#import "SearchBarView.h"

#define kNameTag		9827
#define kRefTag			9828

@implementation CustomAB

@synthesize delegate;

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[filterPeopleInfos	release];
	[allPeopleInfos		release];
	[searchDisplayCtr	release];
	[allContactArray	release];
	[namesIndexArray	release];
	[nameIndexDic		release];
	[indexSet			release];
	[subTitle			release];
	
	self.delegate = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark initialization

- (void)makeTableIndex {
	indexSet	 = [[NSMutableSet alloc] initWithCapacity:2];
	nameIndexDic = [[NSMutableDictionary alloc] initWithCapacity:2];
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:2];
	
	for (id person in allPeopleInfos) {
		ABContact *contact = [[ABContact alloc] initWithRef:person];
		[array addObject:contact];
		[contact release];
		
		if (contact) {
			NSLog(@"%@",contact.phoneTic);
			
			[indexSet addObject:contact.phoneTic];
			
			// 添加索引关系表
			NSMutableArray *sectionArray = [nameIndexDic safeObjectForKey:contact.phoneTic];
			
			if (sectionArray) {
				if (![sectionArray containsObject:contact]) {
					[sectionArray addObject:contact];
				}
			}
			else {
				sectionArray = [NSMutableArray arrayWithCapacity:2];
				[sectionArray addObject:contact];
				[nameIndexDic safeSetObject:sectionArray forKey:contact.phoneTic];
			}
		}
	}
	
	NSMutableArray *indexSortArray = [NSMutableArray arrayWithArray:[[indexSet allObjects] sortedArrayUsingSelector:@selector(compare:)]];
	if ([indexSortArray containsObject:@"#"]) {
		// 把‘＃’的 索引放到最后显示
		[indexSortArray addObject:[indexSortArray safeObjectAtIndex:0]];
		[indexSortArray removeObjectAtIndex:0];
	}
    
	allContactArray = [[NSArray alloc] initWithArray:array];
    
	namesIndexArray = [[NSArray alloc] initWithArray:indexSortArray];
    
    for (NSString *key in nameIndexDic.allKeys) {
        [nameIndexDic setObject:[[nameIndexDic objectForKey:key] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [((ABContact *)obj1).fullName localizedCaseInsensitiveCompare:((ABContact *)obj2).fullName];
        }] forKey:key];
    }
}


- (id)initWithContactStyle:(ABPropertyID)style {
    subStyle = style;
    if (subStyle == 3) {
        subTitle = [@"选择联系人电话" copy];
    }
    else if (subStyle == 4) {
        subTitle = [@"选择联系人邮箱" copy];
    }

    if (IOSVersion_6) {
        if (self = [super initWithTopImagePath:nil andTitle:@"所有联系人" style:_NavOnlyBackBtnStyle_]) {
            __block CustomAB *controller = self;
            if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
            {
                self.view.userInteractionEnabled = NO;
                ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
                ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                         {
                                                             if (granted)
                                                             {
                                                                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                     NSLog(@"granted");
                                                                     allPeopleInfos = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef);
                                                                     
                                                                     if (allPeopleInfos) {
                                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                             [controller makeTableIndex];
                                                                             CFRelease(addressBookRef);
                                                                             [listTable reloadData];
                                                                             [listTable scrollRectToVisible:CGRectMake(0, 0, 300, 371) animated:YES];
                                                                             self.view.userInteractionEnabled = YES;
                                                                         });
                                                                     }
                                                                 });
                                                                 
                                                             }
                                                             else if (error)
                                                             {
                                                                 NSLog(@"error");
                                                                 self.view.userInteractionEnabled = YES;
                                                             }
                                                             else
                                                             {
                                                                 NSLog(@"not error not granted");
                                                                 self.view.userInteractionEnabled = YES;
                                                             }
                                                         });
                
            }
            else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
            {
                NSLog(@"kABAuthorizationStatusAuthorized");
                [self showContactChooser];
            }
            else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied)
            {
                NSLog(@"kABAuthorizationStatusDenied");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未开启通讯录权限"
                                                                message:@"请在设置中开启"
                                                               delegate:self
                                                      cancelButtonTitle:@"知道了"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];

            }
        }
    }
	else
    {
        ABAddressBookRef addressRef = ABAddressBookCreate();
        allPeopleInfos = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressRef);
        [self makeTableIndex];
        CFRelease(addressRef);
    }
	return self;
}
#pragma mark -
#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)showContactChooser
{
    ABAddressBookRef addressRef = ABAddressBookCreateWithOptions(NULL, NULL);
    allPeopleInfos = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressRef);
    [self makeTableIndex];
    CFRelease(addressRef);
}
- (void)viewDidLoad {
    [super viewDidLoad];
	
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_WORDBTN_WIDTH, 34)];
    cancelBtn.adjustsImageWhenDisabled = NO;
    cancelBtn.titleLabel.textAlignment = UITextAlignmentRight;
    cancelBtn.titleEdgeInsets = EDGE_NAV_LEFTITEM;
    cancelBtn.titleLabel.font = FONT_B15;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [cancelBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    [cancelBtn release];
	
	// nav button
	self.navigationItem.leftBarButtonItem = leftBtnItem;
    [leftBtnItem release];
    

	
	// make search bar
	SearchBarView *searchBar = [[SearchBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
	searchBar.placeholder   = @"搜索";
	searchBar.delegate      = self;
	searchBar.translucent	= YES;
	
	searchDisplayCtr = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];  
	searchDisplayCtr.delegate = self; 
	[searchDisplayCtr setSearchResultsDataSource:self];  
	[searchDisplayCtr setSearchResultsDelegate:self];
	
	[self.view addSubview:searchBar];
	[searchBar release];
	
    listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, searchBar.frame.origin.y + searchBar.frame.size.height, 320, MAINCONTENTHEIGHT - 44)
														  style:UITableViewStylePlain];
	listTable.dataSource	 = self;
	listTable.delegate		 = self;
	[self.view addSubview:listTable];
	[listTable release];
}


- (void)cancel {
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}


- (void)filterSearchPeopleByName:(NSString *)filterStr {
	// 根据搜索条件过滤名字
	NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:2];
	
	for (ABContact *contact in allContactArray) {
		if ([[NSPredicate predicateWithFormat:@"self contains[cd] %@", filterStr] evaluateWithObject:contact.fullName]) {
			[mArray addObject:contact];
		}
	}
	
	[filterPeopleInfos release];
	filterPeopleInfos = [mArray retain];
}


#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (BOOL)needToShowSectionTitle {
	if ([allPeopleInfos count] > 5 && [namesIndexArray count] > 1) {
		return YES;
	}
	
	return NO;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return 1;
	}
	else if ([self needToShowSectionTitle]) {
		// 有5个以上名字切首字母不同时才加索引
		return [namesIndexArray count];
	}
	else {
		return 1;
	}
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return nil;
	}
	else if ([self needToShowSectionTitle]) {
		return namesIndexArray;
	}
	else {
		return nil;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return [filterPeopleInfos count];
	}
	else if ([self needToShowSectionTitle]) {
		return [[nameIndexDic safeObjectForKey:[namesIndexArray safeObjectAtIndex:section]] count];
	}
	else {
		return [allPeopleInfos count];
	}
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		return nil;
	}
	else if ([self needToShowSectionTitle]) {
		UIView* mview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
		mview.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
		
		UILabel *headerview = [[UILabel alloc] initWithFrame:CGRectMake(9, -3, 320, 27)];
		headerview.backgroundColor	= [UIColor clearColor];
		headerview.alpha			= 0.9;
		headerview.text				= [NSString stringWithFormat:@"%@",[namesIndexArray safeObjectAtIndex:section]];
		headerview.font				= FONTBOLD1;
		headerview.textColor		= COLOR_NAV_TITLE;
		headerview.textAlignment	= UITextAlignmentLeft;
		[mview addSubview:headerview];
		[headerview release];
		
		return [mview autorelease];
	}
	else {
		return nil;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SelectTableCellKey = @"SelectTableCellKey";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
	
    if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SelectTableCellKey] autorelease];
	}
	
	ABContact *contact;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		contact = [filterPeopleInfos safeObjectAtIndex:indexPath.row];
	}
	else if ([self needToShowSectionTitle]) {
		contact = [[nameIndexDic safeObjectForKey:[namesIndexArray safeObjectAtIndex:indexPath.section]]
										   safeObjectAtIndex:indexPath.row];
	}
	else {
		contact = [allContactArray safeObjectAtIndex:indexPath.row];
	}
	
	cell.textLabel.text = contact.fullName;
	cell.detailTextLabel.text = contact.phoneNumber;
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ABContact *contact;
	
	if (tableView == self.searchDisplayController.searchResultsTableView) {
		contact  = [filterPeopleInfos safeObjectAtIndex:indexPath.row];
	}
	else if ([self needToShowSectionTitle]) {
		contact = [[nameIndexDic safeObjectForKey:[namesIndexArray safeObjectAtIndex:indexPath.section]] safeObjectAtIndex:indexPath.row];
	}
	else {
		contact = [allContactArray safeObjectAtIndex:indexPath.row];
	}
	
	if (subStyle) {
		if (subStyle == kABPersonPhoneProperty) {
			// 如果只有一个电话，直接选择，多个电话或没有电话进入子页面
			if (contact.isOnlyAPhone && contact.phoneNumber) {
                NSString *phonestring = [contact.phoneNumber substringWithRange:NSMakeRange(0, 3)];
                if ([phonestring isEqualToString:@"+86"]) {
                    NSString *contactPhone = [contact.phoneNumber substringFromIndex:3];
                    contactPhone = [contactPhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    [delegate getSelectedString:contactPhone];
                }
                else{
                    NSString *contactPhone = contact.phoneNumber;
                    contactPhone = [contactPhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    [delegate getSelectedString:contactPhone];
                }

                if (IOSVersion_7) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self dismissModalViewControllerAnimated:YES];
                }
				
				return;
			}
		}
		
		// 进入子界面继续选择
        ABPersonViewController *pvc = nil;
        if (IOSVersion_7) {
            pvc = [[ABPersonViewController alloc] init];
        }else{
            pvc = [[CustomPerson alloc] initWithTitle:subTitle];
        }
        
		pvc.displayedPerson = contact.record;
		pvc.personViewDelegate = self;
        //pvc.addressBook = ABAddressBookCreate();
		pvc.allowsEditing = NO; // optional
		[pvc setDisplayedProperties:[NSArray arrayWithObject:NUMBER(subStyle)]];
		[[self navigationController] pushViewController:pvc animated:YES];
        [pvc autorelease];
	}
	else {
		// 直接返回名字
		[delegate getSelectedString:contact.fullName];
        if (IOSVersion_7) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self dismissModalViewControllerAnimated:YES];
        }
	}
}


#pragma mark -
#pragma mark ABPersonViewController Delegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
	CFTypeRef theProperty = ABRecordCopyValue(person, property);
	NSArray *items = (NSArray *)ABMultiValueCopyArrayOfAllValues(theProperty);
	NSString *selectedStr = [items safeObjectAtIndex:identifier];
	
	[delegate getSelectedString:selectedStr];
	
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
	
	[items release];
	CFRelease(theProperty);
	
	return NO;
}

#pragma mark -
#pragma mark UISearchBar & DisplayController Delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	searchBar.text = @"";
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	[self filterSearchPeopleByName:searchString];
	return YES;
}

@end
