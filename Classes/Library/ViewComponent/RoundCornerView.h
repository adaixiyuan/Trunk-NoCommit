//
//  RoundCornerView.h
//  ElongClient
//  圆角带边框的View
//
//  Created by haibo on 11-9-19.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RoundCornerView : UIView {
@private
	CGImageRef imageRef;
}

@property(nonatomic, assign) BOOL selected;		
@property(nonatomic, retain) UIImage *image;
@property(nonatomic, retain) UIColor *borderColor;		// default gray color
@property(nonatomic, retain) UIColor *fillColor;		// default nil
@property(nonatomic, assign) float imageRadius;
@property(nonatomic, retain) UIImage *placeholder;

- (id)initWithFrame:(CGRect)frame;

- (void)selectedWithColor:(UIColor *)boardColor;		// draw extra board with color
- (void)deselect;										// cancel the board

@end


@interface SmallLoadingView : RoundCornerView {
@private
	UIActivityIndicatorView *indicatorView;
}

- (void)startLoading;
- (void)stopLoading;

@end

