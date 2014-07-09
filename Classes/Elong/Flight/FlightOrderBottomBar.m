//
//  FlightOrderBottomBar.m
//  ElongClient
//
//  Created by Jian.zhao on 13-12-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FlightOrderBottomBar.h"

#define BottomBarHeight 44

@implementation FlightOrderBottomBar
@synthesize totalPrice,cashBack;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSLog(@"机票订单模块底部栏--------须使用自定义的初始化方法");
        
    }
    return self;
}

-(void)dealloc{

    self.totalPrice = nil;
    
    self.cashBack = nil;

    [super dealloc];
}


-(id)initWithType:(FlightOrdertype)type andRightBtnTitle:(NSString *)title pressedSEL:(SEL)selector DetailSEL:(SEL)selector2 delegate:(id)_delegate{

    CGRect frame = CGRectMake(0, SCREEN_HEIGHT-BottomBarHeight-64, 320, BottomBarHeight);//底部还需减去Nav和Status的高度!
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"groupon_detail_bottom.png"]];
        
        
        //填写订单页面
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, 10, 20)];
        tip.backgroundColor = [UIColor  clearColor];
        tip.textColor = [UIColor whiteColor];
        tip.text = @"¥";
        [self addSubview:tip];
        [tip release];
        
        totalPrice = [[UILabel alloc] initWithFrame:CGRectMake(tip.frame.origin.x+tip.frame.size.width+3, 13, 80, 20)];
        totalPrice.adjustsFontSizeToFitWidth = YES;
        totalPrice.textColor = [UIColor whiteColor];
        totalPrice.backgroundColor = [UIColor clearColor];
        totalPrice.font = [UIFont boldSystemFontOfSize:20.0f];
        totalPrice .text = @"0";
        [self addSubview:totalPrice];
        
        if (type == Order_Fill) {
            
            UILabel *tip_ = [[UILabel alloc] initWithFrame:CGRectMake(totalPrice.frame.origin.y+totalPrice.frame.size.width+20, 19, 25, 13)];
            tip_.backgroundColor = [UIColor  clearColor];
            tip_.text = @"返 ¥";
            tip_.contentMode = UIViewContentModeBottom;
            tip_.font = [UIFont systemFontOfSize:11.0f];
            tip_.textColor = [UIColor whiteColor];
            [self addSubview:tip_];
            [tip_  release];
            
            self.cashBack = [[[UILabel alloc] initWithFrame:CGRectMake(tip_.frame.origin.x+tip_.frame.size.width, 15, 50, 20)] autorelease];
            cashBack.adjustsFontSizeToFitWidth = YES;
            cashBack.textColor = [UIColor whiteColor];
            cashBack.backgroundColor = [UIColor clearColor];
            cashBack.font  = [UIFont boldSystemFontOfSize:13.0f];
            cashBack.text = @"0";
            [self addSubview:cashBack];

        }else if (type == Order_Confim){
        
            object = _delegate;
            o_selector = selector2;
            
            //Image 18*18
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(totalPrice.frame.origin.x+totalPrice.frame.size.width+50, 0,44, 44)];
            UIImage *backImage = [UIImage imageNamed:@"inter_price_detail.png"];
            float offset = (44-backImage.size.width)/2.0f;
            [btn setImageEdgeInsets:UIEdgeInsetsMake(offset, offset, offset, offset)];
            [btn setImage:backImage forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(changeThePosition:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];

        }
        
        //200--->
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(200, 0,120, 44)];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
        [btn addTarget:_delegate action:selector forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        //Fill Data
        [self fillDataWithType:type];
        
    }
    return  self;
}

//

-(void)fillDataWithType:(FlightOrdertype)type{

    if (type == Order_Fill) {
        //
        
        
    }else if (type == Order_Confim){
    
        
    }
    
    
}



-(void)changeThePosition:(UIButton *)sender{

    UIImage *image = [sender currentImage];
    
    if (object && o_selector) {
        [object performSelector:o_selector withObject:nil];
        UIButton *btn = sender;
        UIImage *another = [self image:image rotation:UIImageOrientationDown];
        [btn setImage:another forState:UIControlStateNormal];
        
    }else{
        NSLog(@"SomeThing has being Wrong with FlightOrderBottomBar !---------");
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width*image.scale, image.size.height*image.scale);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}


@end
