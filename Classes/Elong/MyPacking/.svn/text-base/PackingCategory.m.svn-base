//
//  PackingCategory.m
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-31.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "PackingCategory.h"
#import "NSMutableArray+DeepCopy.h"

@implementation PackingCategory

-(id)init{

    if (self = [super init]) {
        _name = @"";
        _itemList = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void)dealloc{
    [_name release];
    _name = nil;
    [_itemList release];
    _itemList = nil;
    [super dealloc];
}

-(id)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.itemList = [aDecoder decodeObjectForKey:@"itemList"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.itemList forKey:@"itemList"];
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    PackingCategory   *copy = [[[self class] allocWithZone:zone] init];
    copy.name = _name;
    copy.itemList = _itemList;
    return copy;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    PackingCategory     *copy = [[[self class] allocWithZone:zone] init];
    NSString *string = [_name mutableCopy];
    copy.name = string;
    [string release];
    NSMutableArray *array = [_itemList mutableDeepCopy];
    copy.itemList = array;
    return copy;
}
 
@end

