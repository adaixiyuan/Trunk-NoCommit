    //
//  WBSendViewController.m
//  Elong_iPad
//
//  Created by Wang Shuguang on 12-8-9.
//  Copyright 2012 elong. All rights reserved.
//

#import "WBSendViewController.h"
#import <QuartzCore/QuartzCore.h> 
#import "ShareKit.h"
#import "ShareTools.h"

#define WBSHARETEXT_HEIGHT 200
#define WBSHARETOP_PADDING 20
#define WBSHAREBOTTOM_PADDING 20
#define WBSHARETEXT_LENGTH 140

@implementation WBSendViewController
@synthesize weiboStyle;

-(id)init{
    self = [super initWithTitle:@"编辑微博信息" style:NavBarBtnStyleOnlyBackBtn];
    if(self){
        self.navigationItem.hidesBackButton  = YES;
        
        self.view.backgroundColor = [UIColor whiteColor];
        UIView *singleTapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-64)];
        if (SCREEN_4_INCH) {
            singleTapView.frame = CGRectMake(0, 0, 320,SCREEN_HEIGHT-64);
        }
        
        [self.view addSubview:singleTapView];
        [singleTapView release];
        
        UIBarButtonItem *cancelBarItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"取消" Target:self Action:@selector(cancel:)];
        self.navigationItem.leftBarButtonItem = cancelBarItem;
        
        UIBarButtonItem *publishBarItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"发布" Target:self Action:@selector(sendWeiBo:)];
        self.navigationItem.rightBarButtonItem =publishBarItem;
        
        //	UIImage *bgImage =[UIImage imageNamed:@"textview_bg.png"];
        //	UIImageView *textViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, 300, 140)];
        //	textViewBg.image = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
        //	[self.view addSubview:textViewBg];
        //	[textViewBg release];
        
        textBox = [[UITextView alloc] initWithFrame:CGRectMake(10, 16, 300, 140)];
        textBox.backgroundColor = [UIColor clearColor];
        textBox.font = [UIFont systemFontOfSize:14.0f];
        textBox.delegate = self;
        [self.view addSubview:textBox];
        [textBox release];
    	
        textTips = [[UILabel alloc] initWithFrame:CGRectMake(24, 156, 280, 30)];
        textTips.backgroundColor = [UIColor clearColor];
        textTips.textColor = [UIColor lightGrayColor];
        textTips.font = [UIFont systemFontOfSize:14.0f];
        textTips.textAlignment = UITextAlignmentRight;
        [self.view addSubview:textTips];
        
        imageBox = [[UIImageView alloc] initWithFrame:CGRectMake(22, 206, 276, 202)];
        [self.view addSubview:imageBox];
        [imageBox release];
        [imageBox setImage:[UIImage imageNamed:@"noImage_replace.png"]];
        
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview:activityView];
        [activityView setCenter:CGPointMake(160, 206+imageBox.frame.size.height/2)];
        [activityView release];
        
        removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [removeBtn setImage:[UIImage noCacheImageNamed:@"closeRoundButton.png"] forState:UIControlStateNormal];
        [removeBtn setFrame:CGRectMake(0, 0, 57, 57)];
        [removeBtn setCenter:CGPointMake(298, 206)];
        [removeBtn addTarget:self action:@selector(onRemoveButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:removeBtn];
        
        
        
        //	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        //	singleTap.numberOfTapsRequired = 1;
        //	singleTap.numberOfTouchesRequired = 1;
        //	[singleTapView addGestureRecognizer:singleTap];
        //	[singleTap release];
        
        
        //20秒后出不来，移除loading图标
        [self performSelector:@selector(stopLoading) withObject:nil afterDelay:20];
    }
    return self;
}

-(void)back{
    [self cancel:nil];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
}

- (void) stopLoading{
    [activityView stopAnimating];
    ShareTools *shareTools = [ShareTools shared];
    if(shareTools.needLoading){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImageDownLoaded" object:nil];
    }
    rbtn.enabled = YES;
    imageBox.alpha = 0.0f;
    imageBox = nil;
    removeBtn.alpha = 0.0f;
}

//- (void) singleTap:(UIGestureRecognizer *)gesture{
//}

- (void) onRemoveButtonTouched:(id)sender{
	[activityView stopAnimating];
    ShareTools *shareTools = [ShareTools shared];
    if(shareTools.needLoading){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImageDownLoaded" object:nil];
    }
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	imageBox.alpha = 0.0f;
	removeBtn.alpha = 0.0f;
	[UIView commitAnimations];
	
	imageBox = nil;
	rbtn.enabled = YES;

}

- (void) cancel:(id)sender{
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void) sendWeiBo:(id) sender{
    ShareTools *shareTools = [ShareTools shared];
	if (weiboStyle == Sina) {
		if (imageBox == nil) {
            shareTools.hotelImage = nil;
		}
        shareTools.weiBoContent = textBox.text;
        [[ShareKit instance] shareSina];
	}else if (weiboStyle == Tencent) {
		if (imageBox == nil) {
            shareTools.hotelImage = nil;
		}
        shareTools.weiBoContent = textBox.text;
        [[ShareKit instance] shareTencent];
	}
    
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }

}

- (void) setImageBox:(UIImage *)image{
    ShareTools *shareTools = [ShareTools shared];
	if (!image) {
        if(shareTools.needLoading){
            rbtn.enabled = NO;
            [activityView startAnimating];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setImageByNotification) name:@"ImageDownLoaded" object:nil];
            return;
        }else{
            [self stopLoading];
        }
	}
	else {
//		removeBtn.hidden = NO;
		rbtn.enabled = YES;
		[activityView stopAnimating];
	}

	imageBox.image = image;
}

-(void)setImageByNotification{
    rbtn.enabled = YES;
    [activityView stopAnimating];
    ShareTools *shareTools = [ShareTools shared];
    imageBox.image = shareTools.hotelImage;
    if(shareTools.needLoading){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImageDownLoaded" object:nil];
    }
}

- (void) setContent:(NSString *)txt{ 
	textBox.text = [NSString stringWithFormat:@"%@",txt];
	textTips.text = [NSString stringWithFormat:@"还可输入 %d 字",WBSHARETEXT_LENGTH - textBox.text.length];
}

#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text length]==0) {
		return YES;
	}
	if (textBox.text.length >= WBSHARETEXT_LENGTH) {
		//textField.text = [textField.text substringToIndex:11];
		return NO;
	}
	return YES;
}


- (void) textViewDidChange:(UITextView *)textView{
	textTips.text = [NSString stringWithFormat:@"可输入还剩 %d 字", WBSHARETEXT_LENGTH - [textView.text length]];
}


- (void) textFieldDidEndEditing:(UITextView *)textView{
	if (textBox.text.length >=WBSHARETEXT_LENGTH) {
		textBox.text = [textBox.text substringToIndex:WBSHARETEXT_LENGTH];
		//return NO;
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[textBox resignFirstResponder];
}


@end
