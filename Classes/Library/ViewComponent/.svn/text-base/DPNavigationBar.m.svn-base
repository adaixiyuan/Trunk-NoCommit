

#import "DPNavigationBar.h"

@implementation UINavigationBar (UINavigationBarCategory)

//static UIImageView *shadowView = nil;

- (void)drawRect:(CGRect)rect {
	if (!self.tintColor) {
		ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
		if(delegate.navDrawEnabled){
			UIImage *backImg = [UIImage imageNamed:@"sysNavBarBg.png"];
			[backImg drawInRect:rect];
		}else {
			UIImage *backImg = [UIImage stretchableImageWithPath:@"bg_header.png"];
			[backImg drawInRect:rect];
		}
	}
}


- (void)didMoveToSuperview
{
    //iOS5 only
    if (!self.tintColor) {
		ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
		if(delegate.navDrawEnabled){
			UIImage *backImg = [UIImage imageNamed:@"sysNavBarBg.png"];
			[backImg drawInRect:self.frame];
//            if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
//            {
//                [self setBackgroundImage:[UIImage stretchableImageWithPath:@"sysNavBarBg.png"] forBarMetrics:UIBarMetricsDefault];
//            }
		}else {
//			UIImage *backImg = [UIImage stretchableImageWithPath:@"bg_header.png"];
//			[backImg drawInRect:self.frame];
            if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
            {
                [self setBackgroundImage:[UIImage stretchableImageWithPath:@"bg_header.png"] forBarMetrics:UIBarMetricsDefault];
                self.clipsToBounds = YES;
            }
		}
	}

}

@end
