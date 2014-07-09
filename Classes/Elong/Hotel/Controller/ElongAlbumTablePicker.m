//
//  ElongAlbumTablePicker.m
//  ElongClient
//
//  Created by chenggong on 14-3-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongAlbumTablePicker.h"
#import "ElongAlbumAssetCell.h"
#import "HotelUploadPhotosController.h"

@interface ElongAlbumTablePicker()

@property (nonatomic, assign) int columns;
@property (nonatomic, retain) UITableView *tableView;

@end


@implementation ElongAlbumTablePicker

- (id)initWithAssetGroup:(ALAssetsGroup *)asGroup
{
//    self = [super init];
//    if (self) {
    if (self = [super initWithTopImagePath:@"" andTitle:@"上传酒店图片" style:_NavOnlyBackBtnStyle_]){
        //Sets a reasonable default bigger then 0 for columns
        //So that we don't have a divide by 0 scenario
        self.columns = 4;
        
        UIBarButtonItem *doneItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"完成" Target:self Action:@selector(doneAction:)];
        self.navigationItem.rightBarButtonItem = doneItem;
        
        UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, MAINCONTENTHEIGHT)];
        tempTableView.dataSource = self;
        tempTableView.delegate = self;
        self.tableView = tempTableView;
        [tempTableView release];
        [self.view addSubview:_tableView];
        
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setAllowsSelection:NO];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        self.albumAssets = tempArray;
        [tempArray release];
        
        self.assetGroup = asGroup;
        [_assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
    }
    return self;
}

- (void)dealloc
{
    self.assetGroup = nil;
    self.albumAssets = nil;
    
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    self.tableView = nil;
    
    self.uploader = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.columns = self.view.bounds.size.width / 80;
}

- (void)preparePhotos
{
    @autoreleasepool {
        
        [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result == nil) {
                return;
            }
            
            ElongAlbumAsset *elAsset = [[ElongAlbumAsset alloc] initWithAsset:result];
            [elAsset setDelegate:self];
            
            BOOL isAssetFiltered = NO;
            
            NSString *type = [result valueForProperty:ALAssetPropertyType];
            NSString *assetUrl = [[[result defaultRepresentation] url] absoluteString];
            NSUInteger typeLocation = [assetUrl rangeOfString:@"ext="].location;
            NSString *imageType;
            if (typeLocation != NSNotFound) {
                imageType = [assetUrl substringFromIndex:typeLocation + 4];
            }
            imageType = [imageType lowercaseString];
//            // 根据图片名字，判断类型
//            NSString *imageName = [[result defaultRepresentation] filename];
//            imageName = [imageName lowercaseString];
//            NSArray *imageTypeSeperate = [imageName componentsSeparatedByString:@"."];
//            NSString *imageType = [imageTypeSeperate safeObjectAtIndex:[imageTypeSeperate count] - 1];
//            imageType = [imageType lowercaseString];
            
            // 过滤, 只需要媒体类型是图片
            if (!isAssetFiltered && [type isEqualToString:ALAssetTypePhoto] && STRINGHASVALUE(imageType) && ([imageType isEqualToString:@"jpg"] || [imageType isEqualToString:@"jpeg"] || [imageType isEqualToString:@"png"])) {
                [self.albumAssets addObject:elAsset];
            }
            
        }];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            // scroll to bottom
//            long section = [self numberOfSectionsInTableView:self.tableView] - 1;
//            long row = [self tableView:self.tableView numberOfRowsInSection:section] - 1;
//            if (section >= 0 && row >= 0) {
//                NSIndexPath *ip = [NSIndexPath indexPathForRow:row
//                                                     inSection:section];
//                [self.tableView scrollToRowAtIndexPath:ip
//                                      atScrollPosition:UITableViewScrollPositionBottom
//                                              animated:NO];
//            }
            
//            [self.navigationItem setTitle:@"上传酒店图片"];
        });
    }
}

- (void)doneAction:(id)sender
{
    NSMutableArray *selectedAssetsImages = [[[NSMutableArray alloc] init] autorelease];
    
    for (ElongAlbumAsset *elAsset in self.albumAssets) {
        if ([elAsset selected]) {
            [selectedAssetsImages addObject:[elAsset asset]];
        }
    }
    
    if ([selectedAssetsImages count] == 0) {
        [Utils alert:@"请您选择图片后上传"];
        return;
    }
    
    if (_uploader != nil) {
        NSString *uploaderMessage = [_uploader addWithAssets:selectedAssetsImages];
        if (uploaderMessage == nil) {
            [self.navigationController popToViewController:_uploader animated:NO];
        }
        else {
            [Utils alert:uploaderMessage];
        }
    }
    else {
        if ([selectedAssetsImages count] > 30) {
            [Utils alert:@"一次最多只能上传30张图片"];
            return;
        }
        
        HotelUploadPhotosController *uploader = [[[HotelUploadPhotosController alloc] initWithAssets:selectedAssetsImages] autorelease];
        [self.navigationController pushViewController:uploader animated:YES];
        NSMutableArray *savedViewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [savedViewControllers removeObjectsInRange:NSMakeRange([savedViewControllers count] - 3, 2)];
        [self.navigationController setViewControllers:savedViewControllers animated:NO];
    }
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.columns <= 0) { //Sometimes called before we know how many columns we have
        self.columns = 4;
    }
    NSInteger numRows = ceil([self.albumAssets count] / (float)self.columns);
    return numRows;
}

- (NSArray *)assetsForIndexPath:(NSIndexPath *)path
{
    long index = path.row * self.columns;
    long length = MIN(self.columns, [self.albumAssets count] - index);
    return [self.albumAssets subarrayWithRange:NSMakeRange(index, length)];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ElongAlbumAssetCell *cell = (ElongAlbumAssetCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[ElongAlbumAssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell setAssets:[self assetsForIndexPath:indexPath]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 79;
}

@end
