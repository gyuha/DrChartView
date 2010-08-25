//
//  DemoDrChartViewController.h
//  DemoDrChart
//
//  Created by Gyuha Shin on 10. 8. 25..
//  Copyright Dreamers Entertainment Co, Ltd. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrGraphView.h"

@interface DemoDrChartViewController : UIViewController <DrGraphViewDataSource> {
	DrGraphView *graphView;
}
@property (nonatomic, retain) DrGraphView *graphView;
@end

