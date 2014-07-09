//
//  SearchFilterController.m
//  ElongClient
//
//  Created by 赵岩 on 13-6-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "SearchFilterController.h"

#define kDisplayContainerHeight (43)

@interface SearchFilterController ()

@end

@implementation SearchFilterController

- (void)dealloc
{
    [_cityName release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
 
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil withTitle:@"筛选" style:_NavOnlyBackBtnStyle_];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tabHeight = 75.0;
	
    self.tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectContainerTapped:)] autorelease];
    [self.selectedContainer addGestureRecognizer:self.tapRecognizer];
    self.tapRecognizer.cancelsTouchesInView = NO;
    
    [self.resetButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default4_normal.png"] forState:UIControlStateNormal];
    [self.resetButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default4_press.png"] forState:UIControlStateHighlighted];
    
//    [self.confirmButton setBackgroundColor:RGBACOLOR(249, 133, 34, 1)];
    [self.confirmButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_normal.png"] forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_press.png"] forState:UIControlStateHighlighted];
    
//    UIImage *bgImage = [UIImage imageNamed:@"filter_leftbar_bg.png"];
    self.leftSideBackground.backgroundColor = RGBACOLOR(46, 46, 46, 1);
    
    
    downSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
    downSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE);
    downSplitView.contentMode=UIViewContentModeScaleToFill;
    [self.contentContainer addSubview:downSplitView];
    [downSplitView release];
    
    UIImageView *buttomSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
    buttomSplitView.frame = CGRectMake(0, 9, SCREEN_WIDTH, SCREEN_SCALE);
    buttomSplitView.contentMode=UIViewContentModeScaleToFill;
    [self.buttonContainer addSubview:buttomSplitView];
    [buttomSplitView release];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"取消" Target:self Action:@selector(back)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTab
{
}

- (void)itemWithTagTapped:(NSUInteger)tag
{
}

- (void)reset
{
}

- (void)tabTappedAtIndex:(NSUInteger)index
{
    if (index != _selectedIndex) {
        _selectedIndex = index;
        
        [self updateTab];
    }
}

- (void)confirm
{
    
}

- (void)addItem:(NSString *)title withStartPoint:(CGPoint)startPoint withTag:(NSUInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=[UIColor whiteColor];
//    [button setBackgroundImage:[UIImage noCacheImageNamed:@"filter_mark_board.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(itemTapped:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.minimumFontSize = 10.0f;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0.55, 100, 43)];
    [button setImage:[UIImage noCacheImageNamed:@"filter_delete.png"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(28, 82, 0, 0)];
    //button.center = _touchPoint;
    button.tag = tag;
    [self.displayContainer addSubview:button];
    
    NSUInteger itemCount = [self.displayContainer subviews].count;
    button.frame = CGRectMake(100 * itemCount - 100, 0.55, 100, 43);
    button.alpha = 0;
    button.transform = CGAffineTransformMakeScale(0.001, 0.001);
    
    //button左边加一根线
    if (itemCount>1) {
        UIView *shuSplitView = [[UIView alloc] init];
        shuSplitView.backgroundColor=RGBACOLOR(223, 223, 223, 1);
        shuSplitView.frame = CGRectMake(0, 3, 0.55, 43-3*2);
        shuSplitView.contentMode=UIViewContentModeScaleToFill;
        [button addSubview:shuSplitView];
        [shuSplitView release];
    }
    
    if (self.displayContainer.frame.size.height == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            button.alpha = 1.0f;
            button.transform = CGAffineTransformIdentity;
            self.displayContainer.frame = CGRectMake(self.displayContainer.frame.origin.x, self.displayContainer.frame.origin.y, self.displayContainer.frame.size.width, kDisplayContainerHeight);
            self.displayContainer.contentSize = CGSizeMake(320, kDisplayContainerHeight);
            self.contentContainer.frame = CGRectMake(self.contentContainer.frame.origin.x, self.contentContainer.frame.origin.y + kDisplayContainerHeight, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height - kDisplayContainerHeight);
//            downSplitView.frame = CGRectMake(0, 44+kDisplayContainerHeight-1, SCREEN_WIDTH, 0.55);
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            //button.frame = CGRectMake((72 + 5) * itemCount - 72, 5, 72, 29);
            button.alpha = 1.0f;
            button.transform = CGAffineTransformIdentity;
            if (100 * itemCount> self.displayContainer.frame.size.width)
            {
                self.displayContainer.contentSize = CGSizeMake(100 * itemCount, kDisplayContainerHeight);
                self.displayContainer.contentOffset = CGPointMake(self.displayContainer.contentSize.width - self.displayContainer.frame.size.width, 0);
            }
        }];
    }
    
    
}

- (void)updateItem:(NSString *)title withTag:(NSUInteger)tag
{
    UIButton *button = (UIButton *)[self.displayContainer viewWithTag:tag];
    [button setTitle:title forState:UIControlStateNormal];

    /*
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(0.4, 0.4);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            button.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    }];
     */
}

- (void) deleteItem:(NSUInteger)tag animated:(BOOL)animated{
    BOOL found = NO;
    UIView *foundView = nil;
    for (UIView *view in [self.displayContainer subviews]) {
        if (view.tag == tag) {
            found = YES;
            foundView = view;
        }
        else {
            if (found) {
                [UIView animateWithDuration:0.3 animations:^{
                    view.frame = CGRectMake(view.frame.origin.x - 100, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                }];
            }
        }
    }
    
    NSUInteger itemCount = [self.displayContainer subviews].count;
    if (animated) {
        if (found) {
            itemCount--;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            foundView.alpha = 0.0f;
            foundView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        } completion:^(BOOL finished) {
            [foundView removeFromSuperview];
        }];
    }else{
        [foundView removeFromSuperview];
        itemCount = [self.displayContainer subviews].count;
    }
    
    
//    if ((100 + 5) * itemCount + 5 <= self.displayContainer.frame.size.width) {
//        self.displayContainer.contentSize = CGSizeMake(320, kDisplayContainerHeight);
//    }
    self.displayContainer.contentSize = CGSizeMake((100 + 5) * itemCount + 5, kDisplayContainerHeight);
    
//    NSLog(@"::::::%d",itemCount);
    if (itemCount == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.displayContainer.frame = CGRectMake(self.displayContainer.frame.origin.x, self.displayContainer.frame.origin.y, self.displayContainer.frame.size.width, 0);
            self.contentContainer.frame = CGRectMake(self.contentContainer.frame.origin.x, 0, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height + kDisplayContainerHeight);
//            downSplitView.frame = CGRectMake(0, 44, SCREEN_WIDTH, 0.55);
        }];
    }
}

- (void)deleteItem:(NSUInteger)tag
{
    [self deleteItem:tag animated:YES];
}



- (void)clearItems
{
    [[self.displayContainer viewWithTag:1024] removeFromSuperview];
    [[self.displayContainer viewWithTag:1025] removeFromSuperview];
    [[self.displayContainer viewWithTag:1026] removeFromSuperview];
    [[self.displayContainer viewWithTag:1027] removeFromSuperview];
    [[self.displayContainer viewWithTag:1028] removeFromSuperview];
    [[self.displayContainer viewWithTag:1029] removeFromSuperview];
    
    if (self.displayContainer.frame.size.height != 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.displayContainer.frame = CGRectMake(self.displayContainer.frame.origin.x, self.displayContainer.frame.origin.y, self.displayContainer.frame.size.width, 0);
            self.contentContainer.frame = CGRectMake(self.contentContainer.frame.origin.x, 0, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height + kDisplayContainerHeight);
        }];
    }
}

- (IBAction)itemTapped:(id)sender
{
    UIView *view = (UIView *)sender;
    
    [self itemWithTagTapped:view.tag];
    
    [self deleteItem:view.tag];
    
    [self updateTab];
}

- (IBAction)tabTapped:(id)sender
{
    UIView *view = (UIView *)sender;
    NSUInteger index = view.tag - 1;
    
    [self tabTappedAtIndex:index];
    
    [UIView animateWithDuration:0.2 animations:^(void){
        CGRect newFrame = self.vernier.frame;
        newFrame.origin.y = view.superview.frame.origin.y + view.superview.frame.size.height / 2 - 7;
        self.vernier.frame = newFrame;
    }];
}

- (IBAction)selectContainerTapped:(UITapGestureRecognizer *)sender
{
    //if ([sender isKindOfClass:[UITableView class]]) {
        //self.touchPoint = [sender locationOfTouch:0 inView:self.displayContainer];
    //}
    //NSLog(@"touchX:%f touchY:%f",self.touchPoint.x,self.touchPoint.y);
}

- (IBAction)locationBack:(id)sender
{
}

- (void) back{
    [_filterDelegate searchFilterControllerDidCancel:self];
}

- (IBAction)reset:(id)sender
{
    [self reset];
    [self clearItems];
    [self updateTab];
}

- (IBAction)confirm:(id)sender
{
    [self confirm];
}

@end
