//
//  PackingItem.m
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-31.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "PackingItem.h"

@implementation PackingItem

-(id)init{
    
    if (self = [super init]) {
        _name = @"";
        _isChecked = @"";
    }
    return self;
}


-(void)dealloc{

    [_name release];
    _name = nil;
    [_isChecked release];
    _isChecked = nil;
    [super dealloc];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.isChecked = [aDecoder decodeObjectForKey:@"isChecked"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.isChecked forKey:@"isChecked"];
    
}

-(id)copyWithZone:(NSZone *)zone{
    PackingItem     *copy = [[[self class] allocWithZone:zone] init];
    copy.name = _name;
    copy.isChecked = _isChecked;
    return copy;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    PackingItem     *copy = [[[self class] allocWithZone:zone] init];
    NSString *string = [_name mutableCopy];
    copy.name = string;
    [string release];
    copy.isChecked = @"";//[_isChecked mutableCopy];这个地方直接设空，本模块涉及的Copy需要此项设为@""
    return copy;
}

@end
