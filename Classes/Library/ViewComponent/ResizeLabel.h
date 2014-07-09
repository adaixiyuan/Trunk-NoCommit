//
//  ResizeLabel.h
//  ElongClient
//  根据文字多少和指定大小来自动调整frame的label
//
//  Created by haibo on 11-12-13.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResizeLabel : UILabel {
@private
	CGPoint originPoint;
	
	CGSize originSize;
	
	CGSize constSize;
}

- (void)resizeByFrame:(CGRect)rect;
- (void)resizeByText:(NSString *)textString;
- (void)resizeByFont:(UIFont *)textFont;

@end
