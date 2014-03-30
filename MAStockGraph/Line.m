//
//  Line.m
//  MAStockGraph
//

#import "Line.h"

@implementation Line

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //Fill Top
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, [self.topColor CGColor]);
    CGContextSetAlpha(ctx, self.topAlpha);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, round(self.firstPoint.x), self.firstPoint.y);
    CGContextAddLineToPoint(ctx, round(self.secondPoint.x), self.secondPoint.y);
    CGContextAddLineToPoint(ctx, round(self.secondPoint.x), self.frame.origin.y);
    CGContextAddLineToPoint(ctx, round(self.firstPoint.x), self.frame.origin.x);
    CGContextClosePath(ctx);
    
    CGContextDrawPath(ctx, kCGPathFill);
    
    //Fill Bottom
    CGContextSetFillColorWithColor(ctx, [self.bottomColor CGColor]);
    CGContextSetAlpha(ctx, self.bottomAlpha);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, round(self.firstPoint.x), self.firstPoint.y);
    CGContextAddLineToPoint(ctx, round(self.secondPoint.x), self.secondPoint.y);
    CGContextAddLineToPoint(ctx, round(self.secondPoint.x), self.frame.size.height);
    CGContextAddLineToPoint(ctx, round(self.firstPoint.x), self.frame.size.height);
    CGContextClosePath(ctx);
    
    CGContextDrawPath(ctx, kCGPathFill);
    
    //Line Graph
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    
    [path1 setLineWidth:self.lineWidth];
    [path1 moveToPoint:self.firstPoint];
    [path1 addLineToPoint:self.secondPoint];
    path1.lineCapStyle = kCGLineCapRound;
    [self.color set];
    [path1 strokeWithBlendMode:kCGBlendModeNormal alpha:self.lineAlpha];
}


@end
