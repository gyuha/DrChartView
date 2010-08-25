//
//  DemoDrChartViewController.m
//  DemoDrChart
//
//  Created by Gyuha Shin on 10. 8. 25..
//  Copyright Dreamers Entertainment Co, Ltd. 2010. All rights reserved.
//

#import "DemoDrChartViewController.h"

@implementation DemoDrChartViewController

@synthesize graphView;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	//self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.graphView = [[DrGraphView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.view = self.graphView;
	self.graphView.dataSource = self;
	//self.view.backgroundColor = [UIColor yellowColor];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
 
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMinimumFractionDigits:0];
	[numberFormatter setMaximumFractionDigits:0];
	
	self.graphView.yValuesFormatter = numberFormatter;
	
	/*
	 NSDateFormatter *dateFormatter = [NSDateFormatter new];
	 [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	 [dateFormatter setDateStyle:NSDateFormatterShortStyle];
	 
	 self.graphView.xValuesFormatter = dateFormatter;
	 
	 [dateFormatter release];
	 */
	[numberFormatter release];
	
	self.graphView.backgroundColor = [UIColor whiteColor];
	
	self.graphView.drawAxisX = YES;
	self.graphView.drawAxisY = YES;
	self.graphView.drawGridX = YES;
	self.graphView.drawGridY = YES;
	
	self.graphView.xValuesColor = [UIColor blackColor];
	self.graphView.yValuesColor = [UIColor blackColor];
	
	self.graphView.gridXColor = [UIColor blackColor];
	self.graphView.gridYColor = [UIColor blackColor];
	
	self.graphView.drawInfo = YES;
	self.graphView.info = @"Load";
	
	self.graphView.scroll = YES;
	self.graphView.gridXWidth = 30.0f;
	self.graphView.infoColor = [UIColor blackColor];
	
	self.graphView.margin = 10.0f;
	
	//When you need to update the data, make this call:
	
	[self.graphView reloadData];
	
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark protocol DrGraphViewDataSource
- (NSUInteger)graphViewNumberOfPlots:(DrGraphView *)graphView {
	/* Return the number of plots you are going to have in the view. 1+ */
	return 2;
}

- (NSArray *)graphViewXValues:(DrGraphView *)graphView {
	/* An array of objects that will be further formatted to be displayed on the X-axis.
	 The number of elements should be equal to the number of points you have for every plot. */
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:101];
	for ( int i = -50 ; i <= 50 ; i ++ ) {
		[array addObject:[NSString stringWithFormat:@"%d", i]];
	}
	return array;
}

- (NSArray *)graphView:(DrGraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex {
	/* Return the values for a specific graph. Each plot is meant to have equal number of points.
	 And this amount should be equal to the amount of elements you return from graphViewXValues: method. */
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:101];
	switch (plotIndex) {
		default:
		case 0:
			for ( int i = -50 ; i <= 50 ; i ++ ) {
				[array addObject:[NSNumber numberWithInt:i*i]];	// y = x*x		
			}
			break;
		case 1:
			for ( int i = -50 ; i <= 50 ; i ++ ) {
				[array addObject:[NSNumber numberWithInt:i*i*i]];	// y = x*x*x				
			}
			break;
	}
	
	return array;
}

@end
