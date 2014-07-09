//
//  PackingModel.m
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "PackingModel.h"
#import "NSMutableArray+DeepCopy.h"

@implementation PackingModel

-(void)dealloc{
    SFRelease(_name);
    SFRelease(_color);
    SFRelease(_isAlwaysUsed);
    SFRelease(_isFix);
    SFRelease(_categoryList);
    [super dealloc];
}

-(id)init{

    if (self = [super init]) {
        _name = @"";
        _color = @"";
        _isAlwaysUsed = @"";
        _isFix = @"";
        _categoryList = [[NSMutableArray alloc] init];
        _progress = 0.0f;
    }
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.color = [aDecoder decodeObjectForKey:@"color"];
        self.isAlwaysUsed = [aDecoder decodeObjectForKey:@"isAlwaysUsed"];
        self.isFix = [aDecoder decodeObjectForKey:@"isFix"];
        self.categoryList = [aDecoder decodeObjectForKey:@"categoryList"];
        self.progress = [aDecoder  decodeFloatForKey:@"progress"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.color forKey:@"color"];
    [aCoder encodeObject:self.isAlwaysUsed forKey:@"isAlwaysUsed"];
    [aCoder encodeObject:self.isFix forKey:@"isFix"];
    [aCoder encodeObject:self.categoryList forKey:@"categoryList"];
    [aCoder encodeFloat:self.progress forKey:@"progress"];
}

#pragma mark NSCoping

- (id)copyWithZone:(NSZone *)zone {
    PackingModel    *copy = [[[self class] allocWithZone:zone] init];
    copy.name = _name;
    copy.color = _color;
    copy.isAlwaysUsed = _isAlwaysUsed;
    copy.isFix = _isFix;
    copy.categoryList = _categoryList;
    copy.progress = _progress;
    return copy;
}

-(id)mutableCopyWithZone:(NSZone *)zone{

    PackingModel    *copy = [[[self class] allocWithZone:zone] init];
    copy.name = [self stringSafeCopy:_name];
    copy.color = [self stringSafeCopy:_color];
    copy.isAlwaysUsed =[self stringSafeCopy:_isAlwaysUsed];
    copy.isFix = [self stringSafeCopy:_isFix];
    NSMutableArray *array = [_categoryList mutableDeepCopy];
    copy.categoryList = array;
    copy.progress = _progress;
    return copy;
}

-(NSString *)stringSafeCopy:(NSString *)origin{

    NSString *string = [origin mutableCopy];
    return [string autorelease];
}


@end
