//
//  SearchBarView.m
//  ElongClient
//
//  Created by Dawn on 14-3-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "SearchBarView.h"

@implementation SearchBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.translucent	= YES;
        
        
        if (!IOSVersion_5) {
            self.backgroundColor = RGBACOLOR(236, 236, 236, 1);
            for (UIView *subview in self.subviews) {
                if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                    subview.alpha = 0.0;
                    break;
                }
            }
        }else{
            self.backgroundColor = [UIColor clearColor];
            self.backgroundImage = [UIImage stretchableImageWithPath:@"searchbar_bg.png"];
            [self setSearchFieldBackgroundImage:[UIImage noCacheImageNamed:@"searchbar_field_bg.png"] forState:UIControlStateNormal];
        }
    }
    return self;
}


@end
