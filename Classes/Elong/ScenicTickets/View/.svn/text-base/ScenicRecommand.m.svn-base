//
//  ScenicRecommand.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicRecommand.h"
#import "ScenicDetail.h"
#import "UIImageView+WebCache.h"

@implementation ScenicRecommand

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 5, SCREEN_WIDTH,SCREEN_SCALE)]];
    [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0,40, SCREEN_WIDTH,SCREEN_SCALE)]];
    [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 145, SCREEN_WIDTH,SCREEN_SCALE)]];
    
    self.firstName.hidden = YES;
    self.firstImage.hidden = YES;
    
    self.secondName.hidden = YES;
    self.secondImage.hidden = YES;
    
    self.thirdImage.hidden = YES;
    self.thirdName.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_TypeName release];
    [_firstImage release];
    [_secondImage release];
    [_thirdImage release];
    [_firstName release];
    [_secondName release];
    [_thirdName release];
    [super dealloc];
}

-(void)bindSceneryModelArray:(NSArray *)scenerys{
    
    UIImage *defaultImage = [UIImage imageNamed:@"XGhomeDefault.png"];
    for (int i = 0; i<[scenerys count]; i++) {
        SimpleScenic *scenery = [scenerys objectAtIndex:i];
        switch (i) {
            case 0:
                self.firstName.text = scenery.sceneryName;
                [self.firstImage setImageWithURL:[NSURL URLWithString:scenery.imgPath] placeholderImage:defaultImage options:SDWebImageCacheMemoryOnly];
                self.firstName.hidden = NO;
                self.firstImage.hidden = NO;
                break;
            case 1:
                self.secondName.text = scenery.sceneryName;
                [self.secondImage setImageWithURL:[NSURL URLWithString:scenery.imgPath] placeholderImage:defaultImage options:SDWebImageCacheMemoryOnly];
                self.secondName.hidden = NO;
                self.secondImage.hidden = NO;
                break;
             case 2:
                self.thirdName.text = scenery.sceneryName;
                [self.thirdImage setImageWithURL:[NSURL URLWithString:scenery.imgPath] placeholderImage:defaultImage options:SDWebImageCacheMemoryOnly];
                self.thirdImage.hidden = NO;
                self.thirdName.hidden = NO;
                break;
            default:
                break;
        }
    }
}


- (IBAction)searchMore:(id)sender {
    

}
@end
