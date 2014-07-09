//
//  ScenicAnnitoanView.h
//  ElongClient
//
//  Created by nieyun on 14-5-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ScenicAnnotion.h"

#import "AttributedLabel.h"
@interface ScenicAnnitoanView : MKAnnotationView
@property  (nonatomic,retain)UIImageView  *bgImageV;
@property  (nonatomic,retain) AttributedLabel  *priceLabel;
@property  (nonatomic,retain)UILabel  *nameLabel;
@property  (nonatomic,retain)ScenicAnnotion  *modelAnnotion;

- (id) initWithFrame:(CGRect)frame annotation:(id<MKAnnotation>) annotation reuseIdentifier:(NSString *)reuseIdentifier;
@end
