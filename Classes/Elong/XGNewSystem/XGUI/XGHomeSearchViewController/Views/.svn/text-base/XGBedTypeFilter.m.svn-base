//
//  XGBedTypeFilter.m
//  ElongClient
//
//  Created by 李程 on 14-5-27.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGBedTypeFilter.h"
#import "CommonCell.h"
@interface XGBedTypeFilter ()

@end

@implementation XGBedTypeFilter

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    if (self = [super initWithTitle:@"选择床型" Datas:nil]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.nArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SelectTableCellKey = @"SelectTableCellKey";
    
	CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
	if (cell == nil) {
		cell = [[CommonCell alloc] initWithIdentifier:SelectTableCellKey height:45 style:CommonCellStyleChoose];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    cell.textLabel.font=[UIFont boldSystemFontOfSize:15];
    
    cell.textLabel.text  = [self.nArray objectAtIndex:indexPath.row];
    
//    if (indexPath.row == 0) {
//		cell.textLabel.text = @"床型不限";
//	}else if (indexPath.row ==1){
//        cell.textLabel.text = @"大床";
//    }else if (indexPath.row==2){
//        cell.textLabel.text = @"双床";
//    }
    
	if (indexPath.row == currentRow) {
		cell.cellImage.highlighted = YES;
	}
	else {
		cell.cellImage.highlighted = NO;
	}
	
    return cell;
}


@end
