//
//  DrGraphLeftMarginView.m
//  DemoS7GraphView
//
//  Created by Gyuha Shin on 10. 8. 24..
//  Copyright 2010 Dreamers Entertainment Co, Ltd. All rights reserved.
//

#import "DrGraphLeftMarginView.h"
#import "DrGraphView.h"

@implementation DrGraphLeftMarginView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
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
//	CGContextSetFillColorWithColor(c, [UIColor redColor].CGColor);	
	CGContextFillRect(c, rect);
	
	CGContextSetLineDash(c, 0, NULL, 0);
	CGContextSetLineWidth(c, 0.4f);
	
	CGContextMoveToPoint(c, 1, [g offSetY]-g.margin);
	CGContextAddLineToPoint(c, 1, rect.size.height);
	CGContextClosePath(c);
	
	CGContextSetStrokeColorWithColor(c, g.gridXColor.CGColor);
	CGContextStrokePath(c);
	
}


- (void)dealloc {
    [super dealloc];
}


@end
