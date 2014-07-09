//
//  SelectRent.h
//  ElongClient
//
//  Created by nieyun on 14-4-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "SelectRoomer.h"

typedef enum {
    
    SelectType_RentCar,
    SelectType_ScenicTickets
    
}SelectType;

@interface SelectRent : SelectRoomer
@property (nonatomic,assign) SelectType type;
- (id) initRentRequested:(BOOL)requested peopleCount:(NSInteger)count andType:(SelectType )_type;
@end
