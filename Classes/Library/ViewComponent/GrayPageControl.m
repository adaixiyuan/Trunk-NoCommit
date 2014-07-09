//
//  GrayPageControl.m
//  ElongClient
//
//  Created by Dawn on 14-1-8.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrayPageControl.h"

@implementation GrayPageControl
- (void) dealloc{
    [activeImage release];
    [inactiveImage release];
    [super dealloc];
}

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    activeImage = [[UIImage imageNamed:@"red_dot.png"] retain];
    inactiveImage = [[UIImage imageNamed:@"gray_dot.png"] retain];
    
    return self;
}

-(void) updateDots{
    for (int i = 0; i < [self.subviews count]; i++){
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage)
            dot.image = activeImage;
        else
            dot.image = inactiveImage;
    }
}
-(void) setCurrentPage:(NSInteger)page{
    [super setCurrentPage:page];
    [self updateDots];
}

- (void) setNumberOfPages:(NSInteger)numberOfPages{
    [super setNumberOfPages:numberOfPages];
    [self updateDots];
}

@end
