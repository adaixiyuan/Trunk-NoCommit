//
//  LzssUncompress.h
//  Wolfer Test
//
//  Created by administrator on 10-12-22.
//  Copyright 2010 m.elong.com. All rights reserved.
//
#import <stdio.h>
#import <stdlib.h>
#import <string.h>
#import <ctype.h>

#import <Foundation/Foundation.h>
#define F                  18   // upper limit for match_length
#define N                4096   /* size of ring buffer */
#define THRESHOLD       2   /* encode string into position and length if match_length is greater than this */
#define MAXLENGTH		10048000 //


@interface LzssUncompress : NSObject {
	unsigned char text_buf[N + F - 1];
}

- (NSString *) uncompress: (NSData *) data;
- (NSData *)uncompressData:(NSData *)data;

@end
