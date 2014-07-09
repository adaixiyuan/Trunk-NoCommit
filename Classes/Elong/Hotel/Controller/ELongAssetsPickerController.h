//
//  ELongAssetsPickerController.h
//  ElongClient
//
//  Created by chenggong on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DPNav.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "HotelUploadPhotosController.h"

//@protocol ELongAssetsPickerControllerDelegate;

@interface ELongAssetsPickerController : DPNav<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

/// The assets picker’s delegate object.
//@property (nonatomic, assign) id <ELongAssetsPickerControllerDelegate> delegate;

/// Set the ALAssetsFilter to filter the picker contents.
@property (nonatomic, retain) ALAssetsFilter *assetsFilter;

/// The maximum number of assets to be picked.
@property (nonatomic, assign) NSInteger maximumNumberOfSelection;

@property (nonatomic, retain) HotelUploadPhotosController *invoker;

/**
 Determines whether or not the cancel button is visible in the picker
 @discussion The cancel button is visible by default. To hide the cancel button, (e.g. presenting the picker in UIPopoverController)
 set this property’s value to NO.
 */
@property (nonatomic, assign) BOOL showsCancelButton;

@end

//@protocol ELongAssetsPickerControllerDelegate <NSObject>
//
///**
// Tells the delegate that the user finish picking photos or videos.
// @param picker The controller object managing the assets picker interface.
// @param assets An array containing picked ALAsset objects
// */
//- (void)assetsPickerController:(ELongAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets;
//
//@optional
//
///**
// Tells the delegate that the user cancelled the pick operation.
// @param picker The controller object managing the assets picker interface.
// */
//- (void)assetsPickerControllerDidCancel:(ELongAssetsPickerController *)picker;
//
//@end
