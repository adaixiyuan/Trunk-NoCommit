//
//  ScenicAnnitoanView.m
//  ElongClient
//
//  Created by nieyun on 14-5-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicAnnitoanView.h"

@implementation ScenicAnnitoanView

- (id) initWithFrame:(CGRect)frame annotation:(id<MKAnnotation>) annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self  =[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = frame;
        self.canShowCallout = YES;
        self.opaque = NO;
        self.backgroundColor = [UIColor  clearColor];
        _bgImageV= [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
      
        [self  addSubview:_bgImageV];
        
        
        _priceLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(0,0,  self.frame.size.width, 12)];
               _priceLabel.backgroundColor	= [UIColor clearColor];
        _priceLabel.textColor		= [UIColor whiteColor];
        _priceLabel.textAlignment	= UITextAlignmentCenter;
        _priceLabel.adjustsFontSizeToFitWidth = YES;
        [_bgImageV addSubview:_priceLabel];
        [_priceLabel release];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.size.width, 20)];
        _nameLabel.font				= [UIFont boldSystemFontOfSize:10];
        _nameLabel.backgroundColor	= [UIColor clearColor];
        _nameLabel.textColor			= [UIColor whiteColor];
        _nameLabel.textAlignment		= UITextAlignmentCenter;
        _nameLabel.numberOfLines = 0;
        [self addSubview:_nameLabel];
        [_nameLabel release];
        
        [_bgImageV release];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        
        
    }
    return self;
}

- (void)setModelAnnotion:(ScenicAnnotion *)modelAnnotion
{
    if (_modelAnnotion  !=  modelAnnotion)
    {
        [_modelAnnotion  release];
        _modelAnnotion =  [modelAnnotion retain];
        
    }
  
    if (_modelAnnotion.bookFlag== SCENIC_BOOK)
    {
         self.priceLabel.text = _modelAnnotion.price;
       
    
          _bgImageV.image =   [UIImage noCacheImageNamed:@"mapAnnotation_Icon.png"];
        
    }else  if (_modelAnnotion.bookFlag == SCENIC_NOBOOK)
    {
        self.priceLabel.text = _modelAnnotion.gradeName;
        _bgImageV.backgroundColor = [UIColor  grayColor];
    }
     [self.priceLabel  setFont:[UIFont boldSystemFontOfSize:14] fromIndex:0 length:self.priceLabel.text.length];
    [self.priceLabel  setColor:[UIColor whiteColor] fromIndex:0 length:self.priceLabel.text.length];
    self.nameLabel.text = _modelAnnotion.name;
    
}
- (void)dealloc
{
   
    [_modelAnnotion  release];
    [super dealloc];
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
