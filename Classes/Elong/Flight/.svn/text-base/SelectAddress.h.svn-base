//
//  SelectAddress.h
//  ElongClient
//  邮寄行程单地址页面
//  Created by dengfang on 11-1-27.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "ElongURL.h"

//@class SelectedAddressView;
@interface SelectAddress : DPNav <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tabView;
	IBOutlet UIView *selectView;
	IBOutlet UIView *addView;
	IBOutlet UIButton *addButton;
	IBOutlet UIButton *nextButton;
	
	NSMutableArray *allArray;
	NSMutableArray *dataArray;
    NSMutableArray *postcodeArray;
	double m_tabHeight;
	int currentRow;
    int netType;
	
//	SelectedAddressView *addressView;
}

@property (nonatomic) int currentRow;
@property (nonatomic, retain) UITableView *tabView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *allArray;
@property (nonatomic, retain) NSMutableDictionary *selectedDictionary;

- (id)init:(NSString *)name style:(NavBtnStyle)style data:(NSMutableArray *)array;
- (void)setTabViewHeight;
- (IBAction)addButtonPressed;
- (IBAction)nextButtonPressed;

@end