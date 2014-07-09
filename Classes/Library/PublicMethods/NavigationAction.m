//
//  NavigationAction.m
//  ElongClient
//
//  Created by Dawn on 14-3-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "NavigationAction.h"
#import "PositioningManager.h"
#import "NavigationDelegate.h"

@implementation NavigationAction
DEF_SINGLETON(NavigationAction)

- (void) dealloc{
    self.navActions = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == self.navActions.count) {
        return;
    }
    
    if ([[ServiceConfig share] monkeySwitch]){
        // 开着monkey时不发生事件
        return;
    }
    
    NSDictionary *dict = [self.navActions objectAtIndex:buttonIndex];
    NSLog(@"%@",dict);
    NSString *url = [dict objectForKey:@"Url"];
    if ([[dict objectForKey:@"MapType"] intValue] == AppleMapNavigation) {
        if (IOSVersion_6 && ![[ServiceConfig share] monkeySwitch]) {
            //
            float lat = [[dict objectForKey:@"lat"] floatValue];
            float lng = [[dict objectForKey:@"lng"] floatValue];
            
            PositioningManager *poiManager = [PositioningManager shared];
            MKPlacemark *currentMark = [[MKPlacemark alloc] initWithCoordinate:poiManager.myCoordinate addressDictionary:nil];
            MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lng) addressDictionary:nil];
            MKMapItem *targetMapItem = [[MKMapItem alloc] initWithPlacemark:placeMark];
            MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:currentMark];
            targetMapItem.name = [dict objectForKey:@"Name"];
            currentLocation.name = @"当前位置";
            [placeMark release];
            [currentMark release];
            
            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, targetMapItem, nil]
                           launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                     forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
            
            [targetMapItem release];
            [currentLocation release];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
    
    
}
@end
