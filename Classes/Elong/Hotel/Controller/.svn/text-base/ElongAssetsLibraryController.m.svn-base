//
//  ElongAssetsLibraryController.m
//  ElongClient
//
//  Created by chenggong on 14-4-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongAssetsLibraryController.h"

@interface ElongAssetsLibraryController()

@end

@implementation ElongAssetsLibraryController

- (void)dealloc
{
    self.roomId = nil;
    
    [super dealloc];
}

+ (ALAssetsLibrary *)shareInstance
{
    static ALAssetsLibrary *_shareInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shareInstance = [[ALAssetsLibrary alloc] init];
        
    });
    
    return _shareInstance;
}

+ (ElongAssetsLibraryController *)shareDataInstance
{
    static ElongAssetsLibraryController *_shareInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shareInstance = [[ElongAssetsLibraryController alloc] init];
        
    });
    
    return _shareInstance;
}

@end
