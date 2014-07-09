//
//  CustomAB.h
//  QuickContacts
//	自定义的通讯录
//
//  Created by 赵 海波 on 12-8-1.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "DPNav.h"

@protocol CustomABDelegate;

@interface CustomAB : DPNav <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, ABPersonViewControllerDelegate> {
@private
	NSArray *allPeopleInfos;			// addressbook datasource
	NSArray *allContactArray;			// all ABContact
	NSArray *filterPeopleInfos;			// searchdisplaycontroller datasource
	NSArray *namesIndexArray;
	
	NSMutableSet *indexSet;				// name index set
	NSMutableDictionary *nameIndexDic;	// record name-index relation
	NSString *subTitle;					// title of next page 
	
	UISearchDisplayController *searchDisplayCtr;
	
	ABPropertyID subStyle;				// what style on the next page
    UITableView *listTable;
    @public
}

@property (nonatomic, assign) id <CustomABDelegate> delegate;
- (id)initWithContactStyle:(ABPropertyID)style;
- (void)showContactChooser;
@end


@protocol CustomABDelegate <NSObject>

@required
- (void)getSelectedString:(NSString *)selectedStr;

@end