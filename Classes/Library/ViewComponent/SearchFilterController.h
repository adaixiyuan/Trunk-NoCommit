//
//  SearchFilterController.h
//  ElongClient
//
//  Created by 赵岩 on 13-6-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchFilterDelegate;

@interface SearchFilterController : DPNav
{
    UIImageView *downSplitView;
}

@property (nonatomic, assign) NSUInteger selectedIndex; // 当前被选中的TAB索引

@property (nonatomic, retain) NSString *cityName;       // 城市名称

@property (nonatomic, assign) id<SearchFilterDelegate> filterDelegate; // 代理

@property (nonatomic, assign) IBOutlet UIScrollView *displayContainer;    // 上方筛选条件展示区
@property (nonatomic, assign) IBOutlet UIView *contentContainer;    // 内容区域
@property (nonatomic, assign) IBOutlet UIScrollView *tabContainer;        // TAB区
@property (nonatomic, assign) IBOutlet UIView *selectedContainer;   // 右方条件选择区
@property (nonatomic, assign) IBOutlet UIView *buttonContainer;     // 按钮区
@property (nonatomic, assign) IBOutlet UITapGestureRecognizer *tapRecognizer; // 手势
@property (nonatomic, assign) IBOutlet UIView *locationNavigationBar;   // 地标选取页面的导航栏
@property (nonatomic, assign) IBOutlet UILabel *locationNavigationLabel;// 地标选取页面导航标题
@property (nonatomic, assign) IBOutlet UIButton *cancelButton;          // 取消按钮
@property (nonatomic, assign) IBOutlet UIButton *resetButton;           // 重置按钮
@property (nonatomic, assign) IBOutlet UIButton *confirmButton;         // 确认按钮
@property (nonatomic, assign) IBOutlet UIImageView *footerImageView;    // 底部功能按钮区
@property (nonatomic, assign) IBOutlet UIButton *priceButton;
@property (nonatomic, assign) IBOutlet UIButton *starButton;
@property (nonatomic, assign) IBOutlet UIButton *locationButton;
@property (nonatomic, assign) IBOutlet UIButton *brandButton;
@property (nonatomic, assign) IBOutlet UIButton *otherButton;
@property (nonatomic, assign) IBOutlet UILabel *priceLabel;
@property (nonatomic, assign) IBOutlet UILabel *starLabel;
@property (nonatomic, assign) IBOutlet UILabel *locationlabel;
@property (nonatomic, assign) IBOutlet UILabel *brandLabel;
@property (nonatomic, assign) IBOutlet UILabel *otherLabel;
@property (nonatomic, assign) IBOutlet UIView *priceTab;    // 价格分页
@property (nonatomic, assign) IBOutlet UIView *starTab;     // 星级分页
@property (nonatomic, assign) IBOutlet UIView *locationTab; // 地理位置分页
@property (nonatomic, assign) IBOutlet UIView *brandTab;    // 品牌分页
@property (nonatomic, assign) IBOutlet UIView *otherTab;

@property (nonatomic, assign) IBOutlet UIImageView *leftSideBackground;
@property (nonatomic, assign) IBOutlet UIImageView *vernier;

@property (nonatomic, assign) CGPoint touchPoint;

@property (nonatomic, assign) CGFloat tabHeight;

- (void)updateTab;

- (void)itemWithTagTapped:(NSUInteger)tag;

- (void)reset;

- (void)tabTappedAtIndex:(NSUInteger)index;

- (void)confirm;

- (void)addItem:(NSString *)title withStartPoint:(CGPoint)startPoint withTag:(NSUInteger)tag;

- (void)updateItem:(NSString *)title withTag:(NSUInteger)tag;

- (void)deleteItem:(NSUInteger)tag;

- (void) deleteItem:(NSUInteger)tag animated:(BOOL)animated;

- (void)clearItems;

- (IBAction)itemTapped:(id)sender;

- (IBAction)tabTapped:(id)sender;

- (IBAction)selectContainerTapped:(UITapGestureRecognizer *)sender;

- (IBAction)locationBack:(id)sender;

- (IBAction)reset:(id)sender;

- (IBAction)confirm:(id)sender;

@end

@protocol SearchFilterDelegate <NSObject>

// 退出
- (void)searchFilterControllerDidCancel:(SearchFilterController *)filter;

// 确定
- (void)searchFilterController:(SearchFilterController *)filter didFinishedWithInfo:(NSDictionary *)info;

@end
