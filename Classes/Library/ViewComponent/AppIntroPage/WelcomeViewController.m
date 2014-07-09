//
//  WelcomeViewController.m
//  ElongClient
//
//  Created by Will Lucky on 12-10-24.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import "WelcomeViewController.h"
#import "ElongClientAppDelegate.h"
#import "HomeViewController.h"
//static NSUInteger kNumberOfPages = 3;
#define PAGEGAP 30

@interface WelcomeViewController()
@property (nonatomic,retain) NSMutableArray *starsArray;
@property (nonatomic,retain) NSMutableArray *marksArray;
@property (nonatomic,retain) NSMutableArray *promotionArray;
@property (nonatomic,retain) NSMutableArray *coinFallingArray;
@property (nonatomic,retain) NSMutableArray *coinDropArray;
@property (nonatomic,retain) NSMutableArray *textArray;
@end

@implementation WelcomeViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [imageNameArray release];
    self.starsArray = nil;
    self.marksArray = nil;
    self.promotionArray = nil;
    self.coinDropArray = nil;
    self.coinFallingArray = nil;
    self.textArray = nil;
    [super dealloc];
}

- (id)init {
	if (self = [super init]) {
        imageNameArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < 3; i++) {
            [imageNameArray addObject:[NSString stringWithFormat:@"welcome_%.fx%.f_%d.png",SCREEN_WIDTH,SCREEN_HEIGHT,i]];
        }
        lastIndex = -1;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
    [self.view addSubview:m_scrollView];
    [m_scrollView release];
    m_scrollView.pagingEnabled = YES;
    m_scrollView.contentSize = CGSizeMake(m_scrollView.frame.size.width * imageNameArray.count + 1, m_scrollView.frame.size.height);
    m_scrollView.showsHorizontalScrollIndicator = NO;
    m_scrollView.showsVerticalScrollIndicator = NO;
    m_scrollView.scrollsToTop = NO;
    m_scrollView.bounces = NO;
    m_scrollView.delegate = self;
	m_scrollView.backgroundColor = [UIColor whiteColor];
    [self loadScrollViewWithPage];

    [self dealWithPageIndex:0];
}

- (void)loadScrollViewWithPage{
    self.textArray = [NSMutableArray array];
    for (int i = 0; i < imageNameArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(m_scrollView.frame.size.width * i, 0, m_scrollView.frame.size.width, m_scrollView.frame.size.height)];
        imageView.image = [UIImage noCacheImageNamed:[imageNameArray objectAtIndex:i]];
        [m_scrollView addSubview:imageView];
        [imageView release];
        
        float ymove = SCREEN_4_INCH ? 44 : 0;
        float xmove = i * SCREEN_WIDTH;
        if (i == 0) {
            
            // 星星
            self.starsArray = [NSMutableArray array];
            float starPoi[7][4] = {
                {39 + xmove, 105 + ymove, 17, 17},  // 0
                {96 + xmove, 79 + ymove, 24, 24},   // 1
                {35 + xmove, 184 + ymove, 14, 14},  // 2
                {262 + xmove, 100 + ymove, 17, 17}, // 3
                {36 + xmove, 334 + ymove, 17, 17},  // 4
                {254 + xmove, 373 + ymove, 24, 24}, // 5
                {275 + xmove, 366 + ymove, 17, 17}  // 6
            };
            
            for (int i = 0; i < 7; i++) {
                UIImageView *starView = [[UIImageView alloc] initWithFrame:CGRectMake(starPoi[i][0],starPoi[i][1],starPoi[i][2],starPoi[i][3])];
                starView.image = [UIImage noCacheImageNamed:@"welcome_star.png"];
                [self.starsArray addObject:starView];
                [starView release];
                [m_scrollView addSubview:starView];
                //starView.layer.transform = CATransform3DMakeScale(0, 0, 1.0);
            }

            
            // 地标
            self.marksArray = [NSMutableArray array];
            float markPoi[19][4] = {
                {120 + xmove, 128 + ymove, 11, 17}, // 0
                {189 + xmove, 140 + ymove, 11, 17}, // 1
                {169 + xmove, 152 + ymove, 11, 17}, // 2
                {127 + xmove, 163 + ymove, 11, 17}, // 3
                {100 + xmove, 161 + ymove, 11, 17}, // 4
                {96 + xmove, 189 + ymove, 11, 17},  // 5
                {150 + xmove, 183 + ymove, 11, 17}, // 6
                {187 + xmove, 171 + ymove, 11, 17}, // 7
                {249 + xmove, 175 + ymove, 11, 17}, // 8
                {129 + xmove, 208 + ymove, 11, 17}, // 9
                {113 + xmove, 230 + ymove, 11, 17}, // 10
                {164 + xmove, 232 + ymove, 11, 17}, // 11
                {175 + xmove, 255 + ymove, 11, 17}, // 12
                {186 + xmove, 282 + ymove, 11, 17}, // 13
                {154 + xmove, 282 + ymove, 11, 17}, // 14
                {217 + xmove, 283 + ymove, 11, 17}, // 15
                {187 + xmove, 312 + ymove, 11, 17}, // 16
                {158 + xmove, 335 + ymove, 11, 17}, // 17
                {269 + xmove, 227 + ymove, 11, 17}, // 18
            };
            
            for (int i = 0; i < 19; i++) {
                UIImageView *markView = [[UIImageView alloc] initWithFrame:CGRectMake(markPoi[i][0], markPoi[i][1], markPoi[i][2], markPoi[i][3])];
                markView.image = [UIImage noCacheImageNamed:@"welcome_mark.png"];
                [self.marksArray addObject:markView];
                [markView release];
                
                [m_scrollView addSubview:markView];
                markView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            }
            
            //
            UIImageView *textView = [[UIImageView alloc] initWithFrame:CGRectMake(40 + (i + 1) * SCREEN_WIDTH, ymove + 30, 240, 22)];
            textView.image = [UIImage noCacheImageNamed:@"welcome_text_0.png"];
            [self.textArray addObject:textView];
            [textView release];
            [m_scrollView addSubview:textView];
            
        }else if(i == 1){
            self.promotionArray = [NSMutableArray array];
            UIImageView *promotionView0 = [[UIImageView alloc] initWithFrame:CGRectMake(61 + xmove, 88 + ymove, 67, 51)];
            promotionView0.image = [UIImage noCacheImageNamed:@"welcome_cash.png"];
            [self.promotionArray addObject:promotionView0];
            [promotionView0 release];
            
            UIImageView *promotionView1 = [[UIImageView alloc] initWithFrame:CGRectMake(117 + xmove, 85 + ymove, 74, 57)];
            promotionView1.image = [UIImage noCacheImageNamed:@"welcome_gift.png"];
            [self.promotionArray addObject:promotionView1];
            [promotionView1 release];
            
            UIImageView *promotionView2 = [[UIImageView alloc] initWithFrame:CGRectMake(187 + xmove, 79 + ymove, 62, 64)];
            promotionView2.image = [UIImage noCacheImageNamed:@"welcome_limit.png"];
            [self.promotionArray addObject:promotionView2];
            [promotionView2 release];
            
            UIImageView *promotionView3 = [[UIImageView alloc] initWithFrame:CGRectMake(79 + xmove, 145 + ymove, 63, 51)];
            promotionView3.image = [UIImage noCacheImageNamed:@"welcome_promotion.png"];
            [self.promotionArray addObject:promotionView3];
            [promotionView3 release];
            
            UIImageView *promotionView4 = [[UIImageView alloc] initWithFrame:CGRectMake(146 + xmove, 144 + ymove, 85, 55)];
            promotionView4.image = [UIImage noCacheImageNamed:@"welcome_lm.png"];
            [self.promotionArray addObject:promotionView4];
            [promotionView4 release];
            
            for (UIImageView *view in self.promotionArray) {
                [m_scrollView addSubview:view];
                view.transform = CGAffineTransformMakeScale(0.01, 0.01);
            }
            
            UIImageView *textView = [[UIImageView alloc] initWithFrame:CGRectMake(40 + (i + 1) * SCREEN_WIDTH, ymove + 30, 240, 22)];
            textView.image = [UIImage noCacheImageNamed:@"welcome_text_1.png"];
            [self.textArray addObject:textView];
            [textView release];
            [m_scrollView addSubview:textView];
        }else if(i == 2){
            self.coinDropArray = [NSMutableArray array];
            self.coinFallingArray = [NSMutableArray array];
            
            UIImageView *dropView0 = [[UIImageView alloc] initWithFrame:CGRectMake(147 + xmove, 367 + ymove, 41, 26)];
            dropView0.image = [UIImage noCacheImageNamed:@"welcome_dropCoin_0.png"];
            [self.coinDropArray addObject:dropView0];
            [dropView0 release];
            
            UIImageView *dropView1 = [[UIImageView alloc] initWithFrame:CGRectMake(95 + xmove, 375 + ymove, 34, 20)];
            dropView1.image = [UIImage noCacheImageNamed:@"welcome_dropCoin_1.png"];
            [self.coinDropArray addObject:dropView1];
            [dropView1 release];
            
            UIImageView *dropView2 = [[UIImageView alloc] initWithFrame:CGRectMake(174 + xmove, 369 + ymove, 41, 24)];
            dropView2.image = [UIImage noCacheImageNamed:@"welcome_dropCoin_2.png"];
            [self.coinDropArray addObject:dropView2];
            [dropView2 release];
            
            UIImageView *dropView3 = [[UIImageView alloc] initWithFrame:CGRectMake(127 + xmove, 370 + ymove, 42, 26)];
            dropView3.image = [UIImage noCacheImageNamed:@"welcome_dropCoin_3.png"];
            [self.coinDropArray addObject:dropView3];
            [dropView3 release];
            
            UIImageView *dropView4 = [[UIImageView alloc] initWithFrame:CGRectMake(109 + xmove, 363 + ymove, 34, 21)];
            dropView4.image = [UIImage noCacheImageNamed:@"welcome_dropCoin_4.png"];
            [self.coinDropArray addObject:dropView4];
            [dropView4 release];
            
            UIImageView *dropView5 = [[UIImageView alloc] initWithFrame:CGRectMake(131 + xmove, 356 + ymove, 35, 20)];
            dropView5.image = [UIImage noCacheImageNamed:@"welcome_dropCoin_5.png"];
            [self.coinDropArray addObject:dropView5];
            [dropView5 release];
            
            UIImageView *dropView6 = [[UIImageView alloc] initWithFrame:CGRectMake(152 + xmove, 354 + ymove, 35, 22)];
            dropView6.image = [UIImage noCacheImageNamed:@"welcome_dropCoin_6.png"];
            [self.coinDropArray addObject:dropView6];
            [dropView6 release];
            
            for (UIImageView *view in self.coinDropArray) {
                [m_scrollView addSubview:view];
                view.alpha = 0;
            }
            
            for (int i = 0; i < 7; i++) {
                UIImageView *fallingView = [[UIImageView alloc] initWithFrame:CGRectMake(152 + xmove, 229 + ymove, 30, 30)];
                fallingView.image = [UIImage noCacheImageNamed:@"welcome_fallingCoin_0.png"];
                [self.coinFallingArray addObject:fallingView];
                [fallingView release];
            }
            
            
            for (UIImageView *view in self.coinFallingArray) {
                [m_scrollView addSubview:view];
                view.alpha = 0;
            }
            
            UIImageView *textView = [[UIImageView alloc] initWithFrame:CGRectMake(40 + (i + 1) * SCREEN_WIDTH, ymove + 30, 240, 22)];
            textView.image = [UIImage noCacheImageNamed:@"welcome_text_2.png"];
            [self.textArray addObject:textView];
            [textView release];
            [m_scrollView addSubview:textView];
            
            
            closetre = [UIButton buttonWithType:UIButtonTypeCustom];
            closetre.frame = CGRectMake(110 + xmove, 418 + ymove, 94, 32);
            [closetre setBackgroundImage:[UIImage noCacheImageNamed:@"welcome_startbtn.png"] forState:UIControlStateNormal];
            [closetre setBackgroundImage:[UIImage noCacheImageNamed:@"welcome_startbtn_h.png"] forState:UIControlStateHighlighted];
            [closetre addTarget:self action:@selector(closescrollview) forControlEvents:UIControlEventTouchUpInside];
            [m_scrollView addSubview:closetre];
            closetre.hidden = YES;
        }
    }
}


-(void)closescrollview {
	ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate.startup addwelclomeview];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int i = scrollView.contentOffset.x;
    if (i == 320 * (imageNameArray.count - 1) + 1) {
        [self closescrollview];
    }
    
    NSInteger page = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;

    [self dealWithPageIndex:page];
}

- (void) dealWithPageIndex:(NSInteger)index{
    if (lastIndex == index) {
        return;
    }
    lastIndex = index;
    UIImageView *textView = [self.textArray objectAtIndex:index];
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
        textView.frame = CGRectMake(40 + index * SCREEN_WIDTH, textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    switch (index) {
        case 0:{
            for (UIImageView *view in self.starsArray) {
                if ([view.layer animationForKey:@"Shark"]) {
                    return;
                }
            }
            
            for (UIImageView *view in self.starsArray) {
                CABasicAnimation *sharkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                sharkAnimation.fromValue = [NSNumber numberWithFloat:0];
                sharkAnimation.toValue = [NSNumber numberWithFloat:1.0];
                sharkAnimation.duration = 0.6;
                sharkAnimation.repeatCount = INFINITY;
                sharkAnimation.removedOnCompletion = NO;
                sharkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                sharkAnimation.beginTime = (arc4random() % 6)/10.0f;
                sharkAnimation.autoreverses = YES;
                [view.layer addAnimation:sharkAnimation forKey:@"Shark"];
            }
            
            for (UIImageView *view in self.marksArray) {
                [UIView animateWithDuration:0.4 delay:(arc4random() % 8)/10.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                } completion:^(BOOL finished) {
                    
                }];
            }
            
        }
            break;
        case 1:{
            int i = 0;
            for (UIImageView *view in self.promotionArray) {
                [UIView animateWithDuration:0.4 delay:0.1 * i options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                } completion:^(BOOL finished) {
                    
                }];
                i++;
            }

        }
            break;
        case 2:{
            float ymove = SCREEN_4_INCH ? 44 : 0;
            float xmove = index * SCREEN_WIDTH;
            for (int i = 0; i < self.coinFallingArray.count; i++) {
                UIImageView *view = [self.coinFallingArray objectAtIndex:i];
                [UIView animateWithDuration:0.2 delay:i * 0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                    view.alpha = 1.0;
                    view.frame = CGRectMake(xmove + 137, ymove + 266, 30, 30);
                } completion:^(BOOL finished) {
                    view.image = [UIImage noCacheImageNamed:@"welcome_fallingCoin_1.png"];
                    [UIView animateWithDuration:0.18 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        view.frame = CGRectMake(xmove + 156, ymove + 285, 30, 30);
                    } completion:^(BOOL finished) {
                        view.image = [UIImage noCacheImageNamed:@"welcome_fallingCoin_2.png"];
                        [UIView animateWithDuration:0.14 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                            view.frame = CGRectMake(xmove + 150, ymove + 317, 30, 30);
                        } completion:^(BOOL finished) {
                            view.image = [UIImage noCacheImageNamed:@"welcome_fallingCoin_3.png"];
                            [UIView animateWithDuration:0.08 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                                view.frame = CGRectMake(xmove + 140, ymove + 349, 30, 30);
                            } completion:^(BOOL finished) {
                                view.image = [UIImage noCacheImageNamed:@"welcome_fallingCoin_0.png"];
                                view.frame = CGRectMake(xmove + 152, ymove + 229, 30, 30);
                                view.hidden = YES;
                                UIImageView *dropView = [self.coinDropArray objectAtIndex:i];
                                dropView.alpha = 1;
                                if (i == self.coinFallingArray.count - 1) {
                                    closetre.hidden = NO;
                                }
                            }];
                        }];
                    }];
                }];
            }
            break;
        }
        default:
            break;
    }
}


@end
