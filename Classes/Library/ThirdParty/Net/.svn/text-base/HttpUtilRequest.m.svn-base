//
//  HttpUtilRequest.m
//  ElongClient
//
//  Created by 赵 海波 on 12-11-22.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import "HttpUtilRequest.h"
#import "HttpsDetection.h"

@interface HttpUtilRequest(){
    NSURLConnection *connection;
}
@property (nonatomic,retain) NSMutableData *responseData;
@end

@implementation HttpUtilRequest

@synthesize currentReq;
@synthesize delegate;
@synthesize responseData;

- (void)dealloc {
	self.currentReq = nil;
    self.delegate = nil;
	self.responseData = nil;
    if (connection) {
        [connection release],connection = nil;
    }
	[super dealloc];
}


- (id)initWithRequest:(NSMutableURLRequest *)request {
	if (self = [super init]) {
		self.currentReq	= request;
	}
	
	return self;
}


- (void)main {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSURLResponse *response = nil;
	NSError *error = nil;

    if ([[HttpsDetection sharedInstance] isHttpsRequest:currentReq]) {
        connection = [[NSURLConnection alloc] initWithRequest:currentReq delegate:self startImmediately:YES];
        NSLog(@"start https connection");
        while(connection) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        NSLog(@"end https connection");
    }else{
        NSData *data = [NSURLConnection sendSynchronousRequest:currentReq returningResponse:&response error:&error];
        //response = nil;
        
        if (error) {
            [delegate receviceError:error];
        }
        else {
            [delegate receviceData:data];
        }
    }
    
	[pool release];
}

- (void) cancel{
    NSLog(@"...............................connection cancel");
    [super cancel];
    [connection cancel];
    if (connection) {
        [connection release];
        connection = nil;
    }
}

#pragma mark -
#pragma mark NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response{
    self.responseData = [NSMutableData dataWithCapacity:5000];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn{
    [delegate receviceData:self.responseData];
    if (connection) {
        [connection release];
        connection = nil;
    }
}

#pragma mark -
#pragma mark NSURLConnectionDelegate

-(void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error{
    NSLog(@"...............................%@",error);
    [delegate receviceError:error];
    if (connection) {
        [connection release];
        connection = nil;
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"didReceiveAuthenticationChallenge %@ %zd", [[challenge protectionSpace] authenticationMethod], (ssize_t) [challenge previousFailureCount]);
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
    }
}

@end
