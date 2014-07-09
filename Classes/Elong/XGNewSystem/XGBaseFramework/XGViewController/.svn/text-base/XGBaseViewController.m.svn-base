//
//  XGBaseViewController.m
//  ElongClient
//
//  Created by guorendong on 14-4-15.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGBaseViewController.h"
#import "XGUIAlterView+Block.h"

@interface XGBaseViewController ()

@end

@implementation XGBaseViewController

- (void)dealloc
{
    NSLog(@"XGViewController____%@__Dealloc",[self class]);
}
-(BOOL)isHasNavigationController
{
    return super.navigationController!=nil;
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0f&&[self isViewLoaded]&&![self.view window]) {
        [self ReleaseMemory];
    }
}
//解决内存释放的问题
-(void)ReleaseMemory
{
    
}
-(void)viewDidUnload
{
    [super viewDidUnload];
    [self ReleaseMemory];
}

//实现基类的实现导航栏Title
- (void)setNavTitle:(NSString *)title{
	
    CGSize size = [title sizeWithFont:FONT_B18];
    if (size.width >= 200) {
        size.width = 195;
    }
    
    if (self.navigationItem.titleView.frame.size.width < size.width) {
        self.navigationItem.titleView.frame = CGRectMake(self.navigationItem.titleView.frame.origin.x, self.navigationItem.titleView.frame.origin.y, size.width, self.navigationItem.titleView.frame.size.height);
    }
    
    UILabel *label = (UILabel *)[self.navigationItem.titleView viewWithTag:101];
    if (label.frame.size.width < size.width) {
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width, label.frame.size.height);
    }
	label.text = title;
}

-(NSString *)viewName
{
    return @"业务界面.虚UI";
}

-(BOOL)checkJsonIsError:(NSDictionary *)root delaySecond:(NSTimeInterval)second{
    return [[self class] checkJsonIsError:root delaySecond:second];
}

-(BOOL)checkJsonIsError:(NSDictionary *)root{
    return [[self class] checkJsonIsError:root];
}

+(BOOL)checkJsonIsError:(NSDictionary *)root delaySecond:(NSTimeInterval)second{

    COMMONRESPONSE(@"%@",root);
	if (root==nil) {
        [UIAlertView show:@"服务器错误" title:@"艺龙旅行" delaySecond:second];
		return YES;
	}else {
		NSString *message = [root safeObjectForKey:@"ErrorMessage"];
        int code = 0;
        if(!OBJECTISNULL([root safeObjectForKey:@"ErrorCode"])){
            code = [[root safeObjectForKey:@"ErrorCode"] intValue];
        }
        if (1000 == code) {
            // 后台出错的情况
            if (STRINGHASVALUE(message)) {
                [UIAlertView show:message delaySecond:second];
            } else {
                [UIAlertView show:@"系统正忙，请稍后再试" title:@"艺龙旅行" delaySecond:second];
                
            }
            return YES;
        }
        if (1 == code) {
            // 这是提交订单时重单的情况,不做提示
            return NO;
        }
        
		if (( [message isEqual:[NSNull null]]||[message isEqualToString:@""] ) && ![[root safeObjectForKey:@"IsError"] boolValue]) {
			return NO;
		}else {
			if ([root safeObjectForKey:@"ErrorMessage"]==[NSNull null]||[message isEqualToString:@""]) {
                [UIAlertView show:@"服务器错误" title:@"艺龙旅行" delaySecond:second];
			} else {
                [UIAlertView show:message title:@"艺龙旅行" delaySecond:second];
                
			}
			return YES;
		}
		return NO;
	}

}
// 弹框的错误检测
+(BOOL)checkJsonIsError:(NSDictionary *)root{
	return [XGBaseViewController checkJsonIsError:root delaySecond:2];
}


@end
