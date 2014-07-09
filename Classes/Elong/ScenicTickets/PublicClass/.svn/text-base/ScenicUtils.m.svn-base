//
//  ScenicUtils.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicUtils.h"
#import "ScenicTicketsPublic.h"
#import "BaseModel.h"

@implementation ScenicUtils

+(CGFloat)getTheStringHeight:(NSString *)originString FontSize:(CGFloat)size Width:(CGFloat)width{

    if (originString) {
        CGSize constrainedSize = CGSizeMake(width, MAXFLOAT);
        CGSize _size = [originString sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:constrainedSize
                                    lineBreakMode:NSLineBreakByWordWrapping];
        return _size.height;
    }
    return 0;
}

+(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim
{
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        NSString *tag = [NSString stringWithFormat:@"%@>",text];
        if ([tag isEqualToString:@"<br/>"] || [tag isEqualToString:@"<>:"]) {
            html = [html stringByReplacingOccurrencesOfString:tag withString:@"\n"];
        }else{
            html = [html stringByReplacingOccurrencesOfString:tag withString:@""];
        }
    }
    
    html  = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}


+(void)savaHistory:(NSObject *)object toPath:(NSString *)toPath withCount:(int)count
{   
    NSString  *absolutePath = [toPath  stringByAppendingFormat:SCENICSTOREPATH];
    NSString  *allpath = [SCENICPATH  stringByAppendingFormat:@"%@",absolutePath];
    NSFileManager *manager = [NSFileManager  defaultManager];
    BOOL  isDir;
    if (!([manager  fileExistsAtPath:SCENICPATH isDirectory:&isDir] ))
    {
        if (isDir == NO )
        {
            [manager createDirectoryAtPath:SCENICPATH withIntermediateDirectories:YES attributes:Nil error:Nil];
        }
        
    }
    if (![manager  fileExistsAtPath:allpath])
    {
        [manager  createFileAtPath:allpath contents:Nil attributes:Nil];
    }
    
    NSMutableArray  *storeAr =  [NSMutableArray  arrayWithCapacity:count];
    [storeAr  addObjectsFromArray:[self  getHistoryFromPath:toPath]];
  //  [NSMutableArray  arrayWithArray:[self  getHistoryFromPath:toPath]];
    [storeAr  insertObject:object atIndex:0];
    if (storeAr.count > 3)
    {
        [storeAr  removeLastObject];
    }
    
        if ([NSKeyedArchiver  archiveRootObject:storeAr toFile:allpath])
        {
            NSLog(@"门票搜索页面归档成功！");
        }
    
    
}

+(NSArray  *)getHistoryFromPath:(NSString *)fromPath

{
    
    NSString  *absolutePath = [fromPath  stringByAppendingFormat:SCENICSTOREPATH];
      NSString  *allpath = [SCENICPATH  stringByAppendingFormat:@"%@",absolutePath];
    NSArray  *ar = [NSKeyedUnarchiver  unarchiveObjectWithFile:allpath];
    return ar;
}
+ (void)clearHistoryFromPath:(NSString *)fromPath
{
    NSString  *absolutePath = [fromPath  stringByAppendingFormat:SCENICSTOREPATH];
     NSString  *allpath = [SCENICPATH  stringByAppendingFormat:@"%@",absolutePath];

    NSFileManager  *manager = [NSFileManager defaultManager];
    [manager  removeItemAtPath:allpath error:Nil];
}
@end
