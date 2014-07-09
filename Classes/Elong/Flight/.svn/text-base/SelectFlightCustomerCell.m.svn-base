//
//  SelectFlightCustomerCell.m
//  ElongClient
//
//  Created by dengfang on 11-1-28.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "SelectFlightCustomerCell.h"


@implementation SelectFlightCustomerCell
@synthesize isSelected;
@synthesize selectImgView;
@synthesize nameLabel;
@synthesize infoLabel;

- (IBAction)buttonClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if([btn isSelected])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(tableViewCell:selected:)]) {
            [_delegate tableViewCell:self selected:NO];
        }
//        [btn setSelected:NO];
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(tableViewCell:selected:)]) {
            [_delegate tableViewCell:self selected:YES];
        }
//        [btn setSelected:YES];
    }
}

- (IBAction)editCustomer:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(editButtonClick:)]) {
        [_delegate editButtonClick:self];
    }
}

- (IBAction)switchAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(switchClick:)]) {
        [_delegate switchClick:self];
    }
}

- (id)init
{
    if (self = [super init]) {
//        [_checkBoxButton setImage:[UIImage imageNamed:@"btn_choice_checked.png"] forState:UIControlStateSelected];
//        [_checkBoxButton setImage:[UIImage imageNamed:@"btn_choice.png"] forState:UIControlStateNormal];
//        [_checkBoxButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        UISwitch *tempSwitch;
        if (IOSVersion_6) {
            tempSwitch = [[MBSwitch alloc] initWithFrame:CGRectMake(237.0f, 73.0f, 51.0f, 31.0f)];
        }
        else if (IOSVersion_4 && !IOSVersion_5) {
            tempSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(207.0f, 73.0f, 51.0f, 31.0f)];
        }
        else
        {
            tempSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(237.0f, 73.0f, 51.0f, 31.0f)];
        }
        
        self.cellSwitch = tempSwitch;
        [_cellSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_cellSwitch];
        [tempSwitch release];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[selectImgView release];
	[nameLabel release];
	[infoLabel release];
    self.birthdayLabel = nil;
    self.insuranceLabel = nil;
    self.checkBoxButton = nil;
    self.noticeLabel = nil;
    self.editButton = nil;

    [_cellSwitch release];
    [_rightImageView release];
    [super dealloc];
}


@end
