//
//  AddRoomer.h
//  ElongClient
//
//  Created by bin xing on 11-1-13.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "DPViewTopBarDelegate.h"
#import "DPViewTopBar.h"

@protocol AddNameDelegate;

@interface AddRoomer : DPNav<UITextFieldDelegate, DPViewTopBarDelegate> {
	IBOutlet UITextField *textField;
	UITableView *m_tableView;
	DPViewTopBar *dpViewTopBar;
}

@property (nonatomic, assign) id<AddNameDelegate> delegate;

-(id)init:(NSString *)name btnname:(NSString *)btnname navLeftBtnStyle:(NavLeftBtnStyle)navLeftBtnStyle tableview:(UITableView *)tableview;
@end


@protocol AddNameDelegate <NSObject>

@optional
- (void)getNewName:(NSString *)newName;

@end
