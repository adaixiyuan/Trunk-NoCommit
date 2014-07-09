//
//  SelectSelfGetAddress.h
//  ElongClient
//  机场自取地址页面
//  Created by dengfang on 11-3-12.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "ElongURL.h"

@interface SelectSelfGetAddress : DPNav <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tabView;
	IBOutlet UIView *selectView;
	IBOutlet UIButton *nextButton;
	
	NSMutableArray *allArray;
	NSMutableArray *dataArray;
	NSMutableDictionary *selectedDictionary;
	double m_tabHeight;
	int currentRow;
    int netType;
}

@property (nonatomic) int currentRow;
@property (nonatomic, retain) UITableView *tabView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *allArray;

- (id)init:(NSString *)name style:(NavBtnStyle)style data:(NSMutableArray *)array;
- (void)setTabViewHeight;
- (IBAction)nextButtonPressed;

@end
