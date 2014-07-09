//
//  CustomPicker.m
//  TableTest
//
//  Created by Jian.Zhao on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CustomPicker.h"
#import "TaxiUtils.h"

@implementation CustomPicker

- (id)initWithFrame:(CGRect)frame Delegate:(id)aDelegate andOriginalDate:(NSString *)aDate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _delegate = aDelegate;
        self.original = aDate;
        self.selectedString = aDate;
        
        _date = [[NSMutableArray alloc] init];
        [_date addObjectsFromArray:[TaxiUtils getDateArraysFromNowWithDays:30]];
        
        _hours = [[NSMutableArray alloc] initWithCapacity:24];
        for (int i = 0; i<24; i++) {
            NSString *value = (i>=10)?[NSString stringWithFormat:@"%d",i]:[NSString stringWithFormat:@"0%d",i];
            [_hours addObject:value];
        }
        
        _mins = [[NSMutableArray alloc] initWithCapacity:6];
        for (int i = 0; i<6; i++) {
            NSString *value = [NSString stringWithFormat:@"%d0",i];
            [_mins addObject:value];
        }
        
        
        UIView *accessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        accessory.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0; i<2; i++) {
            CGRect btnFrame = CGRectMake(i*280, 0, 40, 40);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:btnFrame];
            if (i==0) {
                [btn setTitle:@"取消" forState:UIControlStateNormal];
            }else{
                [btn setTitle:@"完成" forState:UIControlStateNormal];
            }
            [btn setTitleColor:RGBCOLOR(22, 126, 251, 1) forState:UIControlStateNormal];
            btn.tag = 1000+i;
            [btn addTarget:self action:@selector(taptheAccessoryButton:) forControlEvents:UIControlEventTouchUpInside];
            [accessory addSubview:btn];
        }
        
        [self   addSubview:accessory];
        [accessory release];
        
        UIPickerView *_picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 320, 216)];
        _picker.delegate = self;
        _picker.dataSource = self;
        _picker.showsSelectionIndicator = YES;
        _picker.backgroundColor = [UIColor whiteColor];
        [self configethePicker:_picker];
        
        [self addSubview:_picker];
        [_picker release];
    }
    return self;
}

-(void)configethePicker:(UIPickerView *)_pickerView{
 
    //默认
    NSLog(@"%@",self.original);
    NSArray *array = [self.original componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"- :"]];
    
    NSString *month = [array objectAtIndex:1];
    if ([month hasPrefix:@"0"]) {
        month = [month substringFromIndex:1];
    }
    
    NSString *date = [[array objectAtIndex:0] stringByAppendingFormat:@"-%@",[month stringByAppendingFormat:@"-%@",[array objectAtIndex:2]]];
    NSString *hours = [array objectAtIndex:3];
    NSString *min = [array objectAtIndex:4];
    
    int Date_Index=0;
    for (NSString *_s in _date) {
        if ([_s hasPrefix:date]) {
            Date_Index = [_date indexOfObject:_s];
            break;
        }
    }
    
    int Hours_Index = [_hours indexOfObject:hours];
    int Min_Index = [_mins indexOfObject:min];
    [_pickerView selectRow:Date_Index inComponent:0 animated:YES];
    [_pickerView selectRow:Hours_Index inComponent:1 animated:YES];
    [_pickerView selectRow:Min_Index inComponent:2 animated:YES];
    
    //
     self.default_Date = [_date objectAtIndex:0];
    self.default_Hours = hours;
    self.default_Mins = min;
    
}

-(void)dealloc{
    [_date release];
    [_hours release];
    [_mins release];
    SFRelease(_original);
    SFRelease(_selectedString);
    [super dealloc];
}

-(void)taptheAccessoryButton:(UIButton *)sender{

    int tag = sender.tag;
    if (tag == 1001)
    {
        if (self.selectedString) {
            if (_delegate && [_delegate respondsToSelector:@selector(doneTheActionWithResult:)]) {
                [_delegate doneTheActionWithResult:self.selectedString];
            }
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(dismissTheActionSheet)]) {
        [_delegate dismissTheActionSheet];
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

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 3;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
            return [_date count];
            break;
        case 1:
            return [_hours count];
            break;
        case 2:
            return [_mins count];
            break;
        default:
            break;
    }
    return 0;
}
// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return (component == 0)?150:75;
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 40;
    
}

-(NSString *)dropTheYear:(NSString *)string{

    NSString *_s = [string substringFromIndex:5];
    _s = [_s stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
    _s = [_s stringByReplacingOccurrencesOfString:@" " withString:@"日 "];

    return _s;
    
}

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
            return [self dropTheYear:[_date objectAtIndex:row]];
            break;
        case 1:
            return [_hours objectAtIndex:row];
            break;
        case 2:
            return [_mins objectAtIndex:row];
            break;
        default:
            break;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
   
    switch (component) {
        case 0:
            self.default_Date = [_date objectAtIndex:row];
            break;
         case 1:
            self.default_Hours = [_hours objectAtIndex:row];
            break;
          case 2:
            self.default_Mins = [_mins objectAtIndex:row];
            break;
        default:
            break;
    }
    [self dealWithThePickerView:pickerView WithMonth:self.default_Date Hours:self.default_Hours Mins:self.default_Mins];
}

-(void)dealWithThePickerView:(UIPickerView *)picker WithMonth:(NSString *)month Hours:(NSString *)hours Mins:(NSString *)mins{

    NSString *d_month = [[month componentsSeparatedByString:@" "] objectAtIndex:0];
    
    NSString *r_date = [d_month stringByAppendingFormat:@" %@:%@",hours,mins];
    
    NSDate *date = [NSDate dateFromString:r_date withFormat:TIME_FORMATTER_Airport];
    NSDate *ori = [NSDate dateFromString:self.original withFormat:TIME_FORMATTER_Airport];
    if ([date compare:ori] == NSOrderedAscending) {
        [self configethePicker:picker];
    }else{
    
        self.selectedString = r_date;
    }
    
}

@end
