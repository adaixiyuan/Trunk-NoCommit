//
//  InterRoomDetailView.h
//  ElongClient
//
//  Created by Ivan.xu on 13-7-1.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InterRoomDetailDelegate <NSObject>

-(void)bookRoomFromDetailView;

@end

@interface InterRoomDetailView : UIView<NSURLConnectionDataDelegate>

@property(nonatomic,assign) id<InterRoomDetailDelegate> delegate;

-(id)initWithRoomIndex:(int)index withFrame:(CGRect)frame;

@end
