//
//  SelectCardCell.m
//  ElongClient
//
//  Created by dengfang on 11-1-31.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "SelectCardCell.h"
#import "SelectCard.h"


@implementation SelectCardCell
@synthesize isSelected;
@synthesize isOverDue;
@synthesize selectImgView;
@synthesize nameLabel;
@synthesize bottomShadow;
@synthesize cardNameLabel;
@synthesize cardNumLabel;
@synthesize codeLabel;
@synthesize backView;
@synthesize selectCard;
@synthesize rightArrow;
@synthesize headerView;
@synthesize footerView;
@synthesize topSplitView;
@synthesize bottomSplitView;
@synthesize innerSplitView0;
@synthesize innerSPlitView1;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
	
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {

	}
	
	return self;
}

- (void)setCardTF:(CustomTextField *)cardTF
{
    if (cardTF != nil) {
        if (_cardTF != cardTF) {
            [_cardTF removeFromSuperview];
            
            [cardTF retain];
            [_cardTF release];
            _cardTF = cardTF;
            
            [self.backView addSubview:cardTF];
            
            _cardTF.textAlignment = NSTextAlignmentRight;
            [_cardTF addTarget:self action:@selector(uptextView:) forControlEvents:UIControlEventEditingDidBegin];
        }
    }
    else {
        [_cardTF removeFromSuperview];
        [_cardTF release];
        _cardTF = nil;
    }
}

- (void)setCodeTF:(CustomTextField *)codeTF
{
    if (codeTF != nil) {
        if (_codeTF != codeTF) {
            [_codeTF removeFromSuperview];
            
            [codeTF retain];
            [_codeTF release];
            _codeTF = codeTF;
            
            [self.backView addSubview:codeTF];
            
            _codeTF.textAlignment = NSTextAlignmentRight;
            [_codeTF addTarget:self action:@selector(uptextView:) forControlEvents:UIControlEventEditingDidBegin];
        }
    }
    else {
        [_codeTF removeFromSuperview];
        [_codeTF release];
        _codeTF = nil;
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	if (textField == _cardTF) {
		if (range.location > 3) {
			return NO;
		}
	}
	return YES;
}



- (void) textFieldDidEndEditing:(UITextField *)textField{
	[self textDown:textField];
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)uptextView:(id)sender {
	[selectCard textFieldDidActive:sender];
}


- (IBAction)textDown:(id)sender {
	[selectCard textFieldDidEnd:sender];
	
	[self endEditing:YES];
}


- (void)setCATipHidden:(BOOL)hidden
{
    if (hidden)
    {
        selectImgView.frame = CGRectMake(0, 3, 44, 44);
        nameLabel.frame = CGRectMake(44, 3, 100, 44);
        cardNameLabel.frame = CGRectMake(155, 3, 145, 44);
    }
    else
    {
        selectImgView.frame = CGRectMake(0, 0, 44, 44);
        nameLabel.frame = CGRectMake(44, 0, 100, 44);
        cardNameLabel.frame = CGRectMake(155, 0, 145, 44);
    }
    
    _caTipLabel.hidden = hidden;
}

- (void)dealloc {
	[selectImgView release];
	[nameLabel release];
	[cardNameLabel release];
	[cardNumLabel release];
	[_cardTF release];
	[codeLabel release];
	[_codeTF release];
	[rightArrow release];
	
	self.backView = nil;
	self.selectCard = nil;
	self.bottomShadow = nil;
    self.headerView = nil;
    self.footerView = nil;
    self.topSplitView = nil;
    self.bottomSplitView = nil;
	self.innerSplitView0 = nil;
    self.innerSPlitView1 = nil;
    [super dealloc];
}


@end
