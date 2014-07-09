//
//  CustomPageController.h
//  ElongClient
//  自定义的pagecontroller
//
//  Created by haibo on 12-1-13.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomPageController : UIControl {
@private
	NSInteger lastPage;
}

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) BOOL hidesForSinglePage;

- (id)initWithFrame:(CGRect)frame selectedImage:(UIImage *)selectedImg normalImage:(UIImage *)normalImg;

@end
