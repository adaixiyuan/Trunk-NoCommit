//
//  TrainSearchFilterController.m
//  ElongClient
//
//  Created by chenggong on 13-10-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainSearchFilterController.h"

@interface TrainSearchFilterController ()

@property (nonatomic, retain) TrainSearchTypeViewController *typeViewController;
@property (nonatomic, retain) TrainSearchDepartureTimeViewController *departureTimeViewController;
@property (nonatomic, retain) TrainSearchArrivalTimeViewController *arrivalTimeViewController;

@end

@implementation TrainSearchFilterController

- (void)dealloc {
    self.trainType = nil;
    self.departureTime = nil;
    self.arrivalTime = nil;
    
    self.typeViewController = nil;
    self.departureTimeViewController = nil;
    self.arrivalTimeViewController = nil;
    
    [super dealloc];
}

- (id)initWithFilterConditions:(NSDictionary *)conditions
{
    self.filterConditions = conditions;
    return [self initWithNibName:@"FilterController" bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSArray *tempArray = [NSArray arrayWithObjects:@"高铁/动车(G/D/C开头)",
                                                       @"普通(Z/K/T/数字等开头)",
                                                       nil];
        self.trainType = tempArray;
        
        tempArray = [NSArray arrayWithObjects:@"凌晨(0-6点)",
                                              @"上午(6-12点)",
                                              @"下午(12-18点)",
                                              @"晚间(18-24点)",
                                              nil];
        self.departureTime = tempArray;
        self.arrivalTime = tempArray;
        
        NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionaryWithCapacity:3];
        self.tabHolder = tempDictionary;
        
        self.typeIndex = -1;
        self.departureTimeIndex = -1;
        self.arrivalTimeIndex = -1;
        
        self.locationNavigationBar.frame = CGRectMake(SCREEN_WIDTH, 0.0f, SCREEN_WIDTH, 0.0f);
        
        // Do any additional setup after loading the view from its nib.
        
        self.priceLabel.text = @"车次类型";
        self.starLabel.text = @"发车时间";
        self.locationlabel.text = @"到达时间";
        
        UIImage *trainImage = [UIImage imageNamed:@"filter_train.png"];
        UIImage *trainSelectedImage = [UIImage imageNamed:@"filterTrarin_Press.png"];
        [self.priceButton setImage:trainImage forState:UIControlStateNormal];
        [self.priceButton setImage:trainSelectedImage forState:UIControlStateSelected];
        [self.priceButton setImage:trainSelectedImage forState:UIControlStateHighlighted];
        
        UIImage *departureImage = [UIImage imageNamed:@"filterTrainFrom.png"];
        UIImage *departureSelectedImage = [UIImage imageNamed:@"filterTrainFrom_Press.png"];
        [self.starButton setImage:departureImage forState:UIControlStateNormal];
        [self.starButton setImage:departureSelectedImage forState:UIControlStateSelected];
        [self.starButton setImage:departureSelectedImage forState:UIControlStateHighlighted];
        
        UIImage *arrivalImage = [UIImage imageNamed:@"filterTrainTo.png"];
        UIImage *arrivalSelectedImage = [UIImage imageNamed:@"filterTrainTo_Press.png"];
        [self.locationButton setImage:arrivalImage forState:UIControlStateNormal];
        [self.locationButton setImage:arrivalSelectedImage forState:UIControlStateSelected];
        [self.locationButton setImage:arrivalSelectedImage forState:UIControlStateHighlighted];
        
        self.brandTab.hidden = YES;
        self.otherTab.hidden = YES;
        
        [self updateTab];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IOSVersion_7) {
        /* 请不要上传新SDK特性的代码
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
         */
    }
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private Methods

- (void)updateTab
{
    self.priceButton.selected = NO;
    self.starButton.selected = NO;
    self.locationButton.selected = NO;
    
    self.priceLabel.highlighted = NO;
    self.starLabel.highlighted = NO;
    self.locationlabel.highlighted = NO;
    
    for (UIView *subView in [self.selectedContainer subviews]) {
        [subView removeFromSuperview];
    }
    
    if (self.typeViewController == nil) {
        self.typeViewController = [[[TrainSearchTypeViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        self.typeViewController.typeArray = _trainType;
        self.typeViewController.delegate = self;
        
        if (_filterConditions && [_filterConditions count] != 0) {
            NSArray *typeArray = [_filterConditions objectForKey:[NSString stringWithFormat:@"%d", FilterType]];
            if ([typeArray indexOfObject:[NSString stringWithFormat:@"%d", 1]] != NSNotFound && [typeArray indexOfObject:[NSString stringWithFormat:@"%d", 2]] != NSNotFound) {
                [_typeViewController.typeTabDictionary setValue:[_typeViewController.typeArray objectAtIndex:0] forKey:[NSString stringWithFormat:@"%d", 0]];
            }
//            for (NSString *typeKey in typeArray) {
//                [_typeViewController setTypeIndex:[typeKey integerValue]];
//                
//            }
        }
    }
    
    if (self.departureTimeViewController == nil) {
        self.departureTimeViewController = [[[TrainSearchDepartureTimeViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        self.departureTimeViewController.delegate = self;
        self.departureTimeViewController.departureTimeArray = _departureTime;
        
        if (_filterConditions && [_filterConditions count] != 0) {
            NSArray *departureArray = [_filterConditions objectForKey:[NSString stringWithFormat:@"%d", FilterDepartureTime]];
            if ([departureArray count] != 4) {
                for (NSString *departureKey in departureArray) {
                    [_departureTimeViewController.departureTimeTabDictionary setValue:[_departureTimeViewController.departureTimeArray objectAtIndex:[departureKey integerValue]] forKey:departureKey];
                }
            }
        }
    }
    
    if (self.arrivalTimeViewController == nil) {
        self.arrivalTimeViewController = [[[TrainSearchArrivalTimeViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        self.arrivalTimeViewController.delegate = self;
        self.arrivalTimeViewController.arrivalTimeArray = _arrivalTime;
        
        if (_filterConditions && [_filterConditions count] != 0) {
            NSArray *arrivalArray = [_filterConditions objectForKey:[NSString stringWithFormat:@"%d", FilterArrivalTime]];
            if ([arrivalArray count] != 4) {
                for (NSString *arrivalKey in arrivalArray) {
                    [_arrivalTimeViewController.arrivalTimeTabDictionary setValue:[_arrivalTimeViewController.arrivalTimeArray objectAtIndex:[arrivalKey integerValue]] forKey:arrivalKey];
                }
            }
        }
    }
    
    switch (self.selectedIndex) {
        case 0:
            self.priceButton.selected = YES;
            self.priceLabel.highlighted = YES;
            
//            self.priceController.selectedIndex = self.priceLevel;
            [self.selectedContainer addSubview:self.typeViewController.view];
            
            self.typeViewController.view.frame = self.selectedContainer.bounds;
            
            break;
        case 1:
            self.starButton.selected = YES;
            self.starLabel.highlighted = YES;
            
            
//            [self.departureTimeViewController setSelectedIndex:_starLevel];
            [self.selectedContainer addSubview:self.departureTimeViewController.view];
            
            self.departureTimeViewController.view.frame = self.selectedContainer.bounds;
            
//            if (_departureTimeIndex != -1) {
//                [_departureTimeViewController setDepartureTimeIndex:_departureTimeIndex];
//                self.departureTimeIndex = -1;
//            }
            
            break;
        case 2:
        {
            self.locationButton.selected = YES;
            self.locationlabel.highlighted = YES;
            
            
            
            [self.selectedContainer addSubview:self.arrivalTimeViewController.view];
            
            
            self.arrivalTimeViewController.view.frame = self.selectedContainer.bounds;
            
//            if (_arrivalTimeIndex != -1) {
//                [_arrivalTimeViewController setArrivalTimeIndex:_arrivalTimeIndex];
//                self.arrivalTimeIndex = -1;
//            }
        }
            break;
        default:
            break;
    }
}

- (void)itemWithTagTapped:(NSUInteger)tag
{
    NSUInteger tagType = tag / kFilterTrainType;
    switch (tagType) {
        case 1: // type
            self.typeIndex = tag - kFilterTrainType;
           [_typeViewController setTypeIndex:_typeIndex];
            
            break;
        case 10: // star
            self.departureTimeIndex = tag - kFilterDepartureTime;
             [_departureTimeViewController setDepartureTimeIndex:_departureTimeIndex];
            break;
        case 100: // brand
            self.arrivalTimeIndex = tag - kFilterArrivalTime;
            [_arrivalTimeViewController setArrivalTimeIndex:_arrivalTimeIndex];
            break;
    }
}

- (void)tabTappedAtIndex:(NSUInteger)index
{
    [super tabTappedAtIndex:index];
}

- (void)reset
{
    for (NSString *key in [_typeViewController.typeTabDictionary allKeys]) {
        [_typeViewController setTypeIndex:[key integerValue]];
    }
    
    for (NSString *key in [_departureTimeViewController.departureTimeTabDictionary allKeys]) {
        [_departureTimeViewController setDepartureTimeIndex:[key integerValue]];
    }
    
    for (NSString *key in [_arrivalTimeViewController.arrivalTimeTabDictionary allKeys]) {
        [_arrivalTimeViewController setArrivalTimeIndex:[key integerValue]];
    }

    for (UIView *subView in [self.displayContainer subviews]) {
        [subView removeFromSuperview];
    }
    [self clearItems];
    
//    for (UIButton *tab in self.displayContainer.subviews) {
//        [self itemWithTagTapped:tab.tag];
//        [tab removeFromSuperview];
//    }
}

- (void)confirm
{
//	NSMutableDictionary *filterInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    // Type filter result.
    NSMutableArray *typeResultArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *typeKeys = [_typeViewController.typeTabDictionary allKeys];
    if ([typeKeys count] == 0 || [typeKeys count] == [_trainType count]) {
        [typeResultArray addObject:[NSString stringWithFormat:@"%d", 0]];
    }
    else {
        for (NSString *typeKey in typeKeys) {
            if ([typeKey integerValue] == 0) {
                // 高铁
                [typeResultArray addObject:[NSString stringWithFormat:@"%d", 1]];
                // 动车
                [typeResultArray addObject:[NSString stringWithFormat:@"%d", 2]];
            }
            else {
                // 特快
                [typeResultArray addObject:[NSString stringWithFormat:@"%d", 3]];
            }
        }
        //
        if(UMENG){
            // 火车票筛选，选择车次类型
            [MobClick event:Event_TrainFilter_Type];
        }
    }
    [_filterConditions setValue:typeResultArray forKey:[NSString stringWithFormat:@"%d", FilterType]];
    
    // DepartureTime filter result.
    NSMutableArray *departureTimeResultArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *departureTimeKeys = [_departureTimeViewController.departureTimeTabDictionary allKeys];
//    if ([departureTimeKeys count] == 0 || [departureTimeKeys count] == [_departureTime count]) {
    if ([departureTimeKeys count] == [_departureTime count]) {
        for (NSUInteger index = 0; index < [_departureTime count]; index++) {
            [departureTimeResultArray addObject:[NSString stringWithFormat:@"%d", index]];
        }
    }
    else {
        for (NSString *departureTimeKey in departureTimeKeys) {
            [departureTimeResultArray addObject:departureTimeKey];
        }
        //
        if(UMENG){
            // 火车票筛选，选择发车时间
            [MobClick event:Event_TrainFilter_DepartureTime];
        }
    }
    [_filterConditions setValue:departureTimeResultArray forKey:[NSString stringWithFormat:@"%d", FilterDepartureTime]];
    
    // ArrivalTime filter result.
    NSMutableArray *arrivalTimeResultArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *arrivalTimeKeys = [_arrivalTimeViewController.arrivalTimeTabDictionary allKeys];
//    if ([arrivalTimeKeys count] == 0 || [arrivalTimeKeys count] == [_arrivalTime count]) {
    if ([arrivalTimeKeys count] == [_arrivalTime count]) {
        for (NSUInteger index = 0; index < [_arrivalTime count]; index++) {
            [arrivalTimeResultArray addObject:[NSString stringWithFormat:@"%d", index]];
        }
    }
    else {
        for (NSString *arrivalTimeKey in arrivalTimeKeys) {
            [arrivalTimeResultArray addObject:arrivalTimeKey];
        }
        if(UMENG){
            // 火车票筛选，选择到达时间
            [MobClick event:Event_TrainFilter_ArrivalTime];
        }
    }
    [_filterConditions setValue:arrivalTimeResultArray forKey:[NSString stringWithFormat:@"%d", FilterArrivalTime]];
    
    if (self.filterDelegate && [self.filterDelegate respondsToSelector:@selector(searchFilterController:didFinishedWithInfo:)]) {
        [self.filterDelegate searchFilterController:self didFinishedWithInfo:_filterConditions];
    }
    
//    [filterInfo release];

    if(UMENG){
        // 火车票筛选，点击确定
        [MobClick event:Event_TrainFilter_Confirm];
    }

    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }


}

- (void)back {
    [self reset];
    
    if (self.typeViewController != nil) {
        if (_filterConditions && [_filterConditions count] != 0) {
            NSArray *typeArray = [_filterConditions objectForKey:[NSString stringWithFormat:@"%d", FilterType]];
            if ([typeArray indexOfObject:[NSString stringWithFormat:@"%d", 1]] != NSNotFound && [typeArray indexOfObject:[NSString stringWithFormat:@"%d", 2]] != NSNotFound) {
                [_typeViewController.typeTabDictionary setValue:[_typeViewController.typeArray objectAtIndex:0] forKey:[NSString stringWithFormat:@"%d", 0]];
            }
            if ([typeArray indexOfObject:[NSString stringWithFormat:@"%d", 3]] != NSNotFound) {
                [_typeViewController.typeTabDictionary setValue:[_typeViewController.typeArray objectAtIndex:1] forKey:[NSString stringWithFormat:@"%d", 1]];
            }
            if ([typeArray indexOfObject:[NSString stringWithFormat:@"%d", 0]] != NSNotFound) {
                [_typeViewController.typeTabDictionary setValue:[_typeViewController.typeArray objectAtIndex:0] forKey:[NSString stringWithFormat:@"%d", 0]];
                [_typeViewController.typeTabDictionary setValue:[_typeViewController.typeArray objectAtIndex:1] forKey:[NSString stringWithFormat:@"%d", 1]];
            }
            [_typeViewController.typeTableView reloadData];
        }
    }
    
    if (self.departureTimeViewController != nil) {
        if (_filterConditions && [_filterConditions count] != 0) {
            NSArray *departureArray = [_filterConditions objectForKey:[NSString stringWithFormat:@"%d", FilterDepartureTime]];
            for (NSString *departureKey in departureArray) {
                [_departureTimeViewController.departureTimeTabDictionary setValue:[_departureTimeViewController.departureTimeArray objectAtIndex:[departureKey integerValue]] forKey:departureKey];
            }
            [_departureTimeViewController.departureTimeTableView reloadData];
        }
    }
    
    if (self.arrivalTimeViewController != nil) {
        if (_filterConditions && [_filterConditions count] != 0) {
            NSArray *arrivalArray = [_filterConditions objectForKey:[NSString stringWithFormat:@"%d", FilterArrivalTime]];
            for (NSString *arrivalKey in arrivalArray) {
                [_arrivalTimeViewController.arrivalTimeTabDictionary setValue:[_arrivalTimeViewController.arrivalTimeArray objectAtIndex:[arrivalKey integerValue]] forKey:arrivalKey];
            }
            [_arrivalTimeViewController.arrivalTimeTableView reloadData];
        }
    }
    
//    [self reset];
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark -  TrainSearchTypeDelegate

- (void)trainSearchTypeViewCtrontroller:(TrainSearchTypeViewController *)controller didSelectIndex:(NSUInteger)index {
    NSMutableDictionary *tabDictionary = controller.typeTabDictionary;
    NSString *selectedKey = [NSString stringWithFormat:@"%d", index];
    // 当前是选中状态
    if ([tabDictionary objectForKey:selectedKey]) {
        // 将除点击外的cell,其他cell都添加tab
        if ([tabDictionary count] == controller.typeArray.count) {
            [tabDictionary removeObjectForKey:selectedKey];
            NSArray *keys = [tabDictionary allKeys];
            for (NSString *key in keys) {
                NSInteger tabIndex = [key integerValue];
                NSUInteger buttonIndex = tabIndex + kFilterTrainType;
                
                [self addItem:[_typeViewController.typeArray safeObjectAtIndex:tabIndex] withStartPoint:self.touchPoint withTag:buttonIndex];
            }
        }
        // 删除当前cell已经添加的tab
        else {
            [tabDictionary removeObjectForKey:selectedKey];
            [self deleteItem:index + kFilterTrainType animated:NO];
        }
    }
    
    // 当前不是选中状态
    else {
        // 如果新加入后正好是全选状态,移除当前所有的tab
        if (tabDictionary.count + 1 == controller.typeArray.count) {
            NSArray *keys = [tabDictionary allKeys];
            for (NSString *key in keys) {
                NSInteger tabIndex = [key integerValue];
                NSUInteger buttonIndex = tabIndex + kFilterTrainType;
                [self deleteItem:buttonIndex animated:NO];
            }
        }
        else {
            [self addItem:[_typeViewController.typeArray safeObjectAtIndex:index] withStartPoint:self.touchPoint withTag:index + kFilterTrainType];
        }
        [tabDictionary setValue:[controller.typeArray safeObjectAtIndex:index] forKey:selectedKey];
    }
}

#pragma mark -  TrainSearchDepartureTimeDelegate
- (void)trainSearchDepartureTimeViewCtrontroller:(TrainSearchDepartureTimeViewController *)controller didSelectIndex:(NSUInteger)index {
    NSMutableDictionary *tabDictionary = controller.departureTimeTabDictionary;
    
    NSString *selectedKey = [NSString stringWithFormat:@"%d", index];
    // 当前是选中状态
    if ([tabDictionary objectForKey:selectedKey]) {
        // 将除点击外的cell,其他cell都添加tab
        if ([tabDictionary count] == controller.departureTimeArray.count) {
            [tabDictionary removeObjectForKey:selectedKey];
            NSArray *keys = [tabDictionary allKeys];
            for (NSString *key in keys) {
                NSInteger tabIndex = [key integerValue];
                NSUInteger buttonIndex = tabIndex + kFilterDepartureTime;
                
                [self addItem:[_departureTimeViewController.departureTimeArray safeObjectAtIndex:tabIndex] withStartPoint:self.touchPoint withTag:buttonIndex];
            }
        }
        // 删除当前cell已经添加的tab
        else {
            [tabDictionary removeObjectForKey:selectedKey];
            [self deleteItem:index + kFilterDepartureTime animated:NO];
        }
    }
    
    // 当前不是选中状态
    else {
        // 如果新加入后正好是全选状态,移除当前所有的tab
        if (tabDictionary.count + 1 == controller.departureTimeArray.count) {
            NSArray *keys = [tabDictionary allKeys];
            for (NSString *key in keys) {
                NSInteger tabIndex = [key integerValue];
                NSUInteger buttonIndex = tabIndex + kFilterDepartureTime;
                [self deleteItem:buttonIndex animated:NO];
            }
        }
        else {
            [self addItem:[_departureTimeViewController.departureTimeArray safeObjectAtIndex:index] withStartPoint:self.touchPoint withTag:index + kFilterDepartureTime];
        }
        [tabDictionary setValue:[controller.departureTimeArray safeObjectAtIndex:index] forKey:selectedKey];
    }
}

#pragma mark -  TrainSearchArrivalTimeDelegate
- (void)trainSearchArrivalTimeViewCtrontroller:(TrainSearchArrivalTimeViewController *)controller didSelectIndex:(NSUInteger)index {
    NSMutableDictionary *tabDictionary = controller.arrivalTimeTabDictionary;
    
    NSString *selectedKey = [NSString stringWithFormat:@"%d", index];
    // 当前是选中状态
    if ([tabDictionary objectForKey:selectedKey]) {
        // 将除点击外的cell,其他cell都添加tab
        if ([tabDictionary count] == controller.arrivalTimeArray.count) {
            [tabDictionary removeObjectForKey:selectedKey];
            NSArray *keys = [tabDictionary allKeys];
            for (NSString *key in keys) {
                NSInteger tabIndex = [key integerValue];
                NSUInteger buttonIndex = tabIndex + kFilterArrivalTime;
                
                [self addItem:[_arrivalTimeViewController.arrivalTimeArray safeObjectAtIndex:tabIndex] withStartPoint:self.touchPoint withTag:buttonIndex];
            }
        }
        // 删除当前cell已经添加的tab
        else {
            [tabDictionary removeObjectForKey:selectedKey];
            [self deleteItem:index + kFilterArrivalTime  animated:NO];
        }
    }
    
    // 当前不是选中状态
    else {
        // 如果新加入后正好是全选状态,移除当前所有的tab
        if (tabDictionary.count + 1 == controller.arrivalTimeArray.count) {
            NSArray *keys = [tabDictionary allKeys];
            for (NSString *key in keys) {
                NSInteger tabIndex = [key integerValue];
                NSUInteger buttonIndex = tabIndex + kFilterArrivalTime;
                [self deleteItem:buttonIndex animated:NO];
            }
        }
        else {
            [self addItem:[_arrivalTimeViewController.arrivalTimeArray safeObjectAtIndex:index] withStartPoint:self.touchPoint withTag:index + kFilterArrivalTime];
        }
        [tabDictionary setValue:[controller.arrivalTimeArray safeObjectAtIndex:index] forKey:selectedKey];
    }
}

@end
