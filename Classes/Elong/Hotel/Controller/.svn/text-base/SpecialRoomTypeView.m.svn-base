//
//  PromotionView.m
//  ElongClient
//
//  Created by Dawn on 14-4-29.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "SpecialRoomTypeView.h"

@implementation SpecialRoomTypeItem
- (id) initWithType:(SpecialRoomType)roomType{
    if (self = [super initWithFrame:CGRectZero]) {
        self.contentMode = UIViewContentModeLeft;
        switch (roomType) {
            case SpecialRoomApartment:{
                self.frame = CGRectMake(0, 0, 24 + 6, 12);
                self.image = [UIImage noCacheImageNamed:@"mobileHouseListIcon.png"];
                self.sortIndex = 5;
            }
                break;
            case SpecialRoomGift:{
                self.frame = CGRectMake(0, 0, 12 + 6, 12);
                self.image = [UIImage noCacheImageNamed:@"hoteldetail_gift.png"];
                self.sortIndex = 4;
            }
                break;
            case SpecialRoomLM:{
                self.frame = CGRectMake(0, 0, 40 + 6, 12);
                self.image = [UIImage noCacheImageNamed:@"mobilePriceLMIcon.png"];
                self.sortIndex = 2;
            }
                break;
            case SpecialRoomPhone:{
                self.frame = CGRectMake(0, 0, 40 + 6, 12);
                self.image = [UIImage noCacheImageNamed:@"mobilePriceListIcon.png"];
                self.sortIndex = 1;
            }
                break;
            case SpecialRoomVIP:{
                self.frame = CGRectMake(0, 0, 40 + 6, 12);
                self.image = [UIImage noCacheImageNamed:@"mobilePriceListVipIconFlag.png"];
                self.sortIndex = 0;
            }
                break;
            case SpecialRoomLimit:{
                self.frame = CGRectMake(0, 0, 30 + 6, 12);
                self.image = [UIImage noCacheImageNamed:@"timelimitPriceListIconFlag.png"];
                self.sortIndex = 3;
            }
                break;
            default:
                break;
        }
    }
    return self;
}

@end

@interface SpecialRoomTypeView()


@end
@implementation SpecialRoomTypeView

- (void) dealloc{
    self.items = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _contentView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        _contentView.scrollEnabled = NO;
        [self addSubview:_contentView];
        [_contentView release];
        
        self.items = [NSMutableArray array];
        
        _contentView.userInteractionEnabled = NO;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (BOOL) scrollEnabled{
    return _contentView.scrollEnabled;
}

- (void) setScrollEnabled:(BOOL)scrollEnabled{
    _contentView.scrollEnabled = scrollEnabled;
}

- (void) reset{
    [_contentView removeAllSubviews];
    self.items = [NSArray array];
}

- (void) addSpecialRoomTypeItem:(SpecialRoomTypeItem *)item{
    float x = 0;
    float y = 0;
    NSMutableArray *tItems = [NSMutableArray arrayWithArray:self.items];
    [tItems addObject:item];
    
    self.items = [tItems sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger index0 = ((SpecialRoomTypeItem *)obj1).sortIndex;
        NSInteger index1 = ((SpecialRoomTypeItem *)obj2).sortIndex;
        if (index0 > index1) {
            return 1;
        }else if(index0 == index1){
            return 0;
        }else{
            return -1;
        }
    }];
    
    [_contentView removeAllSubviews];
    
    for (SpecialRoomTypeItem *typeItem in self.items) {
        typeItem.frame = CGRectMake(x, y, typeItem.frame.size.width, typeItem.frame.size.height);
        x += typeItem.frame.size.width;
        [_contentView addSubview:typeItem];
    }
    _contentView.contentSize = CGSizeMake(x, 12);
}

@end
