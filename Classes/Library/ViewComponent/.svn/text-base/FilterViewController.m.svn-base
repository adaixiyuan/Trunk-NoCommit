//
//  FilterViewController.m
//  ElongClient
//
//  Created by Dawn on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterSidebarCell.h"
#import "FilterSidebarItem.h"

@interface FilterViewController (){
@private
    UITableView *_sidebarList;
    UIImageView *_slideBlockView;
    float _itemHeight;
    float _itemWidth;
    float _bottomHeight;
    float _topHeight;
    float _tipsItemWidth;
    UIScrollView *_topView;
    UIImageView *_topSplitView;
}

@end

@implementation FilterViewController

- (void) dealloc{
    self.sidebarItems = nil;
    self.delegate = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (id) initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style{
    if (self = [super initWithTitle:titleStr style:style]) {
        _itemHeight = 74;
        _itemWidth = 60;
        _bottomHeight = 44;
        _topHeight = 44;
        _tipsItemWidth = 100;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *cancelBarItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"取消" Target:self Action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelBarItem;
    
    // 侧边列表
    _sidebarList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _itemWidth, MAINCONTENTHEIGHT - _bottomHeight) style:UITableViewStylePlain];
    _sidebarList.delegate = self;
    _sidebarList.dataSource = self;
    _sidebarList.showsHorizontalScrollIndicator = NO;
    _sidebarList.showsVerticalScrollIndicator = NO;
    _sidebarList.backgroundColor = RGBACOLOR(46, 46, 46, 1);
    [self.view addSubview:_sidebarList];
    [_sidebarList release];
    _sidebarList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 滑块
    _slideBlockView = [[UIImageView alloc] initWithFrame:CGRectMake(_itemWidth - 11, (_itemHeight - 19)/2, 11, 19)];
    _slideBlockView.image = [[UIImage noCacheImageNamed:@"filter_miss.png"] imageWithTintColor:RGBACOLOR(245, 245, 245, 1)];
    [_sidebarList addSubview:_slideBlockView];
    [_slideBlockView release];
    
    // tab容器
    _tabContentView = [[UIView alloc] initWithFrame:CGRectMake(_sidebarList.frame.size.width, 0, SCREEN_WIDTH - _sidebarList.frame.size.width, MAINCONTENTHEIGHT - _bottomHeight)];
    [self.view addSubview:_tabContentView];
    [_tabContentView release];
    
    // 顶栏
    _topView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    _topView.clipsToBounds = YES;
    _topView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
    _topSplitView = [UIImageView graySeparatorWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    [self.view addSubview:_topView];
    [self.view addSubview:_topSplitView];
    _topView.showsVerticalScrollIndicator = NO;
    _topView.showsHorizontalScrollIndicator = NO;
    [_topView release];
    _topView.contentSize = CGSizeMake(SCREEN_WIDTH, _topHeight);
    
    // 底栏
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - _bottomHeight, SCREEN_WIDTH, _bottomHeight)];
    bottomView.backgroundColor = RGBACOLOR(241, 241, 241, 1);
    [self.view addSubview:bottomView];
    [bottomView release];
    UIImageView *dashView = [UIImageView graySeparatorWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
    [bottomView addSubview:dashView];
    
    UIButton *resetBtn = [UIButton yellowWhitebuttonWithTitle:@"重置" Target:self Action:@selector(resetBtnClick:) Frame:CGRectMake(12, 6, 138, 32)];
    [resetBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default4_normal.png"] forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default4_press.png"] forState:UIControlStateHighlighted];
    [bottomView addSubview:resetBtn];
    [resetBtn setTitleColor:RGBACOLOR(52, 52, 52, 1) forState:UIControlStateNormal];
    
    UIButton *actionBtn = [UIButton yellowWhitebuttonWithTitle:@"确定" Target:self Action:@selector(actionBtnClick:) Frame:CGRectMake(170, 6, 138, 32)];
    [actionBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_normal.png"] forState:UIControlStateNormal];
    [actionBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default1_press.png"] forState:UIControlStateHighlighted];
    [bottomView addSubview:actionBtn];
}



- (void) setSidebarItems:(NSMutableArray *)sidebarItems{
    
    [_sidebarItems release];
    _sidebarItems = sidebarItems;
    [_sidebarItems retain];

    [_sidebarList reloadData];
}

- (void) removeSidebarItem:(FilterSidebarItemType)itemType{
    for (FilterSidebarItem *item in self.sidebarItems) {
        if (item.itemType == itemType) {
            [self.sidebarItems removeObject:item];
            [_sidebarList reloadData];
            break;
        }
    }
}

- (BOOL) haveSidebarItem:(FilterSidebarItemType)itemType{
    for (FilterSidebarItem *item in self.sidebarItems) {
        if (item.itemType == itemType) {
            return YES;
        }
    }
    return NO;
}

- (void) setSelectedItemType:(FilterSidebarItemType)selectedItemType{
    NSInteger index = -1;
    for (int i = 0;i < self.sidebarItems.count;i++) {
        FilterSidebarItem *item = (FilterSidebarItem *)[self.sidebarItems objectAtIndex:i];
        if (item.itemType == selectedItemType) {
            index = i;
        }
    }
    if (index >= 0) {
        [_sidebarList selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        [UIView animateWithDuration:0.2 animations:^{
            _slideBlockView.frame = CGRectMake(_itemWidth - 11, (_itemHeight - 19)/2 + index * _itemHeight, 11, 19);
        }];
    }
}

- (void) topViewResizeWithTipsCount:(NSInteger)tipsCount{
    if (tipsCount) {
        [UIView animateWithDuration:0.2 animations:^{
            // 侧边列表
            _sidebarList.frame = CGRectMake(0, _topHeight, _itemWidth, MAINCONTENTHEIGHT - _bottomHeight - _topHeight);
            
            // tab容器
            _tabContentView.frame = CGRectMake(_sidebarList.frame.size.width, _topHeight, SCREEN_WIDTH - _sidebarList.frame.size.width, MAINCONTENTHEIGHT - _bottomHeight - _topHeight);
            
            // 顶栏
            _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _topHeight);
            _topSplitView.frame = CGRectMake(0, _topHeight - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
            _topView.contentSize = CGSizeMake(_tipsItemWidth * tipsCount, _topHeight);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            // 侧边列表
            _sidebarList.frame = CGRectMake(0, 0, _itemWidth, MAINCONTENTHEIGHT - _bottomHeight);
            
            // tab容器
            _tabContentView.frame = CGRectMake(_sidebarList.frame.size.width, 0, SCREEN_WIDTH - _sidebarList.frame.size.width, MAINCONTENTHEIGHT - _bottomHeight);
            
            // 顶栏
            _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
            _topSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
            _topView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
        }];
    }
}

#pragma mark -
#pragma mark Actions
- (void) resetBtnClick:(id)sender{
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < _topView.subviews.count; i++) {
        UIButton *btn = (UIButton *)[_topView.subviews objectAtIndex:i];
        [items addObject:btn];
    }
    
    for (int i = 0; i < items.count; i++) {
        UIButton *btn = (UIButton *)[items objectAtIndex:i];
        [btn removeFromSuperview];
    }
    
    
    [self topViewResizeWithTipsCount:0];
    
    if ([self.delegate respondsToSelector:@selector(filterViewControllerDidReset:)]) {
        [self.delegate filterViewControllerDidReset:self];
    }
}


- (void) actionBtnClick:(id)sender{
    
}

- (void) tipsItemBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [self removeTipsItem:btn.tag animated:YES];
}

- (void) cancel{
    if ([self.delegate respondsToSelector:@selector(filterViewControllerDidCancel:)]) {
        [self.delegate filterViewControllerDidCancel:self];
    }
}

#pragma mark -
#pragma mark Public Methods

- (void) addTipsItem:(NSString *)title withTag:(NSInteger)tag animated:(BOOL)animated{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=[UIColor whiteColor];
    [button addTarget:self action:@selector(tipsItemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.minimumFontSize = 10.0f;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, _tipsItemWidth, _topHeight - SCREEN_SCALE)];
    [button setImage:[UIImage noCacheImageNamed:@"filter_delete.png"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(28, 82, 0, 0)];
    button.tag = tag;
    
    
    NSUInteger itemCount = [_topView subviews].count;
    button.frame = CGRectMake(_tipsItemWidth * itemCount, 0, _tipsItemWidth, _topHeight - SCREEN_SCALE);
    button.alpha = 0;
    button.transform = CGAffineTransformMakeScale(0.001, 0.001);
    
    [_topView addSubview:button];
    
    //button左边加一根线
    if (itemCount > 1) {
        UIView *shuSplitView         = [[UIView alloc] init];
        shuSplitView.backgroundColor = RGBACOLOR(223, 223, 223, 1);
        shuSplitView.frame           = CGRectMake(0, 3, SCREEN_SCALE,_topHeight - SCREEN_SCALE - 3 * 2);
        shuSplitView.contentMode     = UIViewContentModeScaleToFill;
        [button addSubview:shuSplitView];
        [shuSplitView release];
    }
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            button.alpha = 1.0f;
            button.transform = CGAffineTransformIdentity;
        }];
    }else{
        button.alpha = 1.0f;
        button.transform = CGAffineTransformIdentity;
    }
    
    [self topViewResizeWithTipsCount:_topView.subviews.count];
}
- (void) addTipsItem:(NSString *)title withTag:(NSInteger)tag{
    [self addTipsItem:title withTag:tag animated:YES];
}

- (UIButton *)tipsItemWithTag:(NSInteger)tag{
    UIButton *button = (UIButton *)[_topView viewWithTag:tag];
    return button;
}

- (void)updateTipsItem:(NSString *)title withTag:(NSUInteger)tag{
    UIButton *button = (UIButton *)[_topView viewWithTag:tag];
    [button setTitle:title forState:UIControlStateNormal];
}

- (void) removeTipsItem:(NSUInteger)tag animated:(BOOL)animated{
    BOOL found = NO;
    UIView *foundView = nil;
    for (UIView *view in [_topView subviews]) {
        if (view.tag == tag) {
            found = YES;
            foundView = view;
        }
        else {
            if (found) {
                [UIView animateWithDuration:0.3 animations:^{
                    view.frame = CGRectMake(view.frame.origin.x - _tipsItemWidth, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                }];
            }
        }
    }
    
    NSUInteger itemCount = [_topView subviews].count;
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
        itemCount = [_topView subviews].count;
    }
    
    [self topViewResizeWithTipsCount:itemCount];
}


#pragma mark -
#pragma mark UITablViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.sidebarItems) {
        return self.sidebarItems.count;
    }
    return 0;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _itemHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SidebarCell";
    FilterSidebarCell *cell = (FilterSidebarCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[FilterSidebarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == self.sidebarItems.count - 1) {
        cell.splitView.hidden = YES;
    }else{
        cell.splitView.hidden = NO;
    }
    
    FilterSidebarItem *item = (FilterSidebarItem *)[self.sidebarItems objectAtIndex:indexPath.row];
    cell.item = item;
    cell.titleLbl.text = item.title;

    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FilterSidebarItem *item = (FilterSidebarItem *)[self.sidebarItems objectAtIndex:indexPath.row];
    self.selectedItemType = item.itemType;
    
    if ([self.delegate respondsToSelector:@selector(filterViewController:didSelectedArIndex:)]) {
        [self.delegate filterViewController:self didSelectedArIndex:indexPath.row];
    }
}

@end
