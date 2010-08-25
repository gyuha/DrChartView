//
//  DemoDrChartAppDelegate.h
//  DemoDrChart
//
//  Created by Gyuha Shin on 10. 8. 25..
//  Copyright Dreamers Entertainment Co, Ltd. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DemoDrChartViewController;

@interface DemoDrChartAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    DemoDrChartViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DemoDrChartViewController *viewController;

@end

