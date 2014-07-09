//
//  ThumbnailImage.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-5-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ThumbnailImage.h"

@implementation ThumbnailImage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goScanTheBigPicture:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        [tap release];
        
    }
    return self;
}


-(void)goScanTheBigPicture:(UIGestureRecognizer *)gesture{

    if (_delegate && [_delegate respondsToSelector:@selector(selectImageIndex:)]) {
        [_delegate selectImageIndex:self.tag_index];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
