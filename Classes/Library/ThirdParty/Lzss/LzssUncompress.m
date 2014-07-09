//
//  LzssUncompress.m
//  Wolfer Test
//
//  Created by administrator on 10-12-22.
//  Copyright 2010 m.elong.com. All rights reserved.
//

#import "LzssUncompress.h"


@implementation LzssUncompress

-(NSString *)uncompress: (NSData *) data{
	//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int  i, j, k, r, c,readoff,writeoff,inlength;
	unsigned int  flags;
	Byte *instream ,*outstream;
	NSString *outStr;
	inlength = data.length;
	instream = (Byte *)malloc(inlength);
	memcpy(instream, [data bytes], inlength);
	if(inlength <= 8){
        free(instream);
		return nil;
	}
	readoff = writeoff = 0;
	outstream = (Byte *)malloc(MAXLENGTH);
	for (i = 0; i < N - F; i++) text_buf[i] = ' ';
	r = N - F;  flags = 0;
	for ( ; ; ) {
		if (((flags >>= 1) & 256) == 0) {
			if (readoff == inlength) break;
			c = instream[readoff++];
			flags = c | 0xff00;            // uses higher byte cleverly to count eight 
		}                                                     
		if (flags & 1) {
			if (readoff == inlength) break;
			c = instream[readoff++];
			outstream[writeoff++] = c; text_buf[r++] = c;  r &= (N - 1);//!!!
		} else {
			if (readoff == inlength) break;
			i = instream[readoff++];
			if (readoff == inlength) break;
			j = instream[readoff++];
			i |= ((j & 0xf0) << 4);  
			j = (j & 0x0f) + THRESHOLD;
			for (k = 0; k <= j; k++) {
				c = text_buf[(i + k) & (N - 1)];
				outstream[writeoff++] = c;	text_buf[r++] = c;  r &= (N - 1);//!!!
			}
		}
	}
		data=nil;
	[data release];

	//printf("%s",outstream);
	outStr = [[[NSString alloc] initWithBytes:outstream length:writeoff encoding:NSUTF8StringEncoding] autorelease];
	free(instream);
	free(outstream);
	//free(text_buf);
	//[outStr release];
	//[pool release];
	return outStr;
	
}

- (NSData *)uncompressData:(NSData *)data {
    int  i, j, k, r, c,readoff,writeoff,inlength;
	unsigned int  flags;
	Byte *instream ,*outstream;

	inlength = data.length;
	instream = (Byte *)malloc(inlength);
	memcpy(instream, [data bytes], inlength);
	if(inlength <= 8){
        free(instream);
		return nil;
	}
	readoff = writeoff = 0;

	outstream = (Byte *)malloc(MAXLENGTH);
    
	for (i = 0; i < N - F; i++) text_buf[i] = ' ';
	r = N - F;  flags = 0;
	for ( ; ; ) {
		if (((flags >>= 1) & 256) == 0) {
			if (readoff == inlength) break;
			c = instream[readoff++];
			flags = c | 0xff00;            // uses higher byte cleverly to count eight
		}
		if (flags & 1) {
			if (readoff == inlength) break;
			c = instream[readoff++];
			outstream[writeoff++] = c; text_buf[r++] = c;  r &= (N - 1);//!!!
		} else {
			if (readoff == inlength) break;
			i = instream[readoff++];
			if (readoff == inlength) break;
			j = instream[readoff++];
			i |= ((j & 0xf0) << 4);
			j = (j & 0x0f) + THRESHOLD;
			for (k = 0; k <= j; k++) {
				c = text_buf[(i + k) & (N - 1)];
				outstream[writeoff++] = c;	text_buf[r++] = c;  r &= (N - 1);//!!!
			}
		}
	}
    data = nil;
	[data release];
    
	//printf("%s",outstream);
    NSData *outData = [[NSData alloc] initWithBytes:outstream length:writeoff];
	free(instream);
	free(outstream);
	//free(text_buf);
	//[outStr release];
	//[pool release];
	return [outData autorelease];
}

@end


