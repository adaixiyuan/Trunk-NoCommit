//
//  CrashDetailVC.m
//  ElongClient
//
//  Created by bruce on 14-3-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CrashDetailVC.h"
#import "ShareTools.h"

// ==================================================================
// 布局参数
// ==================================================================
//
#define kCrashDetailCopyButtonHeight                    50

//控件间距
#define	kCrashDetailTableViewHMargin					10
#define	kCrashDetailTableViewVMargin					10
#define	kCrashDetailTableViewMiddleVMargin				20
#define kCrashDetailCellHMargin                         10
#define kCrashDetailCellVMargin                         5

//控件字体
#define	kCrashDetailContentLabelFont                    [UIFont systemFontOfSize:10.0f]
#define	kCrashDetailCrashTitleLabelFont                 [UIFont boldSystemFontOfSize:16.0f]

@implementation CrashDetailVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:RGBACOLOR(245, 245, 245, 1.0)];
    
    // 创建Root View的子视图
	[self setupViewRootSubs:[self view]];
}


- (void) shareInfo
{
    if ([[ServiceConfig share] monkeySwitch])
    {
        // 开着monkey时不发生事件
        return;
    }
    
    NSString *crashDesc = [_crashDetail description];
    
    if ((crashDesc != nil) && ([crashDesc length] > 0))
    {
        if (STRINGHASVALUE(_crashTime))
        {
             NSString *stringToShare = [NSString stringWithFormat:@"%@\r\n%@",_crashTime,crashDesc];
            
            
            ShareTools *shareTools = [ShareTools shared];
            shareTools.contentViewController = self;
            shareTools.contentView = nil;
            shareTools.needLoading = YES;
            
            shareTools.weiBoContent = stringToShare;
            shareTools.msgContent = stringToShare;
            shareTools.mailTitle = [NSString stringWithFormat:@"Crash 信息：%@",_crashTime];
            shareTools.mailContent = stringToShare;
            [shareTools  showItems];
            
        }
    }
    
}

//
- (void)copyButtonPressed:(id)sender
{
    NSString *crashDesc = [_crashDetail description];
    
    if ((crashDesc != nil) && ([crashDesc length] > 0))
    {
        NSString *stringToCopy = crashDesc;
        
        if (STRINGHASVALUE(_crashTime))
        {
            NSString *crashStepContent = @"";
            if (STRINGHASVALUE(_crashStepContent))
            {
                crashStepContent = [NSString stringWithFormat:@"Crash步骤:\r\n%@",_crashStepContent];
            }
            
            stringToCopy = [NSString stringWithFormat:@"%@\r\n%@\r\n\r\n%@",_crashTime,crashDesc,crashStepContent];
        }
        
        [[UIPasteboard generalPasteboard] setPersistent:YES];
        
        [[UIPasteboard generalPasteboard] setValue:stringToCopy forPasteboardType:[UIPasteboardTypeListString safeObjectAtIndex:0]];
        
        [Utils alert:@"已复制到剪贴板"];
    }
}



// =======================================================================
// 布局函数
// =======================================================================
// 创建Root View的子界面
- (void)setupViewRootSubs:(UIView *)viewParent
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享   " style:UIBarButtonItemStylePlain target:self action:@selector(shareInfo)];
    
    // =======================================================================
	// TableView
	// =======================================================================
    UITableView *tableViewInfo = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [tableViewInfo setFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT-44)];
    [tableViewInfo setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableViewInfo setSeparatorColor:[UIColor clearColor]];
    [tableViewInfo setDataSource:self];
    [tableViewInfo setDelegate:self];
    [tableViewInfo setShowsVerticalScrollIndicator:NO];
    [tableViewInfo setBackgroundColor:[UIColor clearColor]];
    
    //保存
    [viewParent addSubview:tableViewInfo];
	
}



// 创建crash详情子界面
- (void)setupTableCellIntroduceSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
	// 子窗口高宽
	NSInteger spaceXStart = 0;
	NSInteger spaceXEnd = pViewSize->width;
	NSInteger subsHeight = 0;
	NSInteger spaceYStart = 0;
	
	/* 间隔 */
	spaceXStart += kCrashDetailTableViewHMargin;
	spaceXEnd -= kCrashDetailTableViewHMargin;
	spaceYStart += kCrashDetailTableViewVMargin;
	
    // =======================================================================
	// crash详情 Label
	// =======================================================================
    NSString *crashDesc = [_crashDetail description];
    
    
    if ((crashDesc != nil) && ([crashDesc length] > 0))
    {
        CGSize introductionSize = [crashDesc sizeWithFont:kCrashDetailContentLabelFont
                                          constrainedToSize:CGSizeMake(spaceXEnd - spaceXStart, CGFLOAT_MAX)
                                              lineBreakMode:NSLineBreakByWordWrapping];

        UITextView *textInfo = [[UITextView alloc] initWithFrame:CGRectZero];
        [textInfo setBackgroundColor:[UIColor clearColor]];
        [textInfo setEditable:NO];
        [textInfo setScrollEnabled:NO];
        [textInfo setFont:kCrashDetailContentLabelFont];
        [textInfo setTextColor:[UIColor blackColor]];
        [textInfo setAutoresizesSubviews:YES];
        [textInfo setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [textInfo setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [textInfo setFrame:CGRectMake(spaceXStart, spaceYStart, spaceXEnd - spaceXStart, introductionSize.height+5)];
        [textInfo setText:crashDesc];
        
        // 保存
        [viewParent addSubview:textInfo];
        
        // 调整子窗口高宽
        spaceYStart += textInfo.frame.size.height;
        
        // 间隔
        spaceYStart += kCrashDetailTableViewMiddleVMargin*4;
        
    }
    
    // =======================================================================
	// crash步骤
	// =======================================================================
    NSString *stepKey = [NSString stringWithFormat:@"%@_Step",_crashTime];
    NSArray *arraySteps = [_crashSteps objectForKey:stepKey];
    
    if (ARRAYHASVALUE(arraySteps))
    {
        NSString *stepTitle = @"Crash步骤：";
        CGSize titleSize = [stepTitle sizeWithFont:kCrashDetailCrashTitleLabelFont];
        
        // 创建Label
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelTitle setFrame:CGRectMake(spaceXStart, spaceYStart, titleSize.width, titleSize.height)];
        [labelTitle setBackgroundColor:[UIColor clearColor]];
        [labelTitle setFont:kCrashDetailCrashTitleLabelFont];
        [labelTitle setText:stepTitle];
        
        // 调整子窗口高宽
        spaceYStart += titleSize.height;
        
        // 保存
        [viewParent addSubview:labelTitle];
        
        // 间隔
        spaceYStart += kCrashDetailCellVMargin;
        
        
        // =======================================================================
        // crash步骤内容
        // =======================================================================
        NSString *crashStepContent = [arraySteps description];
        
        // 保存
        [self setCrashStepContent:crashStepContent];
        
        
        if ((crashStepContent != nil) && ([crashStepContent length] > 0))
        {
            CGSize contentSize = [crashStepContent sizeWithFont:kCrashDetailContentLabelFont
                                            constrainedToSize:CGSizeMake(spaceXEnd - spaceXStart, CGFLOAT_MAX)
                                                lineBreakMode:NSLineBreakByWordWrapping];
            
            UITextView *textInfo = [[UITextView alloc] initWithFrame:CGRectZero];
            [textInfo setFrame:CGRectMake(spaceXStart, spaceYStart, spaceXEnd - spaceXStart, contentSize.height+5)];
            [textInfo setBackgroundColor:[UIColor clearColor]];
            [textInfo setEditable:NO];
            [textInfo setScrollEnabled:NO];
            [textInfo setFont:kCrashDetailContentLabelFont];
            [textInfo setTextColor:[UIColor blackColor]];
            [textInfo setAutoresizesSubviews:YES];
            [textInfo setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
            [textInfo setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [textInfo setText:crashStepContent];
            
            // 保存
            [viewParent addSubview:textInfo];
            
            // 调整子窗口高宽
            spaceYStart += textInfo.frame.size.height;
            // 间隔
            spaceYStart += kCrashDetailTableViewMiddleVMargin;
        }
    }
    
    // 间隔
    spaceYStart += kCrashDetailTableViewMiddleVMargin;
    
    // =======================================================================
    // 复制按钮
    // =======================================================================
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    copyButton.frame = CGRectMake(spaceXStart, spaceYStart, spaceXEnd-spaceXStart, kCrashDetailCopyButtonHeight);
    [copyButton setTitle:@"全部复制" forState:UIControlStateNormal];
    copyButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [copyButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
    [copyButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
    [copyButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_disable.png"] forState:UIControlStateDisabled];
    [copyButton addTarget:self action:@selector(copyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewParent addSubview:copyButton];
    
    spaceYStart += kCrashDetailCopyButtonHeight;
    
    spaceYStart += kCrashDetailTableViewVMargin;
    
    
	// =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
	subsHeight = spaceYStart;
    pViewSize->height = subsHeight;
    if(viewParent != nil)
    {
        [viewParent setViewHeight:subsHeight];
    }
}

// =======================================================================
// TabelViewDataSource的代理函数
// =======================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 父窗口尺寸
    CGRect parentFrame = [tableView frame];
    
	// Item
	NSString *reusedIdentifer = @"CrashDetailTCID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifer];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:reusedIdentifer];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
		
		// 创建contentView
        CGSize contentViewSize = CGSizeMake(parentFrame.size.width, 0);
        [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
        [self setupTableCellIntroduceSubs:[cell contentView] inSize:&contentViewSize];
	}
	
	return cell;
}

// =======================================================================
// TableViewDelegate的代理函数
// =======================================================================
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 父窗口尺寸
    CGRect parentFrame = [tableView frame];
    
	// Item
	CGSize contentViewSize = CGSizeMake(parentFrame.size.width, 0);
	[self setupTableCellIntroduceSubs:nil inSize:&contentViewSize];
	
	return contentViewSize.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
