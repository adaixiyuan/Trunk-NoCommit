//
//  EmbedTextField.m
//  ElongClient
//
//  Created by 赵 海波 on 12-12-14.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import "EmbedTextField.h"
#import "CustomTextField.h"

@implementation EmbedTextField

@synthesize placeholder;
@synthesize text;
@synthesize abcEnabled;
@synthesize abcToSystemKeyboard;
@synthesize numberOfCharacter;
@synthesize returnKeyType;
@synthesize keyboardType;
@synthesize secureTextEntry;
@synthesize textFont;
@synthesize delegate;
@synthesize editing;

- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark initalization

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        
        offX = 0;
        
        contentField = [[CustomTextField alloc] initWithFrame:CGRectMake(offX, (self.bounds.size.height - 30) / 2, self.bounds.size.width - offX, 31)];
        contentField.font = FONT_16;
        contentField.borderStyle = UITextBorderStyleNone;
        contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
        contentField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        contentField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self addSubview:contentField];
        [contentField release];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame IconPath:(NSString *)path {
    if (self = [self initWithFrame:frame IconPath:path Title:nil TitleFont:nil]) {
        
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame Title:(NSString *)title TitleFont:(UIFont*)font {
    if (self = [self initWithFrame:frame IconPath:nil Title:title TitleFont:font]) {
        
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame IconPath:(NSString *)path Title:(NSString *)title TitleFont:(UIFont*)font {
    if (self = [self initWithFrame:frame IconPath:path Title:title TitleFont:font offsetX:0]) {
        
    }
    
    return self;
}

- (void) setBgHidden:(BOOL)hidden{
    //backImageView.hidden = hidden;
}


- (id)initWithFrame:(CGRect)frame IconPath:(NSString *)path Title:(NSString *)title TitleFont:(UIFont*)font offsetX:(NSInteger)x {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        offX = 0 + x;
        
        // 如果有Icon先加载icon
        if (path) {
            UIImage *icon = [UIImage noCacheImageNamed:path];
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(offX, (self.frame.size.height - icon.size.height) / 2, icon.size.width, icon.size.height)];
            iconView.image = icon;
            [self addSubview:iconView];
            [iconView release];
            
            offX += iconView.frame.size.width + 3;
        }
        
        // 如果有标题加载标题
        if (title && font) {
            CGSize titleSize = [title sizeWithFont:font];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(offX, 0, titleSize.width, self.bounds.size.height)];
            titleLabel.backgroundColor  = [UIColor clearColor];
            titleLabel.text             = title;
            titleLabel.textColor        = [UIColor blackColor];
            titleLabel.textAlignment    = UITextAlignmentLeft;
            titleLabel.font             = font;
            [self addSubview:titleLabel];
            [titleLabel release];
            
            offX += titleLabel.frame.size.width+10;
        }
        
        contentField = [[UITextField alloc] initWithFrame:CGRectMake(offX, (self.bounds.size.height - 31) / 2, self.bounds.size.width - offX, 31)];
        contentField.font = FONT_14;
        contentField.borderStyle = UITextBorderStyleNone;
        contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
        contentField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:contentField];
        [contentField release];
    }
    
    return self;
}


// CustomField init
- (id)initCustomFieldWithFrame:(CGRect)frame IconPath:(NSString *)path {
    if (self = [self initCustomFieldWithFrame:frame IconPath:path Title:nil TitleFont:nil]) {
        
    }
    
    return self;
}


- (id)initCustomFieldWithFrame:(CGRect)frame Title:(NSString *)title TitleFont:(UIFont*)font {
    if (self = [self initCustomFieldWithFrame:frame IconPath:nil Title:title TitleFont:font]) {
        
    }
    
    return self;
}


- (id)initCustomFieldWithFrame:(CGRect)frame IconPath:(NSString *)path Title:(NSString *)title TitleFont:(UIFont*)font {
    if (self = [self initCustomFieldWithFrame:frame IconPath:path Title:title TitleFont:font offsetX:0]) {
        
    }
    
    return self;
}


- (id)initCustomFieldWithFrame:(CGRect)frame IconPath:(NSString *)path Title:(NSString *)title TitleFont:(UIFont*)font offsetX:(NSInteger)x {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        offX = 0 + x;
        
        // 如果有Icon先加载icon
        if (path) {
            UIImage *icon = [UIImage noCacheImageNamed:path];
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(offX, (self.frame.size.height - icon.size.height) / 2, icon.size.width, icon.size.height)];
            iconView.image = icon;
            [self addSubview:iconView];
            [iconView release];
            
            offX += iconView.frame.size.width + 3;
        }
        
        // 如果有标题加载标题
        if (title && font) {
            CGSize titleSize = [title sizeWithFont:font];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(offX, 0, titleSize.width, self.bounds.size.height)];
            titleLabel.backgroundColor  = [UIColor clearColor];
            titleLabel.text             = title;
            titleLabel.textColor        = [UIColor blackColor];
            titleLabel.textAlignment    = UITextAlignmentLeft;
            titleLabel.font             = font;
            [self addSubview:titleLabel];
            [titleLabel release];
            
            offX += titleLabel.frame.size.width;
        }
        
        contentField = [[CustomTextField alloc] initWithFrame:CGRectMake(offX, (self.bounds.size.height - 30) / 2, self.bounds.size.width - offX, 31)];
        contentField.font = FONT_16;
        contentField.borderStyle = UITextBorderStyleNone;
        contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
        contentField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [contentField performSelector:@selector(resetTargetKeyboard)];
        [self addSubview:contentField];
        [contentField release];
    }
    
    return self;
}


#pragma mark -
#pragma mark Public Methods
- (void)addTarget:(id)target action:(SEL)method forControlEvents:(UIControlEvents)event {
    [contentField addTarget:target action:method forControlEvents:event];
}


- (void)addTopLineFromPositionX:(CGFloat)x length:(CGFloat)lineLength
{
    UIImageView *phoneNoTopLine = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, lineLength, SCREEN_SCALE)];
    phoneNoTopLine.image = [UIImage imageNamed:@"dashed.png"];
    [self addSubview:phoneNoTopLine];
    [phoneNoTopLine release];
}


- (void)addBottomLineFromPositionX:(CGFloat)x length:(CGFloat)lineLength
{
    UIImageView *phoneNoTopLine = [[UIImageView alloc] initWithFrame:CGRectMake(x, self.bounds.size.height - SCREEN_SCALE, lineLength, SCREEN_SCALE)];
    phoneNoTopLine.image = [UIImage imageNamed:@"dashed.png"];
    [self addSubview:phoneNoTopLine];
    [phoneNoTopLine release];
}


- (void)changeKeyboardStateToSysterm:(BOOL)animated {
    if ([contentField isMemberOfClass:[CustomTextField class]]) {
        CustomTextField *field = (CustomTextField *)contentField;
        [field changeKeyboardStateToSysterm:animated];
    }
}


- (void)showWordKeyboard {
    if ([contentField isMemberOfClass:[CustomTextField class]]) {
        CustomTextField *field = (CustomTextField *)contentField;
        [field showWordKeyboard];
    }
}

- (void)showNumKeyboard{
    if ([contentField isMemberOfClass:[CustomTextField class]]) {
        CustomTextField *field = (CustomTextField *)contentField;
        [field showNumKeyboard];
    }
}

#pragma mark -
#pragma mark Set Propety

- (void)setPlaceholder:(NSString *)holderString {
    contentField.placeholder = holderString;
}


- (NSString *)placeholder {
    return contentField.placeholder;
}


- (void)setText:(NSString *)textString {
    contentField.text = textString;
}


- (NSString *)text {
    return contentField.text;
}

- (BOOL)editing{
    return contentField.editing;
}

- (void)setTextFont:(UIFont *)font {
    contentField.font = font;
}


- (UIFont *)textFont {
    return contentField.font;
}


- (void)setAbcEnabled:(BOOL)animated {
    if ([contentField isMemberOfClass:[CustomTextField class]]) {
        abcEnabled = animated;
        
        CustomTextField *field = (CustomTextField *)contentField;
        field.abcEnabled = animated;
    }
}


- (void)setAbcToSystemKeyboard:(BOOL)animated {
    if ([contentField isMemberOfClass:[CustomTextField class]]) {
        abcToSystemKeyboard = animated;
        
        CustomTextField *field = (CustomTextField *)contentField;
        field.abcToSystemKeyboard = animated;
    }
}


- (void)setNumberOfCharacter:(NSInteger)num {
    if ([contentField isMemberOfClass:[CustomTextField class]]) {
        numberOfCharacter = num;
        
        CustomTextField *field = (CustomTextField *)contentField;
        field.numberOfCharacter = num;
    }
}


- (void)setReturnKeyType:(UIReturnKeyType)type {
    returnKeyType = type;
    contentField.returnKeyType = type;
}


- (void)setKeyboardType:(UIKeyboardType)type {
    returnKeyType = type;
    contentField.keyboardType = type;
}


- (void)setSecureTextEntry:(BOOL)animated {
    secureTextEntry = animated;
    contentField.secureTextEntry = animated;
}


- (void)setDelegate:(id)dele {
    delegate = dele;
    contentField.delegate = dele;
}

- (BOOL) resignFirstResponder{
    return [contentField resignFirstResponder];
}

- (UITextField *)textField {
    return contentField;
}

@end
