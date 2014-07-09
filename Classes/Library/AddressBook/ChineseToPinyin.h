#import <UIKit/UIKit.h>

@interface ChineseToPinyin : NSObject {
    
}

char jianyinFirstLetter(unsigned short hanzi);
+ (NSString *) pinyinFromChiniseString:(NSString *)string;
+ (char) sortSectionTitle:(NSString *)string; 

@end