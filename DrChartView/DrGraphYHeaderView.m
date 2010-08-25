//
//  DrGraphYHeaderView.m
//  DemoS7GraphView
//
//  Created by Gyuha Shin on 10. 8. 24..
//  Copyright 2010 Dreamers Entertainment Co, Ltd. All rights reserved.
//

#import "DrGraphYHeaderView.h"
#import "DrGraphView.h"

@implementation DrGraphYHeaderView


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

/**
 * @TODO 이벤트를 통과해서 하단에 전달해 주는 코드를 작성 하자.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
/*	
	// Start a timer to trigger the display of the slider and the processing of events.
	touchesTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(showSlider:) userInfo:nil repeats:NO];
	
	// Where are we at right now?
	UITouch *touch = [touches anyObject];
	CGPoint currentPoint = [touch locationInView:self.view];
	lastPage = [self page:currentPoint.y];
	
	// Pass the event though until we need it.
	//  [self.nextResponder touchesBegan:touches withEvent:event];
	if ([touch.view isKindOfClass:[UIScrollView class]]) 
	{
        if (self.nextResponder != nil &&
			[self.nextResponder respondsToSelector:@selector(touchesEnded:withEvent:)]) 
        {
			[self.nextResponder touchesEnded:touches withEvent:event];
        }
	}
*/
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	DrGraphView *g = (DrGraphView*)grapView;
	CGContextRef c = UIGraphicsGetCurrentContext();
	self.backgroundColor = [UIColor clearColor];
	CGContextSetFillColorWithColor(c, g.backgroundColor.CGColor);
	CGContextFillRect(c, rect);
	[g drawYHeader:c];
	
	CGContextSetLineDash(c, 0, NULL, 0);
	CGContextSetLineWidth(c, 0.4f);
	
	CGContextMoveToPoint(c, rect.size.width-1, [g offSetY]);
	CGContextAddLineToPoint(c, rect.size.width-1, rect.size.height);
	CGContextClosePath(c);
	
	CGContextSetStrokeColorWithColor(c, g.gridXColor.CGColor);
	CGContextStrokePath(c);
	
//	[g drawBackGroundOutLine:c];
}


- (void)dealloc {
    [super dealloc];
}


@end
