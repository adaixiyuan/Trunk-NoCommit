//
//  MyElongPostManager.m
//  ElongClient
//
//  Created by bin xing on 11-2-14.
//  Copyright 2011 DP. All rights reserved.
//

#import "MyElongPostManager.h"

static JCard *card = nil;
static JAddCard *addCard = nil;
static JModifyCard *modifyCard = nil;
static JDeleteCard *deleteCard = nil;
static JVerifyCard *verifyCard = nil;
static JPostHeader *getCardType = nil;
static JCustomer *customer = nil;
static JAddCustomer *addCustomer = nil;
static JModifyCustomer *modifyCustomer = nil;
static JDeleteCustomer *deleteCustomer = nil;
static JGetAddress *getAddress = nil;
static JAddAddress *addAddress = nil;
static JModifyAddress *modifyAddress = nil;
static JDeleteAddress *deleteAddress = nil;
static JCoupon *coupon = nil;
static JActivateCoupon *activeCoupon = nil;
static JDeleteHotelFavorite *deleteHF = nil;
static JDeleteGrouponFavorite *deleteGF = nil;

@implementation MyElongPostManager
//Cards
+ (JCard *)card  {
	@synchronized(self) {
		if(!card) {
			card = [[JCard alloc] init];
		}
	}
	return card;
}
+ (JAddCard *)addCard  {
	@synchronized(self) {
		if(!addCard) {
			addCard = [[JAddCard alloc] init];
		}
	}
	return addCard;
}

#if CARD_EDIT_DELETE
+ (JModifyCard *)modifyCard  {
	@synchronized(self) {
		if(!modifyCard) {
			modifyCard = [[JModifyCard alloc] init];
		}
	}
	return modifyCard;
}
+ (JDeleteCard *)deleteCard  {
	@synchronized(self) {
		if(!deleteCard) {
			deleteCard = [[JDeleteCard alloc] init];
		}
	}
	return deleteCard;
}
#endif

+ (JVerifyCard *)verifyCard  {
	@synchronized(self) {
		if(!verifyCard) {
			verifyCard = [[JVerifyCard alloc] init];
		}
	}
	return verifyCard;
}
+ (JPostHeader *)getCardType  {
	@synchronized(self) {
		if(!getCardType) {
			getCardType = [[JPostHeader alloc] init];
		}
	}
	return getCardType;
}



//Customers
+ (JCustomer *)customer  {
	
	@synchronized(self) {
		if(!customer) {
			customer = [[JCustomer alloc] init];
		}
	}
	return customer;
}
+ (JAddCustomer *)addCustomer  {
	
	@synchronized(self) {
		if(!addCustomer) {
			addCustomer = [[JAddCustomer alloc] init];
		}
	}
	return addCustomer;
}
+ (JModifyCustomer *)modifyCustomer  {
	
	@synchronized(self) {
		if(!modifyCustomer) {
			modifyCustomer = [[JModifyCustomer alloc] init];
		}
	}
	return modifyCustomer;
}
+ (JDeleteCustomer *)deleteCustomer  {
	
	@synchronized(self) {
		if(!deleteCustomer) {
			deleteCustomer = [[JDeleteCustomer alloc] init];
		}
	}
	return deleteCustomer;
}

//Address
+ (JGetAddress *)getAddress  {

	@synchronized(self) {
		if(!getAddress) {
			getAddress = [[JGetAddress alloc] init];
		}
	}
	return getAddress;
}
+ (JAddAddress *)addAddress  {

	@synchronized(self) {
		if(!addAddress) {
			addAddress = [[JAddAddress alloc] init];
		}
	}
	return addAddress;
}
+ (JModifyAddress *)modifyAddress  {
	
	@synchronized(self) {
		if(!modifyAddress) {
			modifyAddress = [[JModifyAddress alloc] init];
		}
	}
	return modifyAddress;
}
+ (JDeleteAddress *)deleteAddress  {
	
	@synchronized(self) {
		if(!deleteAddress) {
			deleteAddress = [[JDeleteAddress alloc] init];
		}
	}
	return deleteAddress;
}

//Coupon
+ (JCoupon *)coupon  {
	@synchronized(self) {
		if(!coupon) {
			coupon = [[JCoupon alloc] init];
		}
	}
	return coupon;
}
+ (JActivateCoupon *)activeCoupon  {
	@synchronized(self) {
		if(!activeCoupon) {
			activeCoupon = [[JActivateCoupon alloc] init];
		}
	}
	return activeCoupon;
}

//hotelFavorite
+ (JDeleteHotelFavorite *)deleteHF  {
	@synchronized(self) {
		if(!deleteHF) {
			deleteHF = [[JDeleteHotelFavorite alloc] init];
		}
	}
	return deleteHF;
}

//grouponFavorite
+ (JDeleteGrouponFavorite *)deleteGF{
    @synchronized(self) {
		if(!deleteGF) {
			deleteGF = [[JDeleteGrouponFavorite alloc] init];
		}
	}
	return deleteGF;
}
 @end
