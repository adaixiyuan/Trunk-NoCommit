//
//  HomeItemView.m
//  Home
//
//  Created by Dawn on 13-12-4.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "HomeItemView.h"



static BOOL HomeItemViewAction = NO;
static NSMutableArray *HomeItemViewlongpressActions;
@interface HomeItemView()
@property (nonatomic,retain) HomeItem *dataSource;
@property (nonatomic,retain) UIButton *deleteBtn;
@property (nonatomic,assign) CGPoint startPoint;
@property (nonatomic,assign) BOOL editing;
@property (nonatomic,assign) UIImageView *bgView;
@property (nonatomic,retain) UIView *markView;

@end

@implementation HomeItemView

- (void) dealloc{
    self.dataSource = nil;
    self.deleteBtn = nil;
    self.delegate = nil;
    self.subitems = nil;
    self.longPressGesture = nil;
    self.singleTap = nil;
    self.item = nil;
    self.bgView = nil;
    self.markView = nil;
    [super dealloc];
}

- (id)initWithDataSource:(HomeItem *)item
{
    self = [super initWithFrame:CGRectMake(item.x, item.y, item.width, item.height)];
    if (self) {
        if (!HomeItemViewlongpressActions) {
            HomeItemViewlongpressActions = [[NSMutableArray alloc] init];
        }
        self.dataSource = item;
        self.tag = item.tag;
        self.item = item;
        // 拥有subitem
        if (item.scrollable) {
            if (item.subitems) {
                self.subitems = item.subitems;
            }
        }
        
        // background
        if (!item.scrollable && !item.actions && !item.action) {
            HomeAdView *homeAdView = [[HomeAdView alloc] initWithFrame:self.bounds];
            [homeAdView loadAdsWithUrls:[NSArray arrayWithObject:@""] defaultImage:[UIImage imageNamed:item.background]];
            [self addSubview:homeAdView];
            self.clipsToBounds = YES;
            [homeAdView release];
            self.adView = homeAdView;
            homeAdView.timeInterval = item.timeInterval;
            homeAdView.animationInterval = item.animationInterval;
            
            self.markView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
            self.markView.backgroundColor = RGBACOLOR(0, 0, 0, 1);
            [self insertSubview:self.markView atIndex:0];
        }else{
            if (item.background && !item.actions) {
                UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.bounds];
                bgView.contentMode = UIViewContentModeScaleAspectFill;
                bgView.clipsToBounds = YES;
                [self addSubview:bgView];
                [bgView release];
                bgView.image = [UIImage imageNamed:item.background];
                bgView.userInteractionEnabled = YES;
                self.bgView = bgView;
                
                self.markView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
                self.markView.backgroundColor = RGBACOLOR(0, 0, 0, 1);
                [self insertSubview:self.markView atIndex:0];
            }
        }

        // delete button
        if (item.deletable) {
            self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.deleteBtn setImage:[UIImage imageNamed:@"home_item_delete.png"] forState:UIControlStateNormal];
            self.deleteBtn.frame = CGRectMake(self.frame.size.width - 32, 0, 32, 32);
            [self addSubview:self.deleteBtn];
            self.deleteBtn.alpha = 0.0f;
            [self.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        // long press
        if (item.scrollable) {
            UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, item.width, item.height)];
            contentView.contentSize = CGSizeMake(item.contentWidth, item.contentHeight);
            contentView.showsHorizontalScrollIndicator = NO;
            contentView.showsVerticalScrollIndicator = NO;
            contentView.delegate = self;
            [self addSubview:contentView];
            [contentView release];
            _scrollView = contentView;
            
            for (HomeItem *subitem in self.subitems) {
                HomeItemView *subitemView = [[HomeItemView alloc] initWithDataSource:subitem];
                subitemView.delegate = self;
                [contentView addSubview:subitemView];
                [subitemView release];
                scrollHeight = subitem.height + 5;
            }
        }else{
            // action 没有 longpress
            if (!item.action) {
                self.longPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)] autorelease];
                self.longPressGesture.minimumPressDuration = 0.3;
                [self addGestureRecognizer:self.longPressGesture];
                self.longPressGesture.delegate = self;
            }
            
            // 单击手势
            self.singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)] autorelease];
            self.singleTap.numberOfTapsRequired = 1;
            self.singleTap.numberOfTouchesRequired = 1;
            self.singleTap.delegate = self;
            [self addGestureRecognizer:self.singleTap];
        }

        // actions
        for (HomeItem *action in item.actions) {
            HomeItemView *actionView = [[HomeItemView alloc] initWithDataSource:action];
            actionView.delegate = self;
            [self addSubview:actionView];
            [actionView release];
            [self removeGestureRecognizer:self.singleTap];
            self.singleTap = nil;
            
            
            if (![[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_HOME_ADDNEWTIPS]) {
                //TODO: 临时修改 增加new
                if (action.tag == 1433) {
                    // 添加模块
                    UIImageView *newTipsView = [[UIImageView alloc] initWithFrame:CGRectMake(actionView.frame.size.width - 30, 4, 26, 15)];
                    newTipsView.image = [UIImage noCacheImageNamed:@"home_item_5_2_02.png"];
                    [actionView addSubview:newTipsView];
                    [newTipsView release];
                    newTipsView.tag = action.tag + 1;
                }
            }
        }
    }
    return self;
}

#pragma mark -
#pragma mark UIScrollViewDelegate


- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (velocity.y == 0.0) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollHeight * roundf(scrollView.contentOffset.y/scrollHeight)) animated:YES];
        return;
    }
    float d = scrollHeight * roundf(targetContentOffset->y/scrollHeight);
    
    targetContentOffset->y = d;
}

#pragma mark -
#pragma mark HomeItemViewDelegate(转发subitem的delegate)
- (void) homeItemViewWillBeginDelete:(HomeItemView *)itemView{
    if ([self.delegate respondsToSelector:@selector(homeItemViewWillBeginDelete:)]) {
        [self.delegate homeItemViewWillBeginDelete:itemView];
    }
}

- (void) homeItemViewWillBeginEdit:(HomeItemView *)itemView{
    if ([self.delegate respondsToSelector:@selector(homeItemViewWillBeginEdit:)]) {
        [self.delegate homeItemViewWillBeginEdit:itemView];
    }
}

- (void) homeItemViewWillEndEdit:(HomeItemView *)itemView{
    if ([self.delegate respondsToSelector:@selector(homeItemViewWillEndEdit:)]) {
        [self.delegate homeItemViewWillEndEdit:itemView];
    }
}

- (void) homeItemViewBeginMove:(HomeItemView *)itemView{
    if ([self.delegate respondsToSelector:@selector(homeItemViewBeginMove:)]) {
        [self.delegate homeItemViewBeginMove:itemView];
    }
}

- (void) homeItemViewMoved:(HomeItemView *)itemView offset:(CGPoint)offset position:(CGPoint)position{
    if ([self.delegate respondsToSelector:@selector(homeItemViewMoved:offset:position:)]) {
        [self.delegate homeItemViewMoved:itemView offset:offset position:position];
    }
}

- (void) homeItemViewEndMove:(HomeItemView *)itemView{
    if ([self.delegate respondsToSelector:@selector(homeItemViewEndMove:)]) {
        [self.delegate homeItemViewEndMove:itemView];
    }
}

- (void) homeItemViewAction:(HomeItemView *)itemView{
    if ([self.delegate respondsToSelector:@selector(homeItemViewAction:)]) {
        [self.delegate homeItemViewAction:itemView];
    }
}

#pragma mark-
#pragma mark Private methods:beginEdit,endEdit,refresh
- (void) beginEditFromLeft:(BOOL)left{
    if (self.editing == YES) {
        return;
    }
    self.editing = YES;
    if (self.deleteBtn) {
        [UIView animateWithDuration:0.2 animations:^{
            self.deleteBtn.alpha = 1.0f;
        }];
    }
    if (!self.item.fixed) {
        [UIView animateWithDuration:0.2 animations:^{
//            if (self.bgView) {
//                self.bgView.alpha = 0.7;
//            }
//            if (self.adView) {
//                self.adView.alpha = 0.7;
//            }
            [self addShakeAnimation:self.layer fromLeft:(BOOL)left];
//            if (self.item.actions) {
//                for (HomeItem *subitem in self.item.actions) {
//                    HomeItemView *subview = (HomeItemView *)[self viewWithTag:subitem.tag];
//                    if (subview.bgView) {
//                        subview.bgView.alpha = 0.7;
//                    }
//                    if (subview.adView) {
//                        subview.adView.alpha = 0.7;
//                    }
//                }
//            }
        }];
    }
}

- (void) addShakeAnimation:(CALayer *)layer fromLeft:(BOOL)left{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    if (left) {
        shake.fromValue = [NSNumber numberWithFloat:-M_PI/200];
        shake.toValue   = [NSNumber numberWithFloat:+M_PI/200];
    }else{
        shake.fromValue = [NSNumber numberWithFloat:M_PI/200];
        shake.toValue   = [NSNumber numberWithFloat:-M_PI/200];
    }
    shake.duration = 0.1;
    shake.autoreverses = YES;
    shake.repeatCount = NSIntegerMax;
    [layer addAnimation:shake forKey:@"shakeAnimation"];
}

- (void) endEdit{
    if (self.editing == NO) {
        return;
    }
    self.editing = NO;
    if (self.deleteBtn) {
        [UIView animateWithDuration:0.2 animations:^{
            self.deleteBtn.alpha = 0.0f;
        }];
    }
    
    if (!self.item.fixed) {
        [UIView animateWithDuration:0.2 animations:^{
//            if (self.bgView) {
//                self.bgView.alpha = 1.0f;
//            }
//            if (self.adView) {
//                self.adView.alpha = 1.0f;
//            }
            
            [self.layer removeAnimationForKey:@"shakeAnimation"];
//            if (self.item.actions) {
//                for (HomeItem *subitem in self.item.actions) {
//                    HomeItemView *subview = (HomeItemView *)[self viewWithTag:subitem.tag];
//                    if (subview.bgView) {
//                        subview.bgView.alpha = 1.0;
//                    }
//                    if (subview.adView) {
//                        subview.adView.alpha = 1.0;
//                    }
//                }
//            }
        }];
    }
}

- (void) refresh{
    self.frame = CGRectMake(self.item.x, self.item.y, self.item.width, self.item.height);
}

- (void) reloadItems{
    if (self.item.scrollable) {
        _scrollView.contentSize = CGSizeMake(self.item.contentWidth, self.item.contentHeight);
        for (UIView *view in _scrollView.subviews) {
            [view removeFromSuperview];
        }
        
        if (self.item.scrollable) {
            if (self.item.subitems) {
                self.subitems = self.item.subitems;
            }
        }

        for (HomeItem *subitem in self.subitems) {
            HomeItemView *subitemView = [[HomeItemView alloc] initWithDataSource:subitem];
            subitemView.delegate = self;
            [_scrollView addSubview:subitemView];
            [subitemView release];
        }
    }
}

#pragma mark -
#pragma mark Gesture
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // 判断是不是UIButton的类
    if ([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    else{
        return YES;
    }
}

- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (HomeItemViewAction) {
        return NO;
    }else{
        HomeItemViewAction = YES;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(setHomeItemViewAction) withObject:nil afterDelay:0.1];
        return YES;
    }
}

- (void) setHomeItemViewAction{
    HomeItemViewAction = NO;
}


- (void) longPressGesture:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // 如果发现还有未完成的longpress，直接跳出
        if (HomeItemViewlongpressActions.count) {
            return;
        }
        // 记录当前longpress
        [HomeItemViewlongpressActions addObject:gesture];
        
        // 对于固定Item，长按不触发编辑
        if (!self.item.fixed) {
            if ([self.delegate respondsToSelector:@selector(homeItemViewWillBeginEdit:)]) {
                [self.delegate homeItemViewWillBeginEdit:self];
            }
        }
        
        // 记录开始位置
        self.startPoint = [gesture locationInView:self.superview];
        // 非固定Item开始Move
        if (!self.item.fixed) {
            
            if ([self.delegate respondsToSelector:@selector(homeItemViewBeginMove:)]) {
                [self.delegate homeItemViewBeginMove:self];
            }
        }else{
            // 固定Item 并且没有处于编辑状态，触发按下效果
            if (!self.editing) {
                [UIView animateWithDuration:0.2 animations:^{
                    //self.transform = CGAffineTransformMakeScale(0.94, 0.94);
                    if (self.bgView) {
                        self.bgView.alpha = 0.7;
                    }
                    if (self.adView) {
                        self.adView.alpha = 0.7;
                    }
                }];
            }
        }
        if (self.adView) {
            self.adView.pause = YES;
        }
    }else if(gesture.state == UIGestureRecognizerStateEnded){
        if (![HomeItemViewlongpressActions containsObject:gesture]) {
            return;
        }
        
        // 移除当前的longpress
        [HomeItemViewlongpressActions removeObject:gesture];

        // 非固定Item结束Move
        if (!self.item.fixed) {
            if ([self.delegate respondsToSelector:@selector(homeItemViewEndMove:)]) {
                [self.delegate homeItemViewEndMove:self];
            }
        }else{
            // 固定Item 并且没有处于编辑状态，触发抬起效果，并且回调Action delegate
            if (!self.editing) {
                [UIView animateWithDuration:0.2 animations:^{
                    //self.transform = CGAffineTransformIdentity;
                    if (self.bgView) {
                        self.bgView.alpha = 1.0f;
                    }
                    if (self.adView) {
                        self.adView.alpha = 1.0f;
                    }
                }];
                if ([self.delegate respondsToSelector:@selector(homeItemViewAction:)]) {
                    [self.delegate homeItemViewAction:self];
                }
            }
        }
        if (self.adView) {
            self.adView.pause = NO;
        }
    }else if(gesture.state == UIGestureRecognizerStateChanged){
        // 检测是否包含当前的longpress，如果有继续执行，如果没有跳出
        if (![HomeItemViewlongpressActions containsObject:gesture]) {
            return;
        }
        // 非固定Item move change
        if (!self.item.fixed) {
            CGPoint endPoint = [gesture locationInView:self.superview];
            if ([self.delegate respondsToSelector:@selector(homeItemViewMoved:offset:position:)]) {
                [self.delegate homeItemViewMoved:self offset:CGPointMake(endPoint.x - self.startPoint.x, endPoint.y - self.startPoint.y) position:endPoint];
            }
        }
    }
}


- (void) singleTap:(UITapGestureRecognizer *)gesture{
    if(HomeItemViewlongpressActions.count){
        return;
    }
    
    BOOL canAction = NO;
    
    // 如果当前正处于编辑状态
    if (!self.editing) {
        // 如果是具体的Item上的Action则判断容纳Action的Item
        if (self.item.action) {
            HomeItemView *superItemView = (HomeItemView *)self.superview;
            if (!superItemView.editing) {
                canAction = YES;
            }
        }else{
            canAction = YES;
        }
    }
    if (canAction) {
        if (self.bgView) {
            self.bgView.alpha = 0.7;
        }
        if (self.adView) {
            self.adView.alpha = 0.7;
        }
        [UIView animateWithDuration:0.3 animations:^{
            //itemView.transform = CGAffineTransformIdentity;
            if (self.bgView) {
                self.bgView.alpha = 1.0;
            }
            if (self.adView) {
                self.adView.alpha = 1.0;
            }
        }];

        
        if ([self.delegate respondsToSelector:@selector(homeItemViewAction:)]) {
            [self.delegate homeItemViewAction:self];
        }
    }
    
    
    if ([self.delegate respondsToSelector:@selector(homeItemViewWillEndEdit:)]) {
        [self.delegate homeItemViewWillEndEdit:self];
    }
}



#pragma mark -
#pragma mark 删除

- (void) deleteBtnClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(homeItemViewWillBeginDelete:)]) {
        [self.delegate homeItemViewWillBeginDelete:self];
    }
}

@end
