//
//  AboutUsViewController.m
//  ElongClient
//
//  Created by Will Lucky on 12-11-21.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import "AboutUsViewController.h"
#import "FAQ.h"
#import "AdviceAndFeedback.h"
#import "ElongClientSetting.h"
#import "MessageBoxController.h"

static long UMFLastInterval;
static BOOL UMFEnabled;
@interface AboutUsViewController ()
@property (nonatomic,retain) NSArray *array;
@end



@implementation AboutUsViewController
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [umengUFPVC release];
    self.array = nil;
    [super dealloc];
}

- (id)init {
	if (self = [super initWithTopImagePath:@"" andTitle:@"关于我们" style:_NavNoTelStyle_]) {
        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.scrollEnabled = NO;
        [self.view addSubview:tableview];
        [tableview release];
        
        // header
        UIImage *topimage = [UIImage noCacheImageNamed:@"AboutUsTop.png"];
        UIImageView *topimageview = [[UIImageView alloc] initWithImage: topimage];
        topimageview.contentMode = UIViewContentModeCenter;
        topimageview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 190);
        
        NSString *version = [[[NSBundle mainBundle] infoDictionary] safeObjectForKey:(NSString *)kCFBundleVersionKey];
        NSString *versionstring = [NSString stringWithFormat:@"版本号:%@",version];
        UILabel *label = [[UILabel alloc] init];
        label.text = versionstring;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14];
        [topimageview addSubview:label];
        label.frame = CGRectMake(120, 156, 80, 22.5);
        [label release];
        
        tableview.tableHeaderView = topimageview;
        [topimageview release];
        
        // footer
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        UIImage *backImage = [UIImage noCacheImageNamed:@"AboutUsPhone.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:backImage forState:UIControlStateNormal];
        button.frame = CGRectMake((320-backImage.size.width/2)/2, 10, backImage.size.width/2, backImage.size.height/2);
        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(call400) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:button];
        tableview.tableFooterView = footerView;
        [footerView release];
        
        self.array = [NSArray arrayWithObjects:@"常见问题", @"意见反馈", @"设置", @"消息盒子",nil];

        if (UMFEnabled) {
            self.array = [NSArray arrayWithObjects:@"常见问题", @"意见反馈", @"设置", @"消息盒子",@"推荐应用",nil];
        }
        
        if ([[NSDate date] timeIntervalSince1970] - UMFLastInterval > 60 * 60) {
            self.array = [NSArray arrayWithObjects:@"常见问题", @"意见反馈", @"设置", @"消息盒子",nil];
            UMFEnabled = NO;
            
            // UMeng 推荐应用
            umengUFPVC = [UMengUFPViewController alloc];
            umengUFPVC.delegate = self;
            [umengUFPVC initWithTopImagePath:nil andTitle:@"推荐应用" style:_NavNoTelStyle_];
        }
	}
	
	return self;
}


#pragma mark -
#pragma mark UMengUFPViewControllerDelegate
- (void) umengUFPVC:(UMengUFPViewController *)ufpVC statusEnable:(BOOL)enable{
    if (enable) {
        self.array = [NSArray arrayWithObjects:@"常见问题", @"意见反馈", @"设置", @"消息盒子",@"推荐应用",nil];
    }else{
        self.array = [NSArray arrayWithObjects:@"常见问题", @"意见反馈", @"设置", @"消息盒子",nil];
    }
    tableview.scrollEnabled = YES;
    [tableview reloadData];
    
    UMFLastInterval =  [[NSDate date] timeIntervalSince1970];
    UMFEnabled = enable;
    
    umengUFPVC.delegate = nil;
    NSLog(@"%@",(enable?@"UFP success...":@"UFP error...."));
}

- (void)back
{
    [PublicMethods closeSesameInView:self.navigationController.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (UMENG) {
        // UMeng 关于我们
        [MobClick event:Event_AboutUs];
    }
}

- (void)call400 {
	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"电话预订" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"400-666-1166",nil];
	menu.delegate			= self;
	menu.actionSheetStyle	= UIBarStyleBlackTranslucent;
	[menu showInView:self.view];
	[menu release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex==0) {
		if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:@"tel://4006661166"]]) {
			[PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
		}
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.contentView.clipsToBounds = YES;
    
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    coverBtn.frame = CGRectMake(6, 1, SCREEN_WIDTH - 12, 50);
    coverBtn.tag = indexPath.row;
    [coverBtn setBackgroundImage:COMMON_BUTTON_PRESSED_IMG forState:UIControlStateHighlighted];
    [cell.contentView addSubview:coverBtn];
    [coverBtn addTarget:self action:@selector(go2nextpage:) forControlEvents:UIControlEventTouchUpInside];

    UIImage *backimage = [UIImage noCacheImageNamed:@"AboutUsItem.png"];
    UIImageView *backimageview = [[UIImageView alloc] initWithImage:backimage];
    backimageview.frame = CGRectMake(0, 0, 320, 54);
    [cell.contentView addSubview:backimageview];
    [backimageview release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 100, 23)];
    label.text = [self.array safeObjectAtIndex:indexPath.row];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    [label setHighlightedTextColor:[UIColor whiteColor]];
    [cell.contentView addSubview:label];
    [label release];
    
    UIImage *arrawimage = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
    UIImageView *arrawimageview = [[UIImageView alloc] initWithImage:arrawimage];
    arrawimageview.frame = CGRectMake(320-20-arrawimage.size.width, (54-arrawimage.size.height)/2, arrawimage.size.width, arrawimage.size.height);
    [cell.contentView addSubview:arrawimageview];
    [arrawimageview release];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return [cell autorelease];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSInteger row = [indexPath row];
    switch (row) {
        case 0:
        {
            FAQ *faq = [[FAQ alloc] initWithTopImagePath:@"" andTitle:@"常见问题" style:_NavNoTelStyle_];
			[self.navigationController pushViewController:faq animated:YES];
			[faq release];

        }
            break;
        case 1:
        {
            AdviceAndFeedback *advfeed = [[AdviceAndFeedback alloc] initWithTopImagePath:@"" andTitle:@"意见反馈" style:_NavLeftBtnImageStyle_];
			[self.navigationController pushViewController:advfeed animated:YES];
			[advfeed release];

        }
            break;
        case 2:
        {
            ElongClientSetting *setting = [[ElongClientSetting alloc] initWithTopImagePath:@"" andTitle:@"设置" style:_NavNormalBtnStyle_];
			
			[self.navigationController pushViewController:setting animated:YES];
			[setting release];

        }
            break;
        case 3:
        {
            MessageBoxController *controller = [[MessageBoxController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            break;
        case 4:
        {
            if (!umengUFPVC) {
                umengUFPVC = [UMengUFPViewController alloc];
                umengUFPVC.delegate = nil;
                [umengUFPVC initWithTopImagePath:nil andTitle:@"推荐应用" style:_NavNoTelStyle_];
                [self.navigationController pushViewController:umengUFPVC animated:YES];
                [umengUFPVC release];
                umengUFPVC = nil;
            }else{
                [self.navigationController pushViewController:umengUFPVC animated:YES];
                [umengUFPVC release];
                umengUFPVC = nil;
            }
        }
        default:
            break;
    }
}

- (void)go2nextpage:(id)sender {
    UIButton *button = (UIButton*)sender;
    switch (button.tag) {
        case 0:
        {
            FAQ *faq = [[FAQ alloc] initWithTopImagePath:@"" andTitle:@"常见问题" style:_NavNoTelStyle_];
			[self.navigationController pushViewController:faq animated:YES];
			[faq release];
            
        }
            break;
        case 1:
        {
            AdviceAndFeedback *advfeed = [[AdviceAndFeedback alloc] initWithTopImagePath:@"" andTitle:@"意见反馈" style:_NavLeftBtnImageStyle_];
			[self.navigationController pushViewController:advfeed animated:YES];
			[advfeed release];
            
        }
            break;
        case 2:
        {
            ElongClientSetting *setting = [[ElongClientSetting alloc] initWithTopImagePath:@"" andTitle:@"设置" style:_NavNormalBtnStyle_];
			
			[self.navigationController pushViewController:setting animated:YES];
			[setting release];
            
        }
            break;
        case 3:
        {
            MessageBoxController *controller = [[MessageBoxController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            break;
        case 4:
        {
            if (!umengUFPVC) {
                umengUFPVC = [UMengUFPViewController alloc];
                umengUFPVC.delegate = nil;
                [umengUFPVC initWithTopImagePath:nil andTitle:@"推荐应用" style:_NavNoTelStyle_];
                [self.navigationController pushViewController:umengUFPVC animated:YES];
                [umengUFPVC release];
                umengUFPVC = nil;
            }else{
                [self.navigationController pushViewController:umengUFPVC animated:YES];
                [umengUFPVC release];
                umengUFPVC = nil;
            }
        }
            break;
    }
}

@end
