//
//  Animation.h
//  MAStockGraph
//

#import <Foundation/Foundation.h>
#import "Circle.h"
#import "Line.h"

@protocol AnimationDelegate <NSObject>

@end

@interface Animation : NSObject

- (void)animationForDot:(NSInteger)dotIndex circleDot:(Circle *)circleDot animationSpeed:(NSInteger)speed;
- (void)animationForLine:(NSInteger)lineIndex line:(Line *)line animationSpeed:(NSInteger)speed;

@property (assign) id <AnimationDelegate> delegate;

@end