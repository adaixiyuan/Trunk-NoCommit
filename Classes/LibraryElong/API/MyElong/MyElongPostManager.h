//
//  MyElongPostManager.h
//  ElongClient
//
//  Created by bin xing on 11-2-14.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCustomer.h"
#import "JCard.h"
#import "JCoupon.h"
#import "JAddCustomer.h"
#import "JModifyCustomer.h"
#import "JDeleteCustomer.h"
#import "JGetAddress.h"
#import "JDeleteAddress.h"
#import "JModifyAddress.h"
#import "JAddAddress.h"
#import "JAddCard.h"
#import "JPostHeader.h"
#import "JVerifyCard.h"
#import "JActivateCoupon.h"
#import "HotelFavoriteRequest.h"
#import "JDeleteHotelFavorite.h"
#import "JModifyCard.h"
#import "JDeleteCard.h"
#import "JDeleteGrouponFavorite.h"

@class JCustomer;
@class JCard;
@class JCoupon;
@interface MyElongPostManager : NSObject {

}

+ (JCard *)card;
+ (JAddCard *)addCard;
+ (JVerifyCard *)verifyCard;
+ (JPostHeader *)getCardType;
#if CARD_EDIT_DELETE
+ (JModifyCard *)modifyCard;
+ (JDeleteCard *)deleteCard;
#endif
+ (JCoupon *)coupon ;
+ (JActivateCoupon *)activeCoupon;

+ (JCustomer *)customer ;
+ (JAddCustomer *)addCustomer;
+ (JModifyCustomer *)modifyCustomer;
+ (JDeleteCustomer *)deleteCustomer;

+ (JGetAddress *)getAddress;
+ (JAddAddress *)addAddress;
+ (JModifyAddress *)modifyAddress;
+ (JDeleteAddress *)deleteAddress;

+ (JDeleteHotelFavorite *)deleteHF;
+ (JDeleteGrouponFavorite *)deleteGF;
@end
