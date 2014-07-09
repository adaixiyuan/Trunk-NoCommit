//
//  DebugNetStatisticsCell.m
//  ElongClient
//
//  Created by Janven on 14-3-26.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DebugNetStatisticsCell.h"

@implementation DebugNetStatisticsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{

    self.URL.adjustsFontSizeToFitWidth = YES;
}

-(void)dispalyDataWithSource:(NSDictionary *)dic{

    self.URL.text = [dic objectForKey:@"Key"];
    self.count.text = [NSString stringWithFormat:@"C:%d",[[dic objectForKey:@"count"] intValue]];
    self.average.text = [NSString stringWithFormat:@"A:%f",[[dic objectForKey:@"TimeInterval"] floatValue]];
    self.maxTime.text = [NSString stringWithFormat:@"Max:%f",[[dic objectForKey:@"max"] floatValue]];
    self.minTime.text = [NSString stringWithFormat:@"Min:%f",[[dic objectForKey:@"min"] floatValue]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_URL release];
    [_count release];
    [_average release];
    [_maxTime release];
    [_minTime release];
    [super dealloc];
}
@end
