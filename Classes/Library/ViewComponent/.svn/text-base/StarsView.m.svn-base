//
//  StarsView.m
//  ElongClient
//
//  Created by haibo on 12-2-5.
//  Copyright 2012 elong. All rights reserved.
//

#import "StarsView.h"


@implementation StarsView


- (void)dealloc {
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self performSelector:@selector(fillStar)];
    }
	
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
    if (self) {
		[self performSelector:@selector(fillStar)];
    }
	
    return self;
}


- (void)fillStar {
	star1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 11, 11)];
	[self addSubview:star1];
	[star1 release];
	
	star2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 11, 11)];
	[self addSubview:star2];
	[star2 release];
	
	star3 = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 11, 11)];
	[self addSubview:star3];
	[star3 release];
	
	star4 = [[UIImageView alloc] initWithFrame:CGRectMake(45, 0, 11, 11)];
	[self addSubview:star4];
	[star4 release];
	
	star5 = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, 11, 11)];
	[self addSubview:star5];
	[star5 release];
}


- (void)setStarNumber:(NSString *)number {
    star1.image = nil;
    star2.image = nil;
    star3.image = nil;
    star4.image = nil;
    star5.image = nil;
    
	if ([number isEqualToString:@"1"] || [number isEqualToString:@"1.0"]) {
        star1.image = [UIImage imageNamed:@"star_ico.png"];
    }
    else if ([number isEqualToString:@"1.5"]) {
        star1.image = [UIImage imageNamed:@"star_ico.png"];
        star2.image = [UIImage imageNamed:@"half_star_ico.png"];
    }
    else if ([number isEqualToString:@"2"] || [number isEqualToString:@"2.0"]) {
        star1.image = [UIImage imageNamed:@"star_ico.png"];
        star2.image = [UIImage imageNamed:@"star_ico.png"];
    }
	else if ([number isEqualToString:@"2.5"]) {
        star1.image = [UIImage imageNamed:@"star_ico.png"];
        star2.image = [UIImage imageNamed:@"star_ico.png"];
        star3.image = [UIImage imageNamed:@"half_star_ico.png"];
    }
    else if ([number isEqualToString:@"3"] || [number isEqualToString:@"3.0"]) {
        star1.image = [UIImage imageNamed:@"star_ico.png"];
        star2.image = [UIImage imageNamed:@"star_ico.png"];
        star3.image = [UIImage imageNamed:@"star_ico.png"];
    }
    else if ([number isEqualToString:@"3.5"]) {
        star1.image = [UIImage imageNamed:@"star_ico.png"];
        star2.image = [UIImage imageNamed:@"star_ico.png"];
        star3.image = [UIImage imageNamed:@"star_ico.png"];
        star4.image = [UIImage imageNamed:@"half_star_ico.png"];
    }
    else if ([number isEqualToString:@"4"] || [number isEqualToString:@"4.0"]) {
        star1.image = [UIImage imageNamed:@"star_ico.png"];
        star2.image = [UIImage imageNamed:@"star_ico.png"];
        star3.image = [UIImage imageNamed:@"star_ico.png"];
        star4.image = [UIImage imageNamed:@"star_ico.png"];
    }
    else if ([number isEqualToString:@"4.5"]) {
        star1.image = [UIImage imageNamed:@"star_ico.png"];
        star2.image = [UIImage imageNamed:@"star_ico.png"];
        star3.image = [UIImage imageNamed:@"star_ico.png"];
        star4.image = [UIImage imageNamed:@"star_ico.png"];
        star5.image = [UIImage imageNamed:@"half_star_ico.png"];
    }
    else if ([number isEqualToString:@"5"] || [number isEqualToString:@"5.0"]){
        star1.image = [UIImage imageNamed:@"star_ico.png"];
        star2.image = [UIImage imageNamed:@"star_ico.png"];
        star3.image = [UIImage imageNamed:@"star_ico.png"];
        star4.image = [UIImage imageNamed:@"star_ico.png"];
        star5.image = [UIImage imageNamed:@"star_ico.png"];
    }
}


- (void)setElongStar:(NSInteger)starlevel {
	switch (starlevel) {
		case 0:
			star1.image = nil;
			star2.image = nil;
			star3.image = nil;
			star4.image = nil;
			star5.image = nil;
			break;
		case 25:
			star1.image = [UIImage imageNamed:@"elong_star.png"];
			star2.image = [UIImage imageNamed:@"elong_star.png"];
			star3.image = [UIImage imageNamed:@"elong_star_half.png"];
			star4.image = nil;
			star5.image = nil;
			break;
		case 30:
			star1.image = [UIImage imageNamed:@"elong_star.png"];
			star2.image = [UIImage imageNamed:@"elong_star.png"];
			star3.image = [UIImage imageNamed:@"elong_star.png"];
			star4.image = nil;
			star5.image = nil;
			break;
		case 35:
			star1.image = [UIImage imageNamed:@"elong_star.png"];
			star2.image = [UIImage imageNamed:@"elong_star.png"];
			star3.image = [UIImage imageNamed:@"elong_star.png"];
			star4.image = [UIImage imageNamed:@"elong_star_half.png"];
			star5.image = nil;
			break;
		case 40:
			star1.image = [UIImage imageNamed:@"elong_star.png"];
			star2.image = [UIImage imageNamed:@"elong_star.png"];
			star3.image = [UIImage imageNamed:@"elong_star.png"];
			star4.image = [UIImage imageNamed:@"elong_star.png"];
			star5.image = nil;
			break;
		case 45:
			star1.image = [UIImage imageNamed:@"elong_star.png"];
			star2.image = [UIImage imageNamed:@"elong_star.png"];
			star3.image = [UIImage imageNamed:@"elong_star.png"];
			star4.image = [UIImage imageNamed:@"elong_star.png"];
			star5.image = [UIImage imageNamed:@"elong_star_half.png"];
			break;
		case 50:
			star1.image = [UIImage imageNamed:@"elong_star.png"];
			star2.image = [UIImage imageNamed:@"elong_star.png"];
			star3.image = [UIImage imageNamed:@"elong_star.png"];
			star4.image = [UIImage imageNamed:@"elong_star.png"];
			star5.image = [UIImage imageNamed:@"elong_star.png"];
			break;
		default:
			break;
	}
}

@end
