//
//  FStatusPlaneAnnotation.h
//  ElongClient
//
//  Created by bruce on 14-1-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FStatusPlaneAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign)	CLLocationCoordinate2D coordinate;	// 坐标
@property (nonatomic, copy)		NSString *title;					// 标题

@end
