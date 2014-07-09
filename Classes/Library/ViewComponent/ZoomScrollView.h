//
//  ZoomScrollView.h
//  ElongClient
//  可缩放得scrollview
//
//  Created by haibo on 11-12-1.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZoomScrollView : UIScrollView <UIScrollViewDelegate> {
@private
	UIImageView *imageView;
	
	//NSInteger touchCount;
	
	BOOL touchFinished;
}

@property (nonatomic, retain) UIImage *image;

@end
