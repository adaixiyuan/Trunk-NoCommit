//
//  InterAgeSelectorView.m
//  ElongClient
//
//  Created by Dawn on 13-6-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterAgeSelectorView.h"


#define kFirstImgTag    10909
#define kSecondImgTag	10910


@implementation InterAgeSelectorView

- (void)dealloc {
    [super dealloc];
}


- (id)init {
    nArray = [NSArray arrayWithObjects:@"<1岁", @"1岁", @"2岁", @"3岁", @"4岁",@"5岁",@"6岁",@"7岁",@"8岁",@"9岁",@"10岁",@"11岁",@"12岁",@"13岁",@"14岁",@"15岁",@"16岁",@"17岁", nil];
	
    if (self = [super initWithTitle:@"年龄" Datas:nArray]) {
        
    }
	
    return self;
}


#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [nArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SelectTableCellKey = @"SelectTableCellKey";
    
	CommonCell *cell = (CommonCell *)[tableView dequeueReusableCellWithIdentifier:SelectTableCellKey];
	if (cell == nil) {
		cell = [[[CommonCell alloc] initWithIdentifier:SelectTableCellKey height:45 style:CommonCellStyleChoose] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	cell.textLabel.text = [nArray safeObjectAtIndex:indexPath.row];
	
	if (indexPath.row == currentRow) {
		cell.cellImage.highlighted = YES;
	}
	else {
		cell.cellImage.highlighted = NO;
	}
	
    return cell;
}

@end