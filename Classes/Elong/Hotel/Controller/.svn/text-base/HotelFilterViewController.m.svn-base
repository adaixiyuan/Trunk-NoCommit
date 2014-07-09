    //
//  HotelFilterViewController.m
//  ElongClient
//
//  Created by haibo on 12-2-21.
//  Copyright 2012 elong. All rights reserved.
//

#import "HotelFilterViewController.h"


@implementation HotelFilterViewController

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
	[dataArray release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Init

- (id)initWithTogImageNamed:(NSString *)imageName Title:(NSString *)title SelectedString:(NSString *)string Datas:(NSArray *)datas {
	if (self = [super initWithTopImagePath:imageName andTitle:title style:_NavOnlyBackBtnStyle_]) {
		dataArray = [[NSArray alloc] initWithArray:datas];
        if (!string) {
            string = @"";
        }
		// 有选择值时选中该值，没有则选中默认项
		if ([dataArray containsObject:string]) {
			currentRow = [dataArray indexOfObject:string];
		}
		else {
			currentRow = 0;
		}
		
		lastRow = currentRow;
	}
	
	return self;
}


- (void)viewDidLoad {
	[super viewDidLoad];
	
	// table
	UITableView *keyTable	= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 20) style:UITableViewStylePlain];
	keyTable.delegate		= self;
	keyTable.dataSource		= self;
	keyTable.backgroundColor = [UIColor whiteColor];
	keyTable.separatorStyle	= UITableViewCellSeparatorStyleNone;
	[self.view addSubview:keyTable];
	[keyTable release];
	
	UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
	keyTable.tableHeaderView = headView;
	[headView release];
}


#pragma mark -
#pragma mark TableView DataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return HSC_CELL_HEGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SelectTableCellKey = @"SelectTableCellKey";
	
	CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
	if (cell == nil) {
		cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKey height:HSC_CELL_HEGHT style:CommonCellStyleChoose] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	cell.textLabel.text = [dataArray safeObjectAtIndex:indexPath.row];
	if (indexPath.row == currentRow) {
		cell.cellImage.highlighted = YES;
	}
	else {
		cell.cellImage.highlighted = NO;
	}

	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// 勾选选中项
	if (currentRow != indexPath.row) {
		currentRow = indexPath.row;
		
		CommonCell *lastCell = (CommonCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:lastRow inSection:0]];
		lastCell.cellImage.highlighted = NO;
		
		CommonCell *cell = (CommonCell *)[tableView cellForRowAtIndexPath:indexPath];
		cell.cellImage.highlighted = YES;
				
		lastRow = currentRow;
	}
	
	// 退出当前页
	[delegate getFilterString:[dataArray safeObjectAtIndex:currentRow]];
	[self.navigationController popViewControllerAnimated:YES];
}

@end
