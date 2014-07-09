//
//  GrouponPriceFilterController.h
//  ElongClient
//
//  Created by 赵 岩 on 13-9-1.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmbedTextField.h"

@protocol GrouponPriceFilterDelegate;

@interface GrouponPriceFilterController : UIViewController <UITextFieldDelegate>

@property (nonatomic, assign) NSUInteger minPrice;
@property (nonatomic, assign) NSUInteger maxPrice;

@property (nonatomic, assign) IBOutlet EmbedTextField *minPriceTextField;
@property (nonatomic, assign) IBOutlet EmbedTextField *maxPriceTextField;

@property (nonatomic, assign) id<GrouponPriceFilterDelegate> delegate;

@end

@protocol GrouponPriceFilterDelegate <NSObject>

- (void)grouponPriceFilter:(GrouponPriceFilterController *)fitelr priceRangeChangedWithMinPrice:(NSUInteger)minPrice withMaxPrice:(NSUInteger)maxPrice;

@end
