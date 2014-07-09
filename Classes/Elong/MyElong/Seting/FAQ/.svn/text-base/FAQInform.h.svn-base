//
//  FAQInform.h
//  ElongClient
//
//  Created by jinmiao on 11-2-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "FAQInformCell.h"
#import "Utils.h"
@interface FAQInform :  DPNav < UITableViewDelegate , UITableViewDataSource , UIScrollViewDelegate > {
	UITableView* _tableView;
	NSMutableArray* datasource;
	int preSelectRow;
	int currentRow;
	int defaultHeight;
	NSIndexPath* preSelectIndex;
}
@property (nonatomic, retain) UITableView *_tableView;
@property (nonatomic, retain) NSIndexPath *preSelectIndex;

-(id)init:(NSString *)name style:(NavBtnStyle)style _filename:(NSString *)_filename;
@end
