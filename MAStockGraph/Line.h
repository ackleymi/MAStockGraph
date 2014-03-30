//
//  Line.h
//  MAStockGraph
//

#import <UIKit/UIKit.h>

@interface Line : UIView

@property (assign, nonatomic) CGPoint  firstPoint;
@property (assign, nonatomic) CGPoint  secondPoint;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *topColor;
@property (strong, nonatomic) UIColor *bottomColor;
@property (nonatomic) float topAlpha;
@property (nonatomic) float bottomAlpha;
@property (nonatomic) float lineAlpha;

@property (nonatomic) float lineWidth;

@end
