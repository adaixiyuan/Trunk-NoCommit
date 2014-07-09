//
//  ELongAssetsPickerController.m
//  ElongClient
//
//  Created by chenggong on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ELongAssetsPickerController.h"
#import "ElongAlbumTablePicker.h"
#import "ElongAssetsLibraryController.h"

#define kTableViewTag 1024

#pragma mark - Interfaces

@interface ELongAssetsPickerController ()

@property (nonatomic, retain) NSMutableArray *assetGroups;
@property (nonatomic, retain) UITableView *albumPickerTableView;
//@property (nonatomic, retain) ALAssetsLibrary *library;

@end

#pragma mark - ELongAssetsPickerController

@implementation ELongAssetsPickerController

- (void)dealloc
{
    self.assetGroups = nil;
    _albumPickerTableView.dataSource = nil;
    _albumPickerTableView.delegate = nil;
    self.albumPickerTableView = nil;
//    self.library = nil;
    self.invoker = nil;
    
    [super dealloc];
}

- (id)init
{
    if (self = [super initWithTopImagePath:@"" andTitle:@"上传酒店图片" style:_NavOnlyBackBtnStyle_]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        self.assetGroups = tempArray;
        [tempArray release];
        
//        UIBarButtonItem *takePhotoItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"     拍照"
//                                                                            Target:self
//                                                                            Action:@selector(takePhoto:)];
//        self.navigationItem.rightBarButtonItem = takePhotoItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 访问相册
//    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
//    self.library = assetLibrary;
//    [assetLibrary release];
    
    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^
    {
       @autoreleasepool {
           // Group enumerator Block
           void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
           {
               if (group == nil) {
                   return;
               }
               
               // added fix for camera albums order
               NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
               NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
               
               if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                   [self.assetGroups insertObject:group atIndex:0];
               }
               else {
                   [self.assetGroups addObject:group];
               }
               
               // Load albums
               [self performSelectorOnMainThread:@selector(createTableView) withObject:nil waitUntilDone:YES];
           };
           
           // Group Enumerator Failure Block
           void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
               
               if (error.code == ALAssetsLibraryAccessUserDeniedError) {
                   UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"获取相册错误" message:@"请在 设置-隐私-照片中，打开艺龙旅行的访问权限" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                   [alert show];
                   [alert release];
               }
               else {
                   UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"访问错误" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                   [alert show];
                   [alert release];
               }
//               NSLog(@"A problem occured %@", [error description]);	                                 
           };
           
           // Enumerate Albums
           [[ElongAssetsLibraryController shareInstance] enumerateGroupsWithTypes:ALAssetsGroupAll
                                       usingBlock:assetGroupEnumerator 
                                     failureBlock:assetGroupEnumberatorFailure];
           
       }
    });
}

- (void)createTableView
{
	UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, MAINCONTENTHEIGHT)];
    tempTableView.tag = kTableViewTag;
    tempTableView.dataSource = self;
    tempTableView.delegate = self;
    [tempTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tempTableView];
    [tempTableView release];
}

- (void)reloadSelfTableView
{
    UITableView *selfTableView = (UITableView *)[self.view viewWithTag:kTableViewTag];
    [selfTableView reloadData];
}

#pragma mark - Private method.
- (void)takePhoto:(id)sender
{
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
        
        [imagePicker release];
    }
    else
    {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"相机不能用" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [imagePicker release];
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    // 重新载入相册
    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       @autoreleasepool {
                           // Group enumerator Block
                           void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
                           {
                               if (group == nil) {
                                   return;
                               }
                               
                               // added fix for camera albums order
                               NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
                               NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
                               
                               if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                                   [self.assetGroups insertObject:group atIndex:0];
                               }
                               else {
                                   [self.assetGroups addObject:group];
                               }
                               
                               // Load albums
                               [self performSelectorOnMainThread:@selector(reloadSelfTableView) withObject:nil waitUntilDone:YES];
                           };
                           
                           // Group Enumerator Failure Block
                           void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                               
                               UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                               [alert show];
                               
                               NSLog(@"A problem occured %@", [error description]);	                                 
                           };	
                           
                           // Enumerate Albums
                           [[ElongAssetsLibraryController shareInstance] enumerateGroupsWithTypes:ALAssetsGroupAll
                                                   usingBlock:assetGroupEnumerator 
                                                 failureBlock:assetGroupEnumberatorFailure];
                           
                       }
                   });
}

#pragma mark -
#pragma mark UIImagePickerController Method
//完成拍照
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerOriginalImage],
                                   self,
                                   @selector(imageSavedToPhotosAlbum:
                                             didFinishSavingWithError:
                                             contextInfo:),
                                   nil);
//    UIImage *gotImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    __block CIImage *image = nil;
//    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//        // sourceType为UIImagePickerControllerSourceTypeCamera的时候
//        // 会有UIImagePickerControllerMediaMetadata
//        image = [CIImage imageWithCGImage:gotImage.CGImage
//                                  options:@{kCIImageProperties : [info  objectForKey:UIImagePickerControllerMediaMetadata]}];
//    } else {
//        // 依赖AssetsLibrary框架
//        void (^resultBlock) (ALAsset*) = ^(ALAsset *asset) {
//            image = [CIImage imageWithCGImage:gotImage.CGImage
//                                      options:@{kCIImageProperties : asset.defaultRepresentation.metadata}];
//        };
//        ALAssetsLibrary * lib = [[ALAssetsLibrary alloc] init];
//        [lib assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL]
//             resultBlock:resultBlock failureBlock:nil];
//    }
//    NSLog(@"%@", image.properties);
}
//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.assetGroups count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, 57.0f - 0.51f, 320.0f, 0.51f)]];
    }
    
    // Get count
    ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
    [g setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger gCount = [g numberOfAssets];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",[g valueForProperty:ALAssetsGroupPropertyName], (long)gCount];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row] posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_assetGroups && [_assetGroups count] > 0) {
        ElongAlbumTablePicker *picker = [[ElongAlbumTablePicker alloc] initWithAssetGroup:[self.assetGroups objectAtIndex:indexPath.row]];
        //	picker.delegate = self;
        if (_invoker != nil) {
            picker.uploader = _invoker;
        }
        
//        picker.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
//        [picker.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        //	picker.assetPickerFilterDelegate = self.assetPickerFilterDelegate;
        if (picker.assetGroup.numberOfAssets > 0) {
            [self.navigationController pushViewController:picker animated:YES];
        }
        
        [picker release];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 57;
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super back];
}

@end
