//
//  InternalHotelCommentCell.m
//  Elong_iPad
//
//  Created by Ivan.xu on 13-2-28.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InternalHotelCommentCell.h"
#import "DaoDaoRatingView.h"

@interface InternalHotelCommentCell ()

@property (nonatomic,retain) DaoDaoRatingView *ratingView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *timeLabel;
@property (nonatomic,retain) UILabel *contentLabel;
@property (nonatomic,retain) UILabel *getMoreCommentLabel;
@property (nonatomic,retain) UIImageView *rightGreenArrow;
@property (nonatomic,retain) UIImageView *grayLine;

-(void)moreComment;     //查看更多评论

@end

@implementation InternalHotelCommentCell
@synthesize ratingView;
@synthesize timeLabel,titleLabel,contentLabel;
@synthesize getMoreCommentLabel;
@synthesize rightGreenArrow,grayLine;
@synthesize delegate;

-(void)dealloc{
    [ratingView release];
    [timeLabel release];[titleLabel release];[contentLabel release];
    [getMoreCommentLabel release];
    [rightGreenArrow release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        int offX = 15;
        
        if(ratingView==nil){
            DaoDaoRatingView *daodaoRating = [[DaoDaoRatingView alloc] initWithFrame:CGRectMake(offX, 10, 80, 16)];
            self.ratingView = daodaoRating;
            [daodaoRating release];
        }
        [self addSubview:self.ratingView];
        
        if(titleLabel==nil){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 8, 210, 16)];
            self.titleLabel = label;
            [label release];
        }
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = RGBACOLOR(119, 119, 119, 1);
        self.titleLabel.font = FONT_12;
        [self addSubview:self.titleLabel];
        
        if(timeLabel==nil){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offX, 26, SCREEN_WIDTH - offX * 2, 15)];
            self.timeLabel = label;
            [label release];
        }
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = RGBACOLOR(119, 119, 119, 1);
        self.timeLabel.font = FONT_10;
        [self addSubview:self.timeLabel];
        
        if(contentLabel==nil){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offX, 55, SCREEN_WIDTH - offX * 2, 0)];
            self.contentLabel = label;
            [label release];
        }
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = FONT_11;
        self.contentLabel.textColor = RGBACOLOR(119, 119, 119, 1);
        self.contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        self.contentLabel.numberOfLines = 0;
        [self addSubview:self.contentLabel];
        
        if(getMoreCommentLabel==nil){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offX, self.contentLabel.frame.size.height+self.contentLabel.frame.origin.y+5, SCREEN_WIDTH - offX * 4, 30)];
            self.getMoreCommentLabel = label;
            [label release];
        }
        self.getMoreCommentLabel.text =  @"查看完整点评";//@"查看完整点评";
        self.getMoreCommentLabel.textAlignment = UITextAlignmentRight;
        self.getMoreCommentLabel.font = FONT_13;
        self.getMoreCommentLabel.textColor = [UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1];
        self.getMoreCommentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.getMoreCommentLabel];
        
        if(rightGreenArrow==nil){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(358, self.contentLabel.frame.size.height+self.contentLabel.frame.origin.y+5+9, 8, 12)];
            self.rightGreenArrow = imageView;
            [imageView release];
        }
        rightGreenArrow.image = [UIImage imageNamed:@"right_green.png"];
        [self addSubview:rightGreenArrow];
        
         grayLine = [UIImageView graySeparatorWithFrame:CGRectMake(0, self.contentLabel.frame.size.height+self.contentLabel.frame.origin.y+5+34, SCREEN_WIDTH, SCREEN_SCALE)];
        [self addSubview:grayLine];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setRatingScore:(float)score andTitle:(NSString *)title andTime:(NSString *)time{
    [self.ratingView setDaoDaoRateScore:score];
    self.titleLabel.text = title;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [df dateFromString:time];
    [df release];
    NSDateFormatter *df1 =[[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [df1 stringFromDate:date];
    [df1 release];

    self.timeLabel.text = [NSString stringWithFormat:@"Post on %@",dateStr];
}

-(void)setContent:(NSString *)content {
    self.contentLabel.text = content;
    [self.contentLabel sizeToFit];
    
    self.getMoreCommentLabel.frame = CGRectMake(10, self.contentLabel.frame.size.height+self.contentLabel.frame.origin.y+4, SCREEN_WIDTH - 20, 30);
    self.rightGreenArrow.frame = CGRectMake(302, self.contentLabel.frame.size.height+self.contentLabel.frame.origin.y+5+9, 8, 12);
    grayLine.frame= CGRectMake(0, self.contentLabel.frame.size.height+self.contentLabel.frame.origin.y+5+34, SCREEN_WIDTH, SCREEN_SCALE);
}


-(void)moreComment{     //查看更多评论
    if([delegate respondsToSelector:@selector(postMoreComment:)]){
        [delegate postMoreComment:self.tag];
    }
}

@end
