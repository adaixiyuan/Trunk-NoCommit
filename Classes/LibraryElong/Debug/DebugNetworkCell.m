//
//  DebugNetworkCell.m
//  ElongClient
//
//  Created by Dawn on 14-3-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DebugNetworkCell.h"
@interface DebugNetworkCell(){
    UILabel *keyLbl;
    UILabel *keyTipsLbl;
    UILabel *valueLbl;
    float cellHeight;
}

@end


@implementation DebugNetworkCell

- (void) dealloc{
    self.dataKey = nil;
    self.unit = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cellHeight = 30;
        // Initialization code
        keyLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cellHeight)];
        keyLbl.backgroundColor = [UIColor greenColor];
        keyLbl.font = [UIFont systemFontOfSize:12.0f];
        keyLbl.adjustsFontSizeToFitWidth = YES;
        keyLbl.minimumFontSize = 8.0f;
        keyLbl.textColor = [UIColor colorWithRed:52.0/255.0f green:52.0/255.0f blue:52.0/255.0f alpha:1.0f];
        [self.contentView addSubview:keyLbl];
        [keyLbl release];
        
        keyTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cellHeight)];
        keyTipsLbl.backgroundColor = [UIColor clearColor];
        keyTipsLbl.font = [UIFont systemFontOfSize:14.0f];
        keyTipsLbl.textColor = [UIColor colorWithRed:52.0/255.0f green:52.0/255.0f blue:52.0/255.0f alpha:1.0f];
        [self.contentView addSubview:keyTipsLbl];
        [keyTipsLbl release];
        
        valueLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cellHeight)];
        valueLbl.backgroundColor = [UIColor clearColor];
        valueLbl.font = [UIFont systemFontOfSize:12.0f];
        valueLbl.textColor = [UIColor colorWithRed:200.0/255.0f green:200.0/255.0f blue:200.0/255.0f alpha:1.0f];
        valueLbl.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:valueLbl];
        [valueLbl release];
        
    }
    return self;
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        keyTipsLbl.textColor = [UIColor blueColor];
        keyTipsLbl.font = [UIFont boldSystemFontOfSize:14.0f];
    }else{
        keyTipsLbl.textColor = [UIColor colorWithRed:52.0/255.0f green:52.0/255.0f blue:52.0/255.0f alpha:1.0f];
        keyTipsLbl.font = [UIFont systemFontOfSize:14.0f];
    }
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    if (selected) {
        keyTipsLbl.textColor = [UIColor blueColor];
        keyTipsLbl.font = [UIFont boldSystemFontOfSize:14.0f];
    }else{
        keyTipsLbl.textColor = [UIColor colorWithRed:52.0/255.0f green:52.0/255.0f blue:52.0/255.0f alpha:1.0f];
        keyTipsLbl.font = [UIFont systemFontOfSize:14.0f];
    }
}

- (void) setDataKey:(NSString *)dataKey{
    [_dataKey release];
    _dataKey = dataKey;
    [_dataKey retain];
    keyTipsLbl.text = dataKey;
}

- (void) setDataValue:(float)dataValue{
    _dataValue = dataValue;
    valueLbl.text = [NSString stringWithFormat:@"%.3f%@",self.dataValue,self.unit];
    if (self.dataMaxValue > 0.0f) {
        [self threshold];
    }
}

- (void) setThresholdValue:(float)thresholdValue{
    _thresholdValue = thresholdValue;
    [self threshold];
}

- (void) threshold{
    float value = self.thresholdValue;
    if (self.dataMaxValue == 0) {
        keyLbl.frame = CGRectMake(0, 1, 0, cellHeight - 2);
    }else{
        keyLbl.frame = CGRectMake(0, 1, 0.8 * SCREEN_WIDTH * self.dataValue/self.dataMaxValue, cellHeight - 2);
    }
    
    if (self.dataValue >= value) {
        keyLbl.backgroundColor = [UIColor purpleColor];
    }else if (self.dataValue >= value * 0.8) {
        keyLbl.backgroundColor = [UIColor redColor];
    }else if(self.dataValue >= value * 0.6){
        keyLbl.backgroundColor = [UIColor orangeColor];
    }else{
        keyLbl.backgroundColor = [UIColor greenColor];
    }
}

- (void) setUnit:(NSString *)unit{
    [_unit release];
    _unit = [unit copy];
    valueLbl.text = [NSString stringWithFormat:@"%.3f%@",self.dataValue,self.unit];
    [self threshold];
}

- (void) setMaxValue:(float)maxValue{
    _dataMaxValue = maxValue;
    if (self.dataMaxValue > 0.0f) {
        
    }
}

@end
