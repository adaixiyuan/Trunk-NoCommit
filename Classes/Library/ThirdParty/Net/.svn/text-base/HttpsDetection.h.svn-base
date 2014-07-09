//
//  HttpsDetection.h
//  ElongClient
//
//  Created by Dawn on 14-3-26.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpsDetection : NSObject

+ (HttpsDetection *) sharedInstance;

- (NSString *) dotNetHttpsDetectionWithUrl:(NSString *)url content:(NSString *)content;

- (NSString *) javaHttpsDetectionWithUrl:(NSString *)url;

- (BOOL) isHttpsRequest:(NSURLRequest *)request;

- (BOOL) isHttpsRequestUrl:(NSString *)url;
@end
