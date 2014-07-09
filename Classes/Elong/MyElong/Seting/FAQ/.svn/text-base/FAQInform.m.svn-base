//
//  FAQInform.m
//  ElongClient
//
//  Created by jinmiao on 11-2-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define SIMPLEHEIGHT 45

#import "FAQInform.h"


@implementation FAQInform
@synthesize _tableView;
@synthesize preSelectIndex;

-(id)init:(NSString *)name style:(NavBtnStyle)style _filename:(NSString *)_filename{
	if (self=[super initWithTopImagePath:@"" andTitle:name style:style]) {
		NSString *path = [[NSBundle mainBundle] pathForResource:_filename ofType:@"plist"];    
		NSDictionary *root = [[NSDictionary alloc] initWithContentsOfFile:path];
		datasource = [[NSMutableArray alloc] init];
		for (int i=0;i<[[root allKeys] count];i++) {
			[datasource addObject:[root safeObjectForKey:[NSString stringWithFormat:@"%i",i]]];
		}
		[root release];
		defaultHeight=[datasource count]*SIMPLEHEIGHT;
		currentRow=-1;
		preSelectRow=-1;
		
		self._tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-20-44)  style:UITableViewStylePlain] autorelease];
		self._tableView.delegate = self;
		self._tableView.dataSource = self;
		self._tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		self._tableView.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)] autorelease];
		
		[self.view addSubview:_tableView];
	}
	
	return self;
	
}

-(void)loadView{
	[super loadView];
}
-(void)back{
	[super back];
	[datasource removeAllObjects];
	[datasource release],datasource=nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row == [datasource count]){
		// 必要的占位栏
		UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
														reuseIdentifier:nil] autorelease];
		cell.userInteractionEnabled = NO;
		return cell;
	}
	
	static NSString *cellIdentifier = @"faqinformCell";
    
	FAQInformCell *cell = (FAQInformCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FAQInformCell" owner:self options:nil];
		cell = [nib safeObjectAtIndex:0];
        
        [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, 320, SCREEN_SCALE)]];
	}
	NSInteger row=[indexPath row];
	
	if (currentRow == row) {
		cell.isSelected = YES;
//		cell.headimageView.image = [UIImage noCacheImageNamed:@"ico_faqinfocell_selected.png"];
//		cell.titlelabel.textColor = [UIColor whiteColor];
		
	}else{
		cell.isSelected = NO;
//		cell.headimageView.image = [UIImage noCacheImageNamed:@"ico_faqinfocell.png"];
//		cell.titlelabel.textColor = [UIColor blackColor];
	}
    
    
    NSString *titleText = [[datasource safeObjectAtIndex:row] safeObjectAtIndex:0];
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica Bold" size:14.0];
    CGSize singleSize = [@"abc" sizeWithFont:titleFont];
    CGSize titleSize = [titleText sizeWithFont:titleFont
                        constrainedToSize:CGSizeMake(270, CGFLOAT_MAX)
                            lineBreakMode:NSLineBreakByWordWrapping];
    if (titleSize.height > singleSize.height)
    {
        cell.titlelabel.font = [UIFont fontWithName:@"Helvetica Bold" size:13.0];
        [cell.titlelabel setViewHeight:titleSize.height];
        cell.titlelabel.numberOfLines = 0;
        cell.titlelabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    else
    {
        cell.titlelabel.font = titleFont;
    }
    
	cell.titlelabel.text=titleText;
    
	cell.contentlabel.text=[[datasource safeObjectAtIndex:row] safeObjectAtIndex:1];
	cell.contentlabel.numberOfLines=2000;
	cell.contentlabel.lineBreakMode=UILineBreakModeCharacterWrap;

	cell.row=row;
    
	NSString *string = [[datasource safeObjectAtIndex:row] safeObjectAtIndex:1];
	UIFont *font = [UIFont systemFontOfSize:12];
	CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(270, 1024) lineBreakMode:UILineBreakModeCharacterWrap];
	CGRect oldframe = cell.contentlabel.frame;
	oldframe.size=size;
	cell.contentlabel.frame=oldframe;
	CGRect oldbgframe = cell.subBgview.frame;
	oldbgframe.size.height=oldframe.size.height+10;
	cell.subBgview.frame=oldbgframe;
	
	cell.answerBgImageView.frame = CGRectMake(0, cell.contentlabel.frame.origin.y, 320, cell.contentlabel.frame.size.height+10);

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
	
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	FAQInformCell *cell = (FAQInformCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
	if (cell != nil && cell.isSelected) {
		NSString *string = [[datasource safeObjectAtIndex:cell.row] safeObjectAtIndex:1];
		UIFont *font = [UIFont systemFontOfSize:14];
        CGSize size = [string sizeWithFont:font
                                 constrainedToSize:CGSizeMake(270, CGFLOAT_MAX)
                                     lineBreakMode:NSLineBreakByWordWrapping];
		
		return SIMPLEHEIGHT+size.height+10;
        
	}
	if(indexPath.row == [datasource count]){
		return 200;
	}
    
    return SIMPLEHEIGHT;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [datasource count]+1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==[datasource count]){
        //对于占位符不作处理
        return;
    }
    
	currentRow = [indexPath row];	
		
	if (preSelectRow!=currentRow) {
		currentRow = [indexPath row];
		
		NSString *string = [[datasource safeObjectAtIndex:currentRow] safeObjectAtIndex:1];
		UIFont *font = [UIFont systemFontOfSize:12];
		CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(270, 1024) lineBreakMode:UITableViewRowAnimationNone];
		
		CGRect oldframe = tableView.frame;
		oldframe.size.height=defaultHeight+size.height+10;
		if (oldframe.size.height>480-20-44-12-12) {
			oldframe.size.height=480-20-44-12-12;
		}
		
		//[tableView setFrame:oldframe];
		if (preSelectIndex != nil) {
			//[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:preSelectIndex] withRowAnimation:UITableViewRowAnimationNone];
			FAQInformCell *lastcell = (FAQInformCell *)[tableView cellForRowAtIndexPath:preSelectIndex];	
			lastcell.isSelected = NO;
			lastcell.headimageView.image = [UIImage noCacheImageNamed:@"ico_faqinfocell.png"];
			lastcell.titlelabel.textColor = [UIColor blackColor];
		}
		
		[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
		preSelectRow = currentRow ;
		self.preSelectIndex = indexPath;
		
	}else {
		FAQInformCell *cell = (FAQInformCell *)[tableView cellForRowAtIndexPath:indexPath];
		cell.isSelected=NO;
		preSelectRow=-1;
		currentRow=-1;
		self.preSelectIndex = nil;
		CGRect oldframe = tableView.frame;
		oldframe.size.height=defaultHeight;
		//[tableView setFrame:oldframe];
	
		[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
	}
}

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
	self.preSelectIndex = nil;
	[_tableView release];
	[datasource release];
    [super dealloc];
}




@end
