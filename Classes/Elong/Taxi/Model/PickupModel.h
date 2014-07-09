//
//  PickupModel.h
//  ElongClient
//
//  Created by licheng on 14-3-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"

@interface PickupModel : BaseModel
@property  (nonatomic,copy)  NSString  *carTypeName;
@property  (nonatomic,copy)  NSString  *fee;
@property  (nonatomic,copy)  NSString  *startingOffers;
@property  (nonatomic,copy)  NSString  *additionalCosts;
@property  (nonatomic,copy)  NSString  *feeUnit;

@end
