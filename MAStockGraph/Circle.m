//
//  Circle.m
//  MAStockGraph
//


#import "Circle.h"

@implementation Circle

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    [[UIColor whiteColor] set];
    CGContextFillPath(ctx);
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
