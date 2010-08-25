//
//  DrGraphContentView.m
//  DemoDrGraphView
//
//  Created by Gyuha Shin on 10. 8. 23..
//  Copyright 2010 Dreamers Entertainment Co, Ltd. All rights reserved.
//

#import "DrGraphContentView.h"
#import "DrGraphView.h"


@implementation DrGraphContentView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
	debugRect(frame);
    return self;
}

- (void) setParent:(id)parent
{
	grapView = parent;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	DrGraphView *g = (DrGraphView*)grapView;
	CGContextRef c = UIGraphicsGetCurrentContext();
	self.backgroundColor = [UIColor clearColor];

	CGContextSetFillColorWithColor(c, g.backgroundColor.CGColor);
	
	if(g.scroll)
	{
		CGContextFillRect(c, rect);
	}
	[g drawScrollYGrid:c drawRect:rect];
	[g drawChart:c drawRect:rect];
}


- (void)dealloc {
    [super dealloc];
}


@end
