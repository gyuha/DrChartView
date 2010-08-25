//
//  DrGraphView.m
//  DrTouch
//
//  Created by Aleks Nesterow on 9/27/09.
//  aleks.nesterow@gmail.com
//  
//  Thanks to http://snobit.habrahabr.ru/ for releasing sources for his
//  Cocoa component named GraphView.
//  
//  Copyright © 2009, 7touchGroup, Inc.
//  All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  * Neither the name of the 7touchGroup, Inc. nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.
//  
//  THIS SOFTWARE IS PROVIDED BY 7touchGroup, Inc. "AS IS" AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL 7touchGroup, Inc. BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//  

#import "DrGraphView.h"

#define Y_GRID_NUM	6

@interface DrGraphView (PrivateMethods)

- (void)initializeComponent;

@end

@implementation DrGraphView

+ (UIColor *)colorByIndex:(NSInteger)index {
	
	UIColor *color;
	
	switch (index) {
		case 0: color = RGB(5, 141, 191);
			break;
		case 1: color = RGB(80, 180, 50);
			break;		
		case 2: color = RGB(255, 102, 0);
			break;
		case 3: color = RGB(255, 158, 1);
			break;
		case 4: color = RGB(252, 210, 2);
			break;
		case 5: color = RGB(248, 255, 1);
			break;
		case 6: color = RGB(176, 222, 9);
			break;
		case 7: color = RGB(106, 249, 196);
			break;
		case 8: color = RGB(178, 222, 255);
			break;
		case 9: color = RGB(4, 210, 21);
			break;
		default: color = RGB(204, 204, 204);
			break;
	}
	
	return color;
}

@synthesize dataSource = _dataSource, xValuesFormatter = _xValuesFormatter, yValuesFormatter = _yValuesFormatter;
@synthesize drawAxisX = _drawAxisX, drawAxisY = _drawAxisY, drawGridX = _drawGridX, drawGridY = _drawGridY;
@synthesize scroll = _scroll;
@synthesize gridXWidth = _gridXWidth, maxDisplayValues = _maxDisplayValues, defaultDisplayValues = _defaultDisplayValues;
@synthesize xValuesColor = _xValuesColor, yValuesColor = _yValuesColor, gridXColor = _gridXColor, gridYColor = _gridYColor;
@synthesize drawInfo = _drawInfo, info = _info, infoColor = _infoColor;
@synthesize margin = _margin;

- (id)initWithFrame:(CGRect)frame {
	
    if (self = [super initWithFrame:frame]) {
		[self initializeComponent];
    }
	contentView = nil;
    return self;
}

- (void)dealloc {
	
	[_xValuesFormatter release];
	[_yValuesFormatter release];
	
	[_xValuesColor release];
	[_yValuesColor release];
	
	[_gridXColor release];
	[_gridYColor release];
	
	[_info release];
	[_infoColor release];
	
	if (contentView != nil) {
		[contentView release];
	}

	[super dealloc];
}

/**
 * X offset
 */
- (CGFloat) offSetX
{
	return _drawAxisY ? 60.0f + _margin : 10.0f + _margin;
}

/**
 * Y offset
 */
- (CGFloat) offSetY
{
	return (_drawAxisX || _drawInfo) ? 30.0f + _margin: 10.0f + _margin;
}


/**
 * 스탭 지정하기
 */
- (void) setStep
{
	CGFloat minY = 0.0;
	CGFloat maxY = 0.0;
	
	for (NSUInteger plotIndex = 0; plotIndex < _numberOfPlots; plotIndex++) {
		
		NSArray *values = [self.dataSource graphView:self yValuesForPlot:plotIndex];
		
		for (NSUInteger valueIndex = 0; valueIndex < values.count; valueIndex++) {
			
			if ([[values objectAtIndex:valueIndex] floatValue] > maxY) {
				maxY = [[values objectAtIndex:valueIndex] floatValue];
			}
		}
	}
	
	if (maxY < 100) {
		maxY = ceil(maxY / 10) * 10;
	} 
	
	if (maxY > 100 && maxY < 1000) {
		maxY = ceil(maxY / 100) * 100;
	} 
	
	if (maxY > 1000 && maxY < 10000) {
		maxY = ceil(maxY / 1000) * 1000;
	}
	
	if (maxY > 10000 && maxY < 100000) {
		maxY = ceil(maxY / 10000) * 10000;
	}
	
	_step = (maxY - minY) / 5;
	_stepY = (self.frame.size.height - ([self offSetY] * 2)) / maxY;
}

/**
 * 옆 라인의 글자를 출력 한다.
 */
- (void) drawYHeader:(CGContextRef)c
{
	CGFloat offsetY = [self offSetY];
	
	UIFont *font = [UIFont systemFontOfSize:11.0f];
	for (NSUInteger i = 0; i < Y_GRID_NUM; i++) {
		
		NSUInteger y = (i * _step) * _stepY;
		NSUInteger value = i * _step;
		
		if (i > 0 && _drawAxisY) {
			
			NSNumber *valueToFormat = [NSNumber numberWithInt:value];
			NSString *valueString;
			
			if (_yValuesFormatter) {
				valueString = [_yValuesFormatter stringForObjectValue:valueToFormat];
			} else {
				valueString = [valueToFormat stringValue];
			}
			
			[self.yValuesColor set];
			CGRect valueStringRect = CGRectMake(0.0f, self.frame.size.height - y - offsetY, 50.0f, 20.0f);
			
			[valueString drawInRect:valueStringRect withFont:font
					  lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
		}
	}
}

/**
 * 라인 그리기
 */
-(void) drawYGrid:(CGContextRef)c
{
	CGFloat offsetX = [self offSetX];
	CGFloat offsetY = [self offSetY];

	for (NSUInteger i = 0; i < Y_GRID_NUM; i++) {
		NSUInteger y = (i * _step) * _stepY;
		if (_drawGridY) {
			CGFloat lineDash[2];
			lineDash[0] = 6.0f;
			lineDash[1] = 6.0f;
			
			if (i == 0 || i == Y_GRID_NUM -1) {
				CGContextSetLineDash(c, 0, NULL, 0);
				CGContextSetLineWidth(c, 0.4f);
			}else {
				CGContextSetLineDash(c, 0.0f, lineDash, 2);
				CGContextSetLineWidth(c, 0.1f);
			}
			
			CGPoint startPoint = CGPointMake(offsetX, y + offsetY);
			CGPoint endPoint = CGPointMake(self.frame.size.width - _margin, y + offsetY);
			CGContextMoveToPoint(c, startPoint.x, startPoint.y);
			CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
			CGContextClosePath(c);
			
			CGContextSetStrokeColorWithColor(c, self.gridYColor.CGColor);
			CGContextStrokePath(c);
		}
	}
}


/**
 * 스크롤의 외각 라인 그리기
 */
-(void) drawScrollYGrid:(CGContextRef)c drawRect:(CGRect)r
{
	CGFloat offsetY = [self offSetY];
	
	for (NSUInteger i = 0; i < Y_GRID_NUM; i++) {
		NSUInteger y = (i * _step) * _stepY;
		
		if (_drawGridY) {
			CGFloat lineDash[2];
			lineDash[0] = 6.0f;
			lineDash[1] = 6.0f;
			
			if (i == 0 || i == Y_GRID_NUM - 1) {
				CGContextSetLineDash(c, 0, NULL, 0);
				CGContextSetLineWidth(c, 0.4f);
			}else {
				CGContextSetLineDash(c, 0.0f, lineDash, 2);
				CGContextSetLineWidth(c, 0.1f);
			}
			
			CGPoint startPoint = CGPointMake(1, y + offsetY);
			CGPoint endPoint = CGPointMake(r.size.width-1, y + offsetY);
			CGContextMoveToPoint(c, startPoint.x, startPoint.y);
			CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
			CGContextClosePath(c);
			
			CGContextSetStrokeColorWithColor(c, self.gridYColor.CGColor);
			CGContextStrokePath(c);
		}
	}
}

/**
 * 내용 넓이
 */
-(CGRect) contentRect
{
	CGRect r;
	CGRect rect = self.bounds;
	CGFloat offsetX = [self offSetX];
	if (_scroll) {
		NSArray *xValues = [self.dataSource graphViewXValues:self];		//!< x의 값들
		NSUInteger xValuesCount = xValues.count;
		if (xValuesCount > _maxDisplayValues) {
			xValuesCount = _maxDisplayValues;
		}
		r = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width+(xValuesCount*_gridXWidth)-offsetX-(_margin*2), rect.size.height);
	}else {
		r = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width-offsetX-(_margin*2), rect.size.height);
	}
	return r;
}


/**
 * 외각 라인 그리기
 */
-(void) drawBackGroundOutLine:(CGContextRef)c
{
	CGFloat offsetX = [self offSetX];
	CGFloat offsetY = [self offSetY];
	
	CGContextSetLineDash(c, 0, NULL, 0);
	CGContextSetLineWidth(c, 0.4f);
	
	CGContextMoveToPoint(c, offsetX, offsetY);
	CGContextAddLineToPoint(c, offsetX, self.frame.size.height - offsetY);
	CGContextAddLineToPoint(c, self.frame.size.width-_margin, self.frame.size.height - offsetY);
	CGContextAddLineToPoint(c, self.frame.size.width-_margin, offsetY);	
//	CGContextAddLineToPoint(c, offsetX, _margin);
	CGContextClosePath(c);
	
	CGContextSetStrokeColorWithColor(c, self.gridXColor.CGColor);
	CGContextStrokePath(c);
}

/**
 * 정보를 출력 한다.
 */
-(void) drawInfo:(CGContextRef)c
{
	if (_drawInfo) {
		
		UIFont *font = [UIFont boldSystemFontOfSize:13.0f];
		[self.infoColor set];
		[_info drawInRect:CGRectMake(0.0f, 5.0f, self.frame.size.width, 20.0f) withFont:font
			lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
	}
}

/**
 * 챠트를 그린다.
 */
-(void) drawChart:(CGContextRef)c drawRect:(CGRect)r
{
	CGFloat offsetX = [self offSetX];
	CGFloat offsetY = [self offSetY];
	
	NSArray *xValues = [self.dataSource graphViewXValues:self];		//!< x의 값들
	NSUInteger xValuesCount = xValues.count;
	
	CGFloat step = _step;
	NSUInteger maxStep;
	UIFont *font = [UIFont systemFontOfSize:11.0f];
	
	if (_scroll) {
		if (xValuesCount > _maxDisplayValues) {
			step = (xValuesCount / _maxDisplayValues) + 1;
			maxStep = _maxDisplayValues;
		} else {
			step = 1;
			maxStep = xValuesCount;
		}
	}else {
		if (xValuesCount > _defaultDisplayValues) {
			
			NSUInteger stepCount = _defaultDisplayValues;
			NSUInteger count = xValuesCount - 1;
			
			for (NSUInteger i = 4; i < 8; i++) {
				if (count % i == 0) {
					stepCount = i;
				}
			}
			
			step = xValuesCount / stepCount;
			maxStep = stepCount + 1;
			
		} else {
			
			step = 1;
			maxStep = xValuesCount;
		}
	}

	
	CGFloat stepX = (r.size.width - (offsetX * 2)) / (xValuesCount - 1);

	for (NSUInteger i = 0; i < maxStep; i++) {
		
		NSUInteger x = (i * step) * stepX;
		
		if (x > r.size.width - (offsetX * 2)) {
			x = r.size.width - (offsetX * 2);
		}
		
		NSUInteger index = i * step;
		
		if (index >= xValuesCount) {
			index = xValuesCount - 1;
		}
		
		if (_drawGridX) {
			
			CGFloat lineDash[2];
			
			lineDash[0] = 6.0f;
			lineDash[1] = 6.0f;
			
			CGContextSetLineDash(c, 0.0f, lineDash, 2);
			CGContextSetLineWidth(c, 0.1f);
			
			CGPoint startPoint = CGPointMake(x + offsetX, offsetY);
			CGPoint endPoint = CGPointMake(x + offsetX, r.size.height - offsetY);
			
			CGContextMoveToPoint(c, startPoint.x, startPoint.y);
			CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
			CGContextClosePath(c);
			
			CGContextSetStrokeColorWithColor(c, self.gridXColor.CGColor);
			CGContextStrokePath(c);
		}
		
		if (_drawAxisX) {
			
			id valueToFormat = [xValues objectAtIndex:index];
			NSString *valueString;
			
			if (_xValuesFormatter) {
				valueString = [_xValuesFormatter stringForObjectValue:valueToFormat];
			} else {
				valueString = [NSString stringWithFormat:@"%@", valueToFormat];
			}
			
			[self.xValuesColor set];
			[valueString drawInRect:CGRectMake(x, r.size.height - 20.0f, 120.0f, 20.0f) withFont:font
					  lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
		}
	}
	
	stepX = (r.size.width - (offsetX * 2)) / (xValuesCount - 1);
	
	CGContextSetLineDash(c, 0, NULL, 0);
	
	for (NSUInteger plotIndex = 0; plotIndex < _numberOfPlots; plotIndex++) {
		
		NSArray *values = [self.dataSource graphView:self yValuesForPlot:plotIndex];
		BOOL shouldFill = NO;
		
		if ([self.dataSource respondsToSelector:@selector(graphView:shouldFillPlot:)]) {
			shouldFill = [self.dataSource graphView:self shouldFillPlot:plotIndex];
		}
		
		CGColorRef plotColor = [DrGraphView colorByIndex:plotIndex].CGColor;
		
		for (NSUInteger valueIndex = 0; valueIndex < values.count - 1; valueIndex++) {
			
			NSUInteger x = valueIndex * stepX;
			NSUInteger y = [[values objectAtIndex:valueIndex] intValue] * _stepY;
			
			CGContextSetLineWidth(c, 1.5f);
			
			CGPoint startPoint = CGPointMake(x + offsetX, r.size.height - y - offsetY);
			
			x = (valueIndex + 1) * stepX;
			y = [[values objectAtIndex:valueIndex + 1] intValue] * _stepY;
			
			CGPoint endPoint = CGPointMake(x + offsetX, r.size.height - y - offsetY);
			
			CGContextMoveToPoint(c, startPoint.x, startPoint.y);
			CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
			CGContextClosePath(c);
			
			CGContextSetStrokeColorWithColor(c, plotColor);
			CGContextStrokePath(c);
			
			if (shouldFill) {
				
				CGContextMoveToPoint(c, startPoint.x, r.size.height - offsetY);
				CGContextAddLineToPoint(c, startPoint.x, startPoint.y);
				CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
				CGContextAddLineToPoint(c, endPoint.x, r.size.height - offsetY);
				CGContextClosePath(c);
				
				CGContextSetFillColorWithColor(c, plotColor);
				CGContextFillPath(c);
			}
		}
	}
}

- (void)drawRect:(CGRect)rect {
	CGFloat offsetX = [self offSetX];
	CGFloat offsetY = [self offSetY];
	
	_numberOfPlots = [self.dataSource graphViewNumberOfPlots:self];
	[self setStep];	

	// 스크롤뷰 생성
	if (contentView == nil) {
		CGRect contentRect = [self contentRect];
		contentView = [[DrGraphContentView alloc] initWithFrame:contentRect];
		[contentView setParent:self];
		
		CGRect scrollRect = CGRectMake(offsetX / 2, 0 , rect.size.width-(offsetX/2), rect.size.height);
		scrollView = [[UIScrollView alloc] initWithFrame:scrollRect];
		[scrollView setScrollEnabled:YES];
		[scrollView addSubview:contentView];
		[scrollView setContentSize:contentView.frame.size];
		[self addSubview:scrollView];

		CGRect headerRect = CGRectMake(rect.origin.x, rect.origin.y, offsetX+1, rect.size.height-offsetY+1);		
		yHeaderView = [[DrGraphYHeaderView alloc] initWithFrame:headerRect];
		[yHeaderView setParent:self];
		[self addSubview:yHeaderView];
		
		CGRect leftRect = CGRectMake(rect.size.width - _margin, _margin , _margin, rect.size.height-offsetY-_margin+1);
		leftMarginView = [[DrGraphLeftMarginView alloc] initWithFrame:leftRect];
		[leftMarginView setParent:self];
		[self addSubview:leftMarginView];
		
	}
	
	if (!_numberOfPlots) {
		return;
	}

	CGContextRef c = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(c, self.backgroundColor.CGColor);
	CGContextFillRect(c, rect);

	[self drawYHeader:c];
	[self drawYGrid:c];
	[self drawBackGroundOutLine:c];
	[self drawInfo:c];
}

- (void)reloadData {
	
	[self setNeedsDisplay];
}

#pragma mark PrivateMethods

- (void)initializeComponent {
	
	_drawAxisX = YES;
	_drawAxisY = YES;
	_drawGridX = YES;
	_drawGridY = YES;
	
	_xValuesColor = [[UIColor blackColor] retain];
	_yValuesColor = [[UIColor blackColor] retain];
	
	_gridXColor = [[UIColor blackColor] retain];
	_gridYColor = [[UIColor blackColor] retain];
	
	_drawInfo = NO;
	_infoColor = [[UIColor blackColor] retain];
	_margin = 10.0f;
	
	_scroll = YES;
	_gridXWidth = 30.0f;
	_maxDisplayValues = 60;
	_defaultDisplayValues = 5;

}

@end
