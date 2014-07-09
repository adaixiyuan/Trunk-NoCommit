//
//  ElongAlbumAsset.m
//  ElongClient
//
//  Created by chenggong on 14-3-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongAlbumAsset.h"

@implementation ElongAlbumAsset

- (void)dealloc
{
    self.asset = nil;
    
    [super dealloc];
}

- (id)initWithAsset:(ALAsset*)asset
{
	self = [super init];
	if (self) {
		self.asset = asset;
        _selected = NO;
    }
	return self;
}

- (void)toggleSelection
{
    self.selected = !self.selected;
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        if ([_delegate respondsToSelector:@selector(shouldSelectAsset:)]) {
            if (![_delegate shouldSelectAsset:self]) {
                return;
            }
        }
    }
    _selected = selected;
    if (selected) {
        if (_delegate != nil && [_delegate respondsToSelector:@selector(assetSelected:)]) {
            [_delegate assetSelected:self];
        }
    }
}

@end
