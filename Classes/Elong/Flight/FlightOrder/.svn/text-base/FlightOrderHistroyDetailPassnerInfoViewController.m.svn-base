//
//  FlightOrderHistroyDetailPassnerInfoViewController.m
//  ElongClient
//
//  Created by WangHaibin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlightOrderHistroyDetailPassnerInfoViewController.h"


@implementation FlightOrderHistroyDetailPassnerInfoViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)fillPassengerInfoViewByPassengers:(NSArray *)passengers{
    for(int i=0; i<passengers.count; i++){
        NSDictionary *passenger = [passengers objectAtIndex:i];
        NSString *name  = [passenger objectForKey:@"Name"];
        NSString *certificateInfo = [passenger objectForKey:@"CertificateInfo"];
        BOOL haveInsurance = [[passenger objectForKey:@"HaveInsurance"] boolValue];
        
        CGSize nameSize = [name sizeWithFont:FONT_B15 constrainedToSize:CGSizeMake(10000, 44)];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, i*44, nameSize.width, 44)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = FONT_B15;
        nameLabel.text = name;
        [bgView addSubview:nameLabel];
        [nameLabel release];
        
        UILabel *certificateLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameSize.width+25, i*44, 280-nameSize.width-15, 44)];
        certificateLabel.backgroundColor =[UIColor clearColor];
        certificateLabel.font = FONT_13;
        certificateLabel.minimumFontSize = 10;
        certificateLabel.textColor = [UIColor darkGrayColor];
        certificateLabel.text = certificateInfo;
        [bgView addSubview:certificateLabel];
        [certificateLabel release];
        
        //insurance
        UIImageView *insuranceFeeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(293, i*44+13, 17, 17)];
        insuranceFeeImgView.image = [UIImage noCacheImageNamed:@"ico_flightInsurance.png"];
        [bgView addSubview:insuranceFeeImgView];
        [insuranceFeeImgView release];
        insuranceFeeImgView.hidden = !haveInsurance;        //保险显示
        
        
        if(i<passengers.count-1){
            [bgView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(10, (i+1)*44-SCREEN_SCALE, 310, SCREEN_SCALE)]];
        }
    }
    
    [bgView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)]];
    [bgView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, passengers.count*44-SCREEN_SCALE, 320, SCREEN_SCALE)]];
    bgView.frame = CGRectMake(0, 40, 320, passengers.count*44);
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)dealloc {
	[bgView release];
	
	[super dealloc];
}


@end
