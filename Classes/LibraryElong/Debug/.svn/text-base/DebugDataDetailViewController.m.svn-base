//
//  DebugDetailViewController.m
//  ElongClient
//
//  Created by Dawn on 14-2-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DebugDataDetailViewController.h"
#import "ElongCacheDebugProtocol.h"

@interface DebugDataDetailViewController ()
@property (nonatomic,retain) NSObject *object;
@end


@implementation DebugDataDetailViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    self.object = nil;
    [super dealloc];
}

- (id) initWithObject:(NSObject *)obj{
    if (self = [super init]) {
        self.object = obj;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 50)];
    textView.editable = NO;
    [self.view addSubview:textView];
    [textView release];
    
    if ([self.object isKindOfClass:[NSString class]]){
        textView.text = (NSString *)self.object;
    }else if([self.object isKindOfClass:[NSArray class]]){
        textView.text = [(NSArray *)self.object JSONStringWithOptions:JKSerializeOptionPretty error:NULL];
    }else if([self.object isKindOfClass:[NSMutableArray class]]){
        textView.text = [(NSMutableArray *)self.object JSONStringWithOptions:JKSerializeOptionPretty error:NULL];
    }else if([self.object isKindOfClass:[NSDictionary class]]){
        textView.text = [(NSDictionary *)self.object JSONStringWithOptions:JKSerializeOptionPretty error:NULL];
    }else if([self.object isKindOfClass:[NSMutableDictionary class]]) {
        textView.text = [(NSMutableDictionary *)self.object JSONStringWithOptions:JKSerializeOptionPretty error:NULL];
    }else if([self.object isKindOfClass:[NSNumber class]]){
        textView.text = [NSString stringWithFormat:@"%@",self.object];
    }else if([self.object respondsToSelector:@selector(dataLogs)]){
        textView.text = [self.object performSelector:@selector(dataLogs)];
    }else{
        textView.text = [NSString stringWithFormat:@"%@",self.object];
    }
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"打印日志    " style:UIBarButtonItemStyleDone target:self action:@selector(printLog)] autorelease];
    
}


- (void) printLog{
    NSLog(@"%@",self.object);
}

@end
