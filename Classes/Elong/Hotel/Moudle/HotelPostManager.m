//
//  HotelPostManager.m
//  ElongClient
//
//  Created by bin xing on 11-1-13.
//  Copyright 2011 DP. All rights reserved.
//

#import "HotelPostManager.h"

static JHotelSearch *hotelsearcher = nil;
static JHotelSearch *tonightsearcher = nil;
static JHotelDetail *hoteldetailer = nil;
static JHotelComments *hotelcomments = nil;
static JHotelComments *goodhotelcomments = nil;
static JHotelComments *badhotelcomments = nil;
static JHotelOrder *hotelorder = nil;
static HotelFavoriteRequest *favorite = nil;
static GrouponFavoriteRequest *grouponFav = nil;
static JAddFavorite *addFavorite = nil;
static JCheckRoomCount *checkRoomCount = nil;
static JAddGrouponFavorite *addGrouponFavorite = nil;
static JHotelOrderDetail *hotelorderdetail = nil;

@implementation HotelPostManager

+ (JHotelSearch *)hotelsearcher  {
	@synchronized(self) {
		if(!hotelsearcher) {
			hotelsearcher = [[JHotelSearch alloc] init];
		}
	}
	return hotelsearcher;
}

+ (JHotelSearch *)tonightsearcher{
    @synchronized(self) {
		if(!tonightsearcher) {
			tonightsearcher = [[JHotelSearch alloc] init];
		}
	}
	return tonightsearcher;
}

+ (JHotelDetail *)hoteldetailer  {
	@synchronized(self) {
		if(!hoteldetailer) {
			hoteldetailer = [[JHotelDetail alloc] init];
		}
	}
	return hoteldetailer;
}

+ (JHotelComments *)hotelcomments  {
	@synchronized(self) {
		if(!hotelcomments) {
			hotelcomments = [[JHotelComments alloc] init];
		}
	}
	return hotelcomments;
}
+ (JHotelComments *)hotelgoodcomments  {
	@synchronized(self) {
		if(!goodhotelcomments) {
			goodhotelcomments = [[JHotelComments alloc] init];
		}
	}
	return goodhotelcomments;
}
+ (JHotelComments *)hotelbadcomments  {
	@synchronized(self) {
		if(!badhotelcomments) {
			badhotelcomments = [[JHotelComments alloc] init];
		}
	}
	return badhotelcomments;
}

+ (JHotelOrder *)hotelorder  {
	@synchronized(self) {
		if(!hotelorder) {
			hotelorder = [[JHotelOrder alloc] init];
		}
	}
	return hotelorder;
}

+ (HotelFavoriteRequest *)favorite  {
	@synchronized(self) {
		if(!favorite) {
			favorite = [[HotelFavoriteRequest alloc] init];
		}
	}
	return favorite;
}

+ (GrouponFavoriteRequest *)grouponFav{
    @synchronized(self) {
		if(!grouponFav) {
			grouponFav = [[GrouponFavoriteRequest alloc] init];
		}
	}
	return grouponFav;
}

+ (JAddFavorite *)addFavorite  {
	@synchronized(self) {
		if(!addFavorite) {
			addFavorite = [[JAddFavorite alloc] init];
		}
	}
	return addFavorite;
}

+ (JAddGrouponFavorite *)addGrouponFavorite{
    @synchronized(self) {
		if(!addGrouponFavorite) {
			addGrouponFavorite = [[JAddGrouponFavorite alloc] init];
		}
	}
	return addGrouponFavorite;
}

+ (JCheckRoomCount *)checkRoomCount  {
	@synchronized(self) {
		if(!checkRoomCount) {
			checkRoomCount = [[JCheckRoomCount alloc] init];
		}
	}
	return checkRoomCount;
}

+ (JHotelOrderDetail *)hotelorderdetail{
    @synchronized(self) {
		if(!hotelorderdetail) {
			hotelorderdetail = [[JHotelOrderDetail alloc] init];
		}
	}
	return hotelorderdetail;
}
@end
