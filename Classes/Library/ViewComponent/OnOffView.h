//
//  OnOffView.h
//  ElongClient
//  自定义图像的开关
//
//  Created by haibo on 11-11-23.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OnOffView : UIImageView {

}

@property (nonatomic, assign) BOOL on;		// 开关标志,默认是关

- (id)initWithFrame:(CGRect)frame OnImage:(UIImage *)onImage OffImage:(UIImage *)offImage;	// 指定大小和图像进行初始化

@end
