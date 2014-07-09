//
//  RentCity.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "RentCity.h"

@implementation RentCity

-(id)init{

    if (self = [super init]) {
        NSArray *array = [[NSArray alloc] init];
        self.airPortLst = array;
        [array release];
        
        self.cityCode = @"";
        self.cityName = @"";
    }
    return self;
}

-(void)dealloc{
    self.cityCode = nil;
    self.cityName = nil;
    self.airPortLst = nil;
    [super dealloc];
}

@end
/*
@implementation Airport

-(id)init{
    
    if (self = [super init]) {
        NSArray *array = [[NSArray alloc] init];
        self.terminalList = array;
        [array release];
    }
    return self;
}

-(void)dealloc{

    self.airPortCode = nil;
    self.airPortLat = nil;
    self.airPortLng = nil;
    self.airPortName = nil;
    self.terminalList = nil;
    [super dealloc];
}


@end


@implementation Terminal

-(void)dealloc{
    
    self.termCode = nil;
    self.termLat = nil;
    self.termLng = nil;
    self.termName = nil;
    [super dealloc];
}

@end
*/


/***/

@implementation CustomAirportTerminal

-(id)init{

    if (self = [super init]) {
        self.name = @"";
        self.cityCode = @"";
        self.airPortCode = @"";
        self.longitude = @"";
        self.latitude = @"";
        self.cityName = @"";
    }
    return self;
}

-(void)dealloc{
    self.cityName = nil;
    self.name = nil;
    self.cityCode = nil;
    self.airPortCode = nil;
    self.longitude = nil;
    self.latitude = nil;
    [super dealloc];
}

@end
