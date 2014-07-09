//
//  ThumbnailImage.h
//  ElongClient
//
//  Created by Jian.Zhao on 14-5-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectImageDelegate <NSObject>

-(void)selectImageIndex:(int)index;

@end

@interface ThumbnailImage : UIImageView<UIGestureRecognizerDelegate>

@property (nonatomic,assign) id<SelectImageDelegate>delegate;
@property (nonatomic,assign) int tag_index;

@end
