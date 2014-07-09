//
//  FlightOrderConfirmPassengerCell.m
//  ElongClient
//
//  Created by chenggong on 13-12-23.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FlightOrderConfirmPassengerCell.h"
#import "FlightDataDefine.h"

@implementation FlightOrderConfirmPassengerCell

- (void)dealloc
{
    self.passengerArray = nil;
    self.postName = nil;
    self.postAddress = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier passengerInfo:(NSArray *)array postName:(NSString *)name postAddress:(NSString *)address
{
    self.passengerArray = array;
    self.postName = name;
    self.postAddress = address;
    
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    UIView *background = [[UIView alloc] initWithFrame:self.frame];
    background.backgroundColor = [UIColor clearColor];
    self.backgroundView = background;
    [background release];
    if (self) {
        // Initialization code
        UILabel *passengerInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(14.0f, 8.0f, 50.0f, 22.0f)];
        passengerInfoLabel.backgroundColor    = [UIColor clearColor];
        passengerInfoLabel.text               = @"乘机人:";
        passengerInfoLabel.textAlignment = NSTextAlignmentLeft;
        passengerInfoLabel.textColor          = RGBACOLOR(126, 126, 126, 1);
        passengerInfoLabel.font               = FONT_13;
        [self addSubview:passengerInfoLabel];
        [passengerInfoLabel release];
        
        NSUInteger infoIndex = 0;
        for (NSDictionary *info in _passengerArray) {
            // Name.
            UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(passengerInfoLabel.frame.origin.x, passengerInfoLabel.frame.origin.y + passengerInfoLabel.frame.size.height + 22.0f * infoIndex, 75.0f, 22.0f)];
            infoLabel.font = FONT_B13;
            infoLabel.text = [info safeObjectForKey:KEY_NAME];
            infoLabel.textColor = [UIColor blackColor];
            infoLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:infoLabel];
            [infoLabel release];
            
            // Identifier / number.
            UILabel *identifierLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, infoLabel.frame.origin.y, 215.0f, infoLabel.frame.size.height)];
            identifierLabel.font = FONT_13;
            identifierLabel.minimumFontSize = 8.0f;
            if ([[[_passengerArray safeObjectAtIndex:infoIndex] safeObjectForKey:KEY_CERTIFICATE_TYPE] integerValue] != 0) {
                identifierLabel.text = [NSString stringWithFormat:@"%@/%@", [Utils getCertificateName:[[[_passengerArray safeObjectAtIndex:infoIndex] safeObjectForKey:KEY_CERTIFICATE_TYPE] intValue]], [[_passengerArray safeObjectAtIndex:infoIndex] safeObjectForKey:KEY_CERTIFICATE_NUMBER]];
            }
            else {
                identifierLabel.text = [NSString stringWithFormat:@"%@/%@", [Utils getCertificateName:[[[_passengerArray safeObjectAtIndex:infoIndex] safeObjectForKey:KEY_CERTIFICATE_TYPE] intValue]], [[[_passengerArray safeObjectAtIndex:infoIndex] safeObjectForKey:KEY_CERTIFICATE_NUMBER] stringByReplacingCharactersInRange:NSMakeRange([[[_passengerArray safeObjectAtIndex:infoIndex] safeObjectForKey:KEY_CERTIFICATE_NUMBER] length] - 4, 4) withString:@"****"]];
            }
            
            identifierLabel.textColor = [UIColor colorWithRed:153.0f / 255 green:153.0f / 255 blue:153.0f / 255 alpha:1.0f];
            identifierLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:identifierLabel];
            [identifierLabel release];
            
            infoIndex++;
        }
        
        if (_postName == nil && _postAddress == nil) {
            return self;
        }
        
        // Separator line.   12.0f +
        [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(12.0f, 12.0f + 22.0f * (infoIndex + 1), SCREEN_WIDTH, 0.5f)]];
        
        // Post name.
        UILabel *postInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(14.0f,  22.0f * (infoIndex + 2), 150.0f, 22.0f)];
        postInfoLabel.backgroundColor    = [UIColor clearColor];
        postInfoLabel.text               = _postName;
        postInfoLabel.textAlignment = NSTextAlignmentLeft;
        postInfoLabel.textColor          = [UIColor colorWithRed:52.0f / 255 green:52.0f / 255 blue:52.0f / 255 alpha:1.0f];
        postInfoLabel.font               = FONT_14;
        [self addSubview:postInfoLabel];
        [postInfoLabel release];
        
        // Post address.
        UILabel *postAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(14.0f, 22.0f * (infoIndex + 3)-4, 296.0f, 44.0f)];
        postAddressLabel.backgroundColor    = [UIColor clearColor];
        postAddressLabel.numberOfLines = 0;
        postAddressLabel.text               = _postAddress;
        postAddressLabel.textAlignment = NSTextAlignmentLeft;
        postAddressLabel.textColor          = [UIColor blackColor];
        postAddressLabel.font               = FONT_14;
        [self addSubview:postAddressLabel];
        [postAddressLabel release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
