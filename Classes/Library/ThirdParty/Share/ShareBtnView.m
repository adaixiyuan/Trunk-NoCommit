//
//  ShareBtnView.m
//  ElongClient
//
//  Created by Ivan.xu on 12-9-25.
//  Copyright 2012 elong. All rights reserved.
//

#import "ShareBtnView.h"


@implementation ShareBtnView
@synthesize delegate;
@synthesize activityView;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}


-(id) initWithBtnImage:(UIImage *)image withTitle:(NSString *)title andTag:(int)tag delegate:(id)object{
	self = [super init];
	if(self){
		self.frame = CGRectMake(0, 0, 80, 80);
		self.backgroundColor = [UIColor clearColor];
		self.delegate = object;
		
		btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setImage:image forState:UIControlStateNormal];
		btn.frame = CGRectMake(11, 0, 57, 57);
		btn.tag =tag;
		[btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
		
		textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 57, 80, 23)];
		textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        if (IOSVersion_7) {
            textLabel.textColor = [UIColor blackColor];
        }
		
		textLabel.text = title;
		textLabel.textAlignment = UITextAlignmentCenter;
		textLabel.font = [UIFont systemFontOfSize:13];
		
		
		[self addSubview:btn];
		[self addSubview:textLabel];
		[textLabel release];
        
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame = CGRectMake(0, 0, 20, 20);
        [btn addSubview:activityView];
        [activityView release];
        activityView.center = CGPointMake(btn.frame.size.width/2, btn.frame.size.height/2);
	}
	return self;
}

-(void)clickBtn:(id)sender{
    if (activityView.isAnimating) {
        return;
    }
	UIButton *clickBtn = (UIButton *)sender;
	if([delegate respondsToSelector:@selector(clickShareBtn:)]){
		[delegate clickShareBtn:clickBtn.tag];
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
