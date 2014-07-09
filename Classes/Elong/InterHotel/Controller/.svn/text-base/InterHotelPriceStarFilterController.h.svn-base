//
//  InterHotelPriceStarFilterController.h
//  ElongClient
//
//  Created by 赵岩 on 13-6-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmbedTextField.h"

@protocol InterHotelPriceStarFilterDelegate;

@interface InterHotelPriceStarFilterController : UIViewController <UITextFieldDelegate>

@property (nonatomic, assign) NSUInteger minPrice;
@property (nonatomic, assign) NSUInteger maxPrice;
@property (nonatomic, assign) NSInteger starLevle;

@property (nonatomic, assign) IBOutlet EmbedTextField *minPriceTextField;
@property (nonatomic, assign) IBOutlet EmbedTextField *maxPriceTextField;
@property (nonatomic, assign) IBOutlet UIButton *unlimitedButton;
@property (nonatomic, assign) IBOutlet UILabel *unlimitedLabel;
@property (nonatomic, assign) IBOutlet UIButton *inexpensiveButton;
@property (nonatomic, assign) IBOutlet UILabel *inexpensiveLabel;
@property (nonatomic, assign) IBOutlet UIButton *threeStarButton;
@property (nonatomic, assign) IBOutlet UILabel *threeStarLabel;
@property (nonatomic, assign) IBOutlet UIButton *fourStarButton;
@property (nonatomic, assign) IBOutlet UILabel *fourStarLabel;
@property (nonatomic, assign) IBOutlet UIButton *fiveStarButton;
@property (nonatomic, assign) IBOutlet UILabel *fiveStarLabel;

@property (nonatomic, assign) id<InterHotelPriceStarFilterDelegate> delegate;

- (IBAction)starButtonTapped:(id)sender;

@end

@protocol InterHotelPriceStarFilterDelegate <NSObject>

- (void)interHotelPriceStarFilter:(InterHotelPriceStarFilterController *)fitelr priceRangeChangedWithMinPrice:(NSUInteger)minPrice withMaxPrice:(NSUInteger)maxPrice;

- (void)interHotelPriceStarFilter:(InterHotelPriceStarFilterController *)fitelr starLevelChanged:(NSUInteger)starLevel;

@end
