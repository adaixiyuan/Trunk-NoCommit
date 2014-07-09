//
//  HotelUploadPhotosController.m
//  ElongClient
//
//  Created by chenggong on 14-3-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelUploadPhotosController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HotelDetailController.h"
#import "ELongAssetsPickerController.h"
#import "ElongAssetsLibraryController.h"
#import "DefineHotelResp.h"

#define kImageCountThresold         30
#define kPickerViewHeight          216.0f

@interface HotelUploadPhotosController()

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *assetsPhotoArray;
@property (nonatomic, retain) NSMutableArray *uploaderArray;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, retain) UIView *backgroundPickerView;
@property (nonatomic, retain) UIPickerView *typePicker;
@property (nonatomic, retain) NSMutableArray *pickerViewDatasourceArray;
@property (nonatomic, assign) NSUInteger pickerSelectedIndex;

@property (nonatomic, retain) NSMutableArray *cellImageTypeArray;
@property (nonatomic, retain) NSMutableArray *cellImageNameArray;
@property (nonatomic, retain) NSMutableDictionary *allImageTypeDictionary;
@property (nonatomic, retain) NSMutableArray *uploadStatusArray;
@property (nonatomic, assign) CGPoint lastOffset;

@property (nonatomic, assign) BOOL cancelUpload;
@property (nonatomic, assign) BOOL doneUpload;

@property (nonatomic, retain) NSMutableDictionary *guestRoomDictionary;

@property (nonatomic, assign) BOOL isUploading;
@property (nonatomic, assign) BOOL isDelaying;

@property (nonatomic, assign) BOOL isConnectionDisconnect;

@end

@implementation HotelUploadPhotosController

- (void)dealloc
{
//    [self cancelUpload:nil];
    ///////////////////////////
    self.cancelUpload = YES;
    self.isUploading = NO;
    
    for (HttpUploadImage *uploader in _uploaderArray) {
        if (uploader) {
            [uploader stopUpload];
        }
    }
    ///////////////////////////
    
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    self.tableView = nil;
    self.assetsPhotoArray = nil;
    [_uploaderArray removeAllObjects];
    self.uploaderArray = nil;
    self.backgroundPickerView = nil;
    _typePicker.dataSource = nil;
    _typePicker.delegate = nil;
    self.typePicker = nil;
    self.pickerViewDatasourceArray = nil;
    self.cellImageTypeArray = nil;
    self.cellImageNameArray = nil;
    self.allImageTypeDictionary = nil;
    self.uploadStatusArray = nil;
    self.guestRoomDictionary = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    // 键盘高度变化通知，ios5.0新增的
    if (IOSVersion_5) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    }
//    [self cancelUpload:nil];
    [[ElongAssetsLibraryController shareDataInstance] setRoomId:@""];
    
    [super dealloc];
}

- (id)initWithAssets:(NSArray *)assetsArray
{
    if (self = [super initWithTopImagePath:@"" andTitle:@"上传酒店图片" style:_NavOnlyBackBtnStyle_]) {
        UIBarButtonItem *doneItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"上传图片" Target:self Action:@selector(doUpload:)];
        self.navigationItem.rightBarButtonItem = doneItem;
        
        ButtonView *backbtn = [[ButtonView alloc] initWithFrame:CGRectMake(0, 0, 45, 35)];
        backbtn.image = [UIImage imageNamed:@"btn_navback_normal.png"];
        backbtn.highlightedImage = [UIImage imageNamed:nil];
        backbtn.delegate = self;
        backbtn.tag = kBackBtnTag;
        backbtn.canCancelSelected = NO;
        UIBarButtonItem * backbarbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
        self.navigationItem.leftBarButtonItem = backbarbuttonitem;
        [backbarbuttonitem release];
        [backbtn release];
        
        self.assetsPhotoArray = [NSMutableArray arrayWithArray:assetsArray];
        
        NSMutableArray *tempMutableArray = [NSMutableArray arrayWithCapacity:0];
        self.uploaderArray = tempMutableArray;
        
        // Cell显示需要的图片类型数组
        tempMutableArray = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger index = 0; index < [_assetsPhotoArray count]; index++) {
            [tempMutableArray addObject:@"请选择图片类型"];
        }
        self.cellImageTypeArray = tempMutableArray;
        
        // Cell显示需要的图片名称数组
        tempMutableArray = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger index = 0; index < [_assetsPhotoArray count]; index++) {
            [tempMutableArray addObject:@""];
        }
        self.cellImageNameArray = tempMutableArray;
        
        // Cell显示上传过程中的状态
        tempMutableArray = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger index = 0; index < [_assetsPhotoArray count]; index++) {
            [tempMutableArray addObject:@"准备上传"];
        }
        self.uploadStatusArray = tempMutableArray;
        
        // 所有图片类型字典对应API的传值
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HotelUploadImage" ofType:@"plist"];
        NSMutableDictionary *tempMutableDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        self.allImageTypeDictionary = tempMutableDictionary;
        [tempMutableDictionary release];
        
        self.guestRoomDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        NSArray *room = [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A];
        for (NSDictionary *roomDic in room) {
            [_guestRoomDictionary setValue:[roomDic safeObjectForKey:@"MRoomTypeId"] forKey:[roomDic safeObjectForKey:@"RoomTypeName"]];
//            [_allImageTypeDictionary setValue:[roomDic safeObjectForKey:@"RoomTypeId"] forKey:[roomDic safeObjectForKey:@"RoomTypeName"]];
        }
        
        UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, MAINCONTENTHEIGHT)];
        tempTableView.dataSource = self;
        tempTableView.delegate = self;
        self.tableView = tempTableView;
        [tempTableView release];
        [self.view addSubview:_tableView];
        
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setAllowsSelection:YES];
        if (IOSVersion_7) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        // 继续添加
        UIView *goonAddingView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 88.0f)] autorelease];
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 88.0f)];
        backgroundView.userInteractionEnabled = YES;
        backgroundView.image = [UIImage noCacheImageNamed:@"goon_add_image.png"];
        // 单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [backgroundView addGestureRecognizer:singleTap];
        [singleTap release];
        [goonAddingView addSubview:backgroundView];
        [backgroundView release];
        
        _tableView.tableFooterView = goonAddingView;
        if ([assetsArray count] < 30) {
            _tableView.tableFooterView.hidden = NO;
//            _tableView.tableFooterView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 88.0f);
        }
        else {
            _tableView.tableFooterView.hidden = YES;
//            _tableView.tableFooterView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 0.0f);
        }
        
        [self createTypePickerView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        // 键盘高度变化通知，ios5.0新增的
        if (IOSVersion_5) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        }
        
        self.cancelUpload = NO;
        self.doneUpload = NO;
    }
    return self;
}

- (NSString *)addWithAssets:(NSArray *)assetsArray
{
    if ([_assetsPhotoArray count] + [assetsArray count] > kImageCountThresold) {
        return @"您要添加的图片数量已经超过最大可上传图片数量30张";
    }
    else {
//        if ([_assetsPhotoArray count] + [assetsArray count] == kImageCountThresold) {
//            _tableView.tableFooterView.hidden = YES;
//        }
        
        [_assetsPhotoArray addObjectsFromArray:assetsArray];
        
        if ([_assetsPhotoArray count] < 30) {
            _tableView.tableFooterView.hidden = NO;
//            _tableView.tableFooterView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 88.0f);
        }
        else {
            _tableView.tableFooterView.hidden = YES;
//            _tableView.tableFooterView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 0.0f);
        }
        
        NSString *imageTypeString = nil;
        for (NSString *key in [_guestRoomDictionary allKeys]) {
            [_allImageTypeDictionary setValue:[_guestRoomDictionary safeObjectForKey:key] forKey:key];
            
            if ([[_guestRoomDictionary safeObjectForKey:key] isEqualToString:[[ElongAssetsLibraryController shareDataInstance] roomId]]) {
                imageTypeString = key;
                break;
            }
        }
        NSUInteger index = NSNotFound;
        
        if (STRINGHASVALUE(imageTypeString)) {
            index = [_pickerViewDatasourceArray indexOfObject:imageTypeString];
        }
        
        if (index != NSNotFound) {
            _pickerSelectedIndex = index;
            
            NSString *imageType = [_pickerViewDatasourceArray safeObjectAtIndex:index];
            for (NSInteger index = 0; index < [_assetsPhotoArray count]; index++) {
                [_cellImageTypeArray addObject:imageType];
                [_cellImageNameArray addObject:imageType];
                [_uploadStatusArray addObject:@"准备上传"];
            }
        }
        else {
            for (NSUInteger index = 0; index < [assetsArray count]; index++) {
                [_cellImageTypeArray addObject:@"请选择图片类型"];
                [_cellImageNameArray addObject:@""];
                [_uploadStatusArray addObject:@"准备上传"];
            }
        }
        
        [_tableView reloadData];
    }
    return nil;
}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
//    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];

    HotelUploadImageCell *cell = (HotelUploadImageCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    if (cell) {
        CGRect rectInTableView = [_tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
        CGRect rect = [_tableView convertRect:rectInTableView toView:[_tableView superview]];
        
        int heightDiff = rect.origin.y + 41.0f + 28.0f + 64 - keyboardRect.origin.y;
        
        if (heightDiff > 0) {
            self.lastOffset = _tableView.contentOffset;
            _tableView.contentOffset = CGPointMake(0.0f, heightDiff + 36);
        }
    }
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    _tableView.contentOffset = _lastOffset;
//    [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
}

#pragma mark - Create picker view.
- (void)createTypePickerView
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, SCREEN_HEIGHT, 320.0f, kPickerViewHeight + NAVIGATION_BAR_HEIGHT)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundPickerView = backgroundView;
    [self.view addSubview:_backgroundPickerView];
    [backgroundView release];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    topView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    [topView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 0.5f)]];
    
    // title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:FONT_B18];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setTextColor:RGBACOLOR(52, 52, 52, 1)];
    [titleLabel setText:@"选择图片类型"];
    [topView addSubview:titleLabel];
    [titleLabel release];
    
    UIImageView *topSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT - 0.5, SCREEN_WIDTH, 0.5)];
    topSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [topView addSubview:topSplitView];
    [topSplitView release];
    
    // left button
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 50, NAVIGATION_BAR_HEIGHT)];
    [leftBtn.titleLabel setFont:FONT_B16];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [leftBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftBtn];
    [leftBtn release];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 55, 0, 50, NAVIGATION_BAR_HEIGHT)];
    [rightBtn.titleLabel setFont:FONT_B16];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightBtn];
    [rightBtn release];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 180.0f)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    self.typePicker = pickerView;
    //    [pickerView selectRow:1 inComponent:0 animated:NO];
    //    [pickerView reloadComponent:0];
    
    [_backgroundPickerView addSubview:topView];
    [_backgroundPickerView addSubview:pickerView];
    
    [topView release];
    [pickerView release];
    
    NSMutableArray *datasource = [NSMutableArray arrayWithObjects:@"酒店外观", @"大堂", @"餐厅", @"休闲", @"公共区域", @"会议室", @"周边景点", @"其他", nil];
//    NSMutableArray *datasource = [NSMutableArray arrayWithObject:@"请选择图片类型"];
//    [datasource addObjectsFromArray:[_allImageTypeDictionary allKeys]];
//    NSMutableArray *datasource = [NSMutableArray arrayWithArray:[_allImageTypeDictionary allKeys]];
    self.pickerViewDatasourceArray = datasource;
    
    [_pickerViewDatasourceArray addObjectsFromArray:[_guestRoomDictionary allKeys]];
    [_pickerViewDatasourceArray addObject:@"卫生间"];
    
    NSString *imageTypeString = nil;
    for (NSString *key in [_guestRoomDictionary allKeys]) {
        [_allImageTypeDictionary setValue:[_guestRoomDictionary safeObjectForKey:key] forKey:key];
        
        if ([[_guestRoomDictionary safeObjectForKey:key] isEqualToString:[[ElongAssetsLibraryController shareDataInstance] roomId]]) {
            imageTypeString = key;
            break;
        }
    }
    NSUInteger index = NSNotFound;
    
    if (STRINGHASVALUE(imageTypeString)) {
        index = [_pickerViewDatasourceArray indexOfObject:imageTypeString];
    }
    
    if (index != NSNotFound) {
        _pickerSelectedIndex = index;
        
        NSString *imageType = [_pickerViewDatasourceArray safeObjectAtIndex:index];
        for (NSInteger index = 0; index < [_assetsPhotoArray count]; index++) {
            [_cellImageTypeArray replaceObjectAtIndex:index withObject:imageType];
            [_cellImageNameArray replaceObjectAtIndex:index withObject:imageType];
        }
    }
}

#pragma mark - PickerView Private methods.
- (void)showTypePickerView
{
    [_typePicker selectRow:_pickerSelectedIndex inComponent:0 animated:YES];
//    self.selectedInsuranceString = [_pickerViewDatasourceArray objectAtIndex:_pickerSelectedIndex];

    [UIView animateWithDuration:0.5f animations:^{
        self.backgroundPickerView.frame = CGRectMake(0.0f, SCREEN_HEIGHT - (kPickerViewHeight + NAVIGATION_BAR_HEIGHT), 320.0f, kPickerViewHeight + NAVIGATION_BAR_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}

- (void)dismissInView {
    [UIView animateWithDuration:SHOW_WINDOWS_DEFAULT_DURATION delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundPickerView.frame = CGRectMake(0.0f, SCREEN_HEIGHT, 320.0f, kPickerViewHeight + NAVIGATION_BAR_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}

- (void) cancelBtnClick{
    [self dismissInView];
}


- (void)confirmBtnClick {
    [self dismissInView];
    [_cellImageTypeArray replaceObjectAtIndex:_selectedIndex withObject:[_pickerViewDatasourceArray safeObjectAtIndex:_pickerSelectedIndex]];
    [_cellImageNameArray replaceObjectAtIndex:_selectedIndex withObject:[_pickerViewDatasourceArray safeObjectAtIndex:_pickerSelectedIndex]];
    
    [_tableView reloadData];
}

#pragma mark - Private methods.
- (void)singleTap
{
    [self dismissInView];
    
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    menu.delegate			= self;
    menu.actionSheetStyle	= UIBarStyleBlackTranslucent;
    [menu showInView:self.view];
    [menu release];
}

//- (void)back
//{
//    BOOL uploading = NO;
//    for (NSString *state in _uploadStatusArray) {
//        if ([state isEqualToString:@"上传中"]) {
//            uploading = YES;
//            break;
//        }
//    }
//    
//    if (uploading) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"返回会取消上传,确定返回?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
//        [alert release];
//    }
//    else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定返回重新上传图片?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alert show];
//        [alert release];
//    }
//}

- (BOOL)validateComplete
{
    for (NSInteger index = 0; index < [_assetsPhotoArray count]; index++) {
        if ([[_uploadStatusArray safeObjectAtIndex:index] isEqualToString:@"准备上传"] || [[_uploadStatusArray safeObjectAtIndex:index] isEqualToString:@"上传中"]) {
            return NO;
        }
    }
    
    return YES;
}

- (NSString *)validateImageInfos
{
    NSString *errorStr = nil;
    
    for (NSInteger index = 0; index < [_assetsPhotoArray count]; index++) {
        if ([[_cellImageTypeArray safeObjectAtIndex:index] isEqualToString:@"请选择图片类型"] || [[_cellImageNameArray safeObjectAtIndex:index] isEqualToString:@""]) {
            errorStr = @"请您选择图片类型后再上传";
        }
    }
    
    return errorStr;
}

- (void)doneUpload:(id)sender
{
    [super back];
}

- (void)cancelUpload:(id)sender
{
    self.cancelUpload = YES;
    self.isUploading = NO;
    
    for (HttpUploadImage *uploader in _uploaderArray) {
        if (uploader) {
            [uploader stopUpload];
        }
    }
    
    for (NSInteger index = 0; index < [_uploaderArray count]; index++) {
        if (index < [_uploadStatusArray count]) {
            NSString *stateString = [_uploadStatusArray safeObjectAtIndex:index];
            if (STRINGHASVALUE(stateString) && [stateString isEqualToString:@"上传成功等待审核"]) {
                continue;
            }
            [_uploadStatusArray replaceObjectAtIndex:index withObject:@"准备上传"];
        }
    }
    [_tableView reloadData];
    
    if ([_assetsPhotoArray count] < 30) {
        //        _tableView.tableFooterView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 88.0f);
        _tableView.tableFooterView.hidden = NO;
    }
    else {
        _tableView.tableFooterView.hidden = YES;
    }
    
    if (_isDelaying) {
        [Utils alert:@"请您不要点击的过于频繁"];
        return;
    }
    self.isDelaying = YES;
    if (self) {
        [self performSelector:@selector(cancelUploadDelay) withObject:nil afterDelay:1.0f];
    }
//    self.cancelUpload = NO;
}

- (void)cancelUploadDelay
{
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *doneItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"上传图片" Target:self Action:@selector(doUpload:)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    self.isDelaying = NO;
}

- (void)doAsyncUpload:(NSUInteger)index
{
    @autoreleasepool {
        if (index >= [_assetsPhotoArray count] && _cancelUpload && [_uploaderArray safeObjectAtIndex:index]) {
            return;
        }
        
        // 上传成功不再上传
        NSString *stateString = [_uploadStatusArray safeObjectAtIndex:index];
        if (STRINGHASVALUE(stateString) && [stateString isEqualToString:@"上传成功等待审核"]) {
            if (index + 1 < kImageCountThresold) {
                [self doAsyncUpload:index + 1];
            }
            return;
        }
//        __block NSUInteger uploaderTag = index;
        __block ALAsset *alAsset = (ALAsset *)[_assetsPhotoArray safeObjectAtIndex:index];
        __block NSData *imageData = [NSMutableData dataWithCapacity:0];
        
//        NSString *uploadQueueName = [NSString stringWithFormat:@"uploadQueue%d", index];
//        dispatch_queue_t uploadQueue = dispatch_queue_create([uploadQueueName UTF8String], DISPATCH_QUEUE_CONCURRENT);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // Compose parameters.
            NSMutableDictionary *hotelDictionary = [HotelDetailController hoteldetail];
            NSMutableDictionary *uploadInfo = [NSMutableDictionary dictionaryWithCapacity:0];
            [uploadInfo setValue:[hotelDictionary safeObjectForKey:@"HotelId"] forKey:@"hotelId"];
            [uploadInfo setValue:[hotelDictionary safeObjectForKey:@"HotelName"] forKey:@"hotelName"];
            [uploadInfo setValue:[NSString stringWithFormat:@"%@%@", [hotelDictionary safeObjectForKey:@"HotelName"], [[ElongAssetsLibraryController shareDataInstance] roomId]] forKey:@"imgName"];
            [uploadInfo setValue:[_cellImageNameArray safeObjectAtIndex:index] forKey:@"imgDesc"];
            NSString *imageType = [_allImageTypeDictionary safeObjectForKey:[_cellImageTypeArray safeObjectAtIndex:index]];
            if ([imageType length] != 4 || [imageType integerValue] != 0) {
                [uploadInfo setValue:[_allImageTypeDictionary safeObjectForKey:[_cellImageTypeArray safeObjectAtIndex:index]] forKey:@"imgType"];
            }
            else if ([imageType length] == 4 && [imageType integerValue] == 0){
                [uploadInfo setValue:@"8" forKey:@"imgType"];
                [uploadInfo setValue:[_allImageTypeDictionary safeObjectForKey:[_cellImageTypeArray safeObjectAtIndex:index]] forKey:@"roomIds"];
                [uploadInfo setValue:[_cellImageTypeArray safeObjectAtIndex:index] forKey:@"roomTypeNames"];
            }
            
            if (STRINGHASVALUE([[AccountManager instanse] name])) {
                [uploadInfo setValue:[[AccountManager instanse] name] forKey:@"uploadAuthor"];
            }
            else {
                [uploadInfo setValue:@"艺龙用户" forKey:@"uploadAuthor"];
            }
            
            //        UIImage *postImage = [UIImage imageWithCGImage:alAsset.thumbnail];
//            NSData *imageData = [[NSMutableData alloc] initWithCapacity:0];
            
            @autoreleasepool {
                UIImage *postImage = [UIImage imageWithCGImage:[[alAsset defaultRepresentation] fullResolutionImage] scale:[[alAsset defaultRepresentation] scale] orientation:[[alAsset defaultRepresentation] orientation]];
                
                NSString *imageName = [[[alAsset defaultRepresentation] url] absoluteString];
                imageName = [imageName lowercaseString];
                
                ImageType imageType = ImageTypeJPEG;
                
                if ([imageName rangeOfString:@"jpg"].location != NSNotFound) {
                    imageData = UIImageJPEGRepresentation(postImage, 1.0);
                    imageType = ImageTypeJPEG;
                }
                else if ([imageName rangeOfString:@"png"].location != NSNotFound) {
                    imageData = UIImagePNGRepresentation(postImage);
                    imageType = ImageTypePNG;
                }
                
                NSUInteger imageFileSize = [imageData length];
                //            NSUInteger imageNewFileSize = [[alAsset defaultRepresentation] size];
                
                CGFloat factor = 1.0;
                while (imageFileSize > 2097152) {
                    //        postImage = [postImage compressImageWithSize:CGSizeMake(1936, 2592)];
                    postImage = [postImage compressImageWithSize:CGSizeMake(968 * factor, 1296 * factor)];
                    if (imageType == ImageTypeJPEG) {
                        imageData = UIImageJPEGRepresentation(postImage, 1.0);
                    }
                    else if (imageType == ImageTypePNG) {
                        imageData = UIImagePNGRepresentation(postImage);
                    }
                    imageFileSize = [imageData length];
                    factor -= 0.1;
                }
                [imageData retain];
                //        NSString *imageMD5 = [NSString FileMD5hash:[alAsset defaultRepresentation]];
                NSString *imageMD5 = [imageData md5Coding];
                [uploadInfo setValue:imageMD5 forKey:@"imgMD5"];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 取消的时候更改状态
                if (_cancelUpload) {
                    [imageData release];
                    
                    for (HttpUploadImage *uploader in _uploaderArray) {
                        [uploader stopUpload];
                    }
//                    HttpUploadImage *uploader = (HttpUploadImage *)[_uploaderArray safeObjectAtIndex:index];
//                    if (uploader) {
//                        
//                    }
                    
                    for (NSInteger i = 0; i < [_uploadStatusArray count]; i++) {
                        NSString *stateString = [_uploadStatusArray safeObjectAtIndex:i];
                        if (STRINGHASVALUE(stateString) && [stateString isEqualToString:@"上传成功等待审核"]) {
                            continue;
                        }
                        [_uploadStatusArray replaceObjectAtIndex:i withObject:@"准备上传"];
                    }
                    
                    [_tableView reloadData];
                    
                    self.cancelUpload = NO;
                    return;
                }
                
                HttpUploadImage *uploader = (HttpUploadImage *)[_uploaderArray safeObjectAtIndex:index];
                if (uploader == nil) {
                    uploader = [[HttpUploadImage alloc] initWithParamsJsonString:[uploadInfo JSONString] imageAssets:alAsset imageData:imageData];
                    [_uploaderArray addObject:uploader];
                    [uploader release];
                }
                if (index < [_uploadStatusArray count]) {
                    [_uploadStatusArray replaceObjectAtIndex:index withObject:@"上传中"];
                }
                uploader.tag = index;
                uploader.delegate = self;
                
                if (_cancelUpload) {
                    [_uploaderArray removeLastObject];
                }
                [uploader startUpload];
                
                
                [_tableView reloadData];
                if (index + 1 < kImageCountThresold) {
                    if (_cancelUpload) {
                        return;
                    }
                    [self doAsyncUpload:index + 1];
                }
            });
            
        });
    }
}

- (void)doUpload:(id)sender
{
    [self dismissInView];
    
    if ([_assetsPhotoArray count] == 0) {
        [Utils alert:@"没有可上传的图片"];
        return;
    }
    
    NSString *msg = [self validateImageInfos];
    if (msg) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else {
        if (_isDelaying) {
            [Utils alert:@"请您不要点击的过于频繁"];
            return;
        }
        self.isDelaying = YES;
        if (self) {
            [self performSelector:@selector(doUploadDelay) withObject:nil afterDelay:1.0f];
        }
    }
}

- (void)doUploadDelay
{
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *cancelItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"取消上传" Target:self Action:@selector(cancelUpload:)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    
    self.isUploading = YES;
    self.cancelUpload = NO;
    [self doAsyncUpload:0];
    
    _tableView.tableFooterView.hidden = YES;
    self.isDelaying = NO;
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if ([_assetsPhotoArray count] < 30 && !_doneUpload && !_isUploading) {
//        return [_assetsPhotoArray count] + 1;
//    }
//    else {
//        return [_assetsPhotoArray count];
//    }
    return [_assetsPhotoArray count];
}


//图片上传，json定义：
//
//String hotelId   酒店Id（必传）
//String hotelName    酒店名称（必传）
//String imgName       图片名称（必传）
//String imgDesc         图片描述（必传）
//String imgType          图片类型1-餐厅 2-休闲 3-会议室 5-酒店外观 6-大堂 8-客房 10-其他 11-公共区域（必传）
//String uploadAuthor         上传者（必传）
//String imgMD5         图片文件md5码，使用全小写（必传）
//
//String imgKey  图片唯一标识（选传）
//int pieceIndex  图片当前片索引（选传）
//int pieceCount 图片分片总数（选传）
//其中最后三项用于分片传输，这期不做，可以不传。
//例如：
//{"hotelId":"12345678","hotelName":"北京饭店","imgName":"北京酒店图片","imgDesc":"酒店不错","imgType":"1","uploadAuthor":"tester","imgMD5":"c20ad4d76fe97759aa27a0c99bff6710"}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
//    if (indexPath.row != [_assetsPhotoArray count]) {   
//    }
    HotelUploadImageCell *cell = (HotelUploadImageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[HotelUploadImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.imageName.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, 88.0f - 0.51f, 320.0f, 0.51f)]];
    }
    cell.tag = indexPath.row;
    ALAsset *alAsset = (ALAsset *)[_assetsPhotoArray safeObjectAtIndex:indexPath.row];
    //        CGRect imageViewRect = cell.imageView.frame;
    //        imageViewRect.origin.x = 0.0f;
    //        cell.imageView.frame = imageViewRect;
    cell.imageView.image = [UIImage imageWithCGImage:alAsset.thumbnail];
    [cell.imageTypeButton setTitle:[_cellImageTypeArray safeObjectAtIndex:indexPath.row] forState:UIControlStateNormal];
    cell.imageTypeButton.titleLabel.text = [_cellImageTypeArray safeObjectAtIndex:indexPath.row];
    cell.imageName.text = [_cellImageNameArray safeObjectAtIndex:indexPath.row];
    cell.statusLabel.text = [_uploadStatusArray safeObjectAtIndex:indexPath.row];
    if ([[_uploadStatusArray safeObjectAtIndex:indexPath.row] isEqualToString:@"上传中"]) {
        [cell.loadingView startAnimating];
    }
    else {
        [cell.loadingView stopAnimating];
    }
    //    cell.textLabel.text = [NSString stringWithFormat:@"大小:%lld kb", [[alAsset defaultRepresentation] size] / 1024];
    //    [cell setAssets:[self assetsForIndexPath:indexPath]];
    
    return cell;
    
//    else {
//        // 继续添加
//        UITableViewCell *goonAddingCell = [[[UITableViewCell alloc] init] autorelease];
//        goonAddingCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 88.0f)];
//        backgroundView.image = [UIImage noCacheImageNamed:@"goon_add_image.png"];
//        [goonAddingCell addSubview:backgroundView];
//        [backgroundView release];
//        return goonAddingCell;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 88;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[_uploadStatusArray safeObjectAtIndex:indexPath.row] isEqualToString:@"准备上传"] && indexPath.row < [_assetsPhotoArray count] && !_isUploading) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_assetsPhotoArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        _tableView.tableFooterView.hidden = NO;
//        _tableView.tableFooterView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 88.0f);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 继续添加按钮点击处理
//    if (indexPath.row == [_assetsPhotoArray count]) {
//        UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
//        menu.delegate			= self;
//        menu.actionSheetStyle	= UIBarStyleBlackTranslucent;
//        [menu showInView:self.view];
//        [menu release];
//    }
}

#pragma mark - HttpUploadImageDelegate.
- (void)imageUploadDone:(NSIndexPath *)indexPath returnData:(NSMutableData *)data
{
    if (indexPath.row >= [_uploadStatusArray count]) {
        return;
    }
//    NSDictionary *responseInfo = [PublicMethods unCompressData:[NSData dataWithData:data]];
    NSDictionary *responseInfo = nil;
    if (data.length > 0) {
        if (!IOSVersion_5) {
            NSString* jsonStr;
            jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            // 使用JOSNKIT框架解析
            responseInfo = [jsonStr JSONValue];
            [jsonStr release];
        }
        else {
            // 使用系统自带的解析JSON
            NSError *error;
            responseInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        }
    }
    
    if (![[responseInfo safeObjectForKey:@"IsError"] boolValue]) {
        [_uploadStatusArray replaceObjectAtIndex:indexPath.row withObject:@"上传成功等待审核"];
    }
    else {
        [_uploadStatusArray replaceObjectAtIndex:indexPath.row withObject:@"上传失败"];
    }
    
    [_tableView reloadData];
    
    self.isConnectionDisconnect = NO;
    
    if ([self validateComplete]) {
        self.navigationItem.rightBarButtonItem = nil;
        UIBarButtonItem *doneItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"完成" Target:self Action:@selector(doneUpload:)];
        self.navigationItem.rightBarButtonItem = doneItem;
        self.doneUpload = YES;
        self.isUploading = NO;
        [_tableView reloadData];
    }
}

- (void)imageUploadError:(NSIndexPath *)indexPath error:(NSError *)error
{
    if (indexPath.row >= [_uploadStatusArray count]) {
        return;
    }
    
    [_uploadStatusArray replaceObjectAtIndex:indexPath.row withObject:@"上传失败"];
    [_tableView reloadData];
    
    if (!_isConnectionDisconnect) {
        if ([[error domain] isEqualToString:@"NSURLErrorDomain"]) {
            [Utils alert:[error localizedDescription]];
        }
        self.isConnectionDisconnect = YES;
    }
    
    if ([self validateComplete]) {
        self.navigationItem.rightBarButtonItem = nil;
        UIBarButtonItem *doneItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"上传" Target:self Action:@selector(doUpload:)];
        self.navigationItem.rightBarButtonItem = doneItem;
        self.isUploading = NO;
    }
}

#pragma mark - HotelUploadImageCellDelegate
- (void)imageNameTextFieldBeginEdit:(NSUInteger)cellTag
{
    [self dismissInView];
    self.selectedIndex = cellTag;
}

- (void)imageNameTextFieldReturn:(NSString *)name tag:(NSUInteger)cellTag;
{
//    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    self.selectedIndex = cellTag;
    if (STRINGHASVALUE(name)) {
        [_cellImageNameArray replaceObjectAtIndex:cellTag withObject:name];
    }
    else {
        [_cellImageNameArray replaceObjectAtIndex:cellTag withObject:@""];
    }
    
//    [_tableView reloadData];
}

- (void)imageTypeButtonClicked:(NSUInteger)cellTag
{
    HotelUploadImageCell *cell = (HotelUploadImageCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    if (cell) {
        [self.view endEditing:YES];
    }
    
    // 非“准备上传”状态不能点选
    if (![[_uploadStatusArray safeObjectAtIndex:cellTag] isEqualToString:@"准备上传"]) {
        return;
    }
    
    self.selectedIndex = cellTag;
    
    [self showTypePickerView];
}

#pragma mark - UIPickerView datasource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_pickerViewDatasourceArray count];
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 320.0f;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.pickerSelectedIndex = row;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_pickerViewDatasourceArray objectAtIndex:row];
    
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if ([_assetsPhotoArray count] == 30) {
            [Utils alert:@"最大上传30张图片,您已经选择了30张图片"];
            return;
        }
        
        //创建图片选择器
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        //指定源类型前，检查图片源是否可用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            //指定源的类型
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            //在选定图片之前，用户可以简单编辑要选的图片。包括上下移动改变图片的选取范围，用手捏合动作改变图片的大小等。
            //        imagePicker.allowsEditing = YES;
            
            //实现委托，委托必须实现UIImagePickerControllerDelegate协议，来对用户在图片选取器中的动作
            imagePicker.delegate = self;
            
            //设置完iamgePicker后，就可以启动了。用以下方法将图像选取器的视图“推”出来
            [self presentModalViewController:imagePicker animated:YES];
        }
        else
        {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"相机不能用" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        [imagePicker release];
    }else if(buttonIndex == 1){
        ELongAssetsPickerController *elongAssetsPickerController = [[ELongAssetsPickerController alloc] init];
        elongAssetsPickerController.invoker = self;
        // 改为添加的方式
        [self.navigationController pushViewController:elongAssetsPickerController animated:YES];
        [elongAssetsPickerController release];
    }
}

#pragma mark -
#pragma mark UIImagePickerController Method
//完成拍照
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (IOSVersion_5) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [picker dismissModalViewControllerAnimated:YES];
    }
    
    [[LoadingView sharedLoadingView] showAlertMessageNoCancel];
    
    [[ElongAssetsLibraryController shareInstance] writeImageToSavedPhotosAlbum:[[info objectForKey:UIImagePickerControllerOriginalImage] CGImage] orientation:(ALAssetOrientation)[[info objectForKey:UIImagePickerControllerOriginalImage] imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        [[LoadingView sharedLoadingView] hideAlertMessage];
        ALAssetsLibraryAssetForURLResultBlock resultsBlock = ^(ALAsset *asset) {
            if (asset) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self addWithAssets:[NSArray arrayWithObject:asset]];
                });
            }
            else {
                [Utils alert:@"存取相册错误, 请检查手机空间是否不足"];
            }
        };
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error){
            /*  A failure here typically indicates that the user has not allowed this app access
             to location data. In that case the error code is ALAssetsLibraryAccessUserDeniedError.
             In principle you could alert the user to that effect, i.e. they have to allow this app
             access to location services in Settings > General > Location Services and turn on access
             for this application.
             */
            NSLog(@"FAILED! due to error in domain %@ with error code %d", error.domain, error.code);
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"存取相册错误" message:@"请在 设置-隐私-照片中，打开艺龙旅行的访问权限" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
        };
        
        // Get the asset for the asset URL to create a screen image.
        [[ElongAssetsLibraryController shareInstance] assetForURL:assetURL resultBlock:resultsBlock failureBlock:failureBlock];
    }];
}
//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (IOSVersion_5) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [picker dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - UIAlertView delegate.
- (void) alertView:(UIAlertView *)alertview clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) {
        [self cancelUpload:nil];
        [super back];
    }
}

#pragma mark -
#pragma mark ButtonView Delegate

- (void)ButtonViewIsPressed:(ButtonView *)button {
//	button.highlighted = YES;
//	[self performSelector:@selector(restoreStateOfButton:) withObject:button afterDelay:0.2];
//	[self.navigationController popViewControllerAnimated:YES];
    if ([self validateComplete]) {
        [super back];
        return;
    }
    
    BOOL uploading = NO;
    for (NSString *state in _uploadStatusArray) {
        if ([state isEqualToString:@"上传中"]) {
            uploading = YES;
            break;
        }
    }
    
    if (uploading) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"返回会取消上传,确定返回?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定返回重新上传图片?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
    }
    button.canCancelSelected = YES;
}

- (void)restoreStateOfButton:(ButtonView *)button {
//	button.highlighted = NO;
}

@end
