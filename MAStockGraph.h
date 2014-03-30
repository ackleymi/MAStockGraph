//
//  MAStockGraph.h
//  MAStockGraph
//


#import <UIKit/UIKit.h>
#import "Circle.h"
#import "Line.h"
#import "Animation.h"

@protocol StockGraphDelegate <NSObject>

@required


- (int)numberOfPointsInGraph;
- (float)valueForIndex:(NSInteger)index;

// Company Information
- (NSString *)companyName;
- (NSString *)ticker;
- (NSString *)priceInfo;
- (NSString *)stockPrice;


@optional

// Touch events
- (void)didTouchGraphWithClosestIndex:(int)index;
- (void)didReleaseGraphWithClosestIndex:(float)index;


// X Axis
- (int)numberOfGapsBetweenLabels;
- (NSString *)labelOnXAxisForIndex:(NSInteger)index;


@end

@interface MAStockGraph : UIView <UIGestureRecognizerDelegate, AnimationDelegate>

@property (assign) IBOutlet id <StockGraphDelegate> delegate;

@property (strong, nonatomic) Animation *animateDelegate;

@property (strong, nonatomic) UIView *verticalLine;

@property (strong, nonatomic) UIFont *labelFont;



/// Reload the graph
- (void)reloadGraph;



// Customize
@property (nonatomic) NSInteger animationGraphEntranceSpeed;

@property (nonatomic) BOOL enableTouchReport;

@property (strong, nonatomic) UIColor *colorBottom;

@property (nonatomic) float alphaBottom;

@property (strong, nonatomic) UIColor *colorTop;

@property (nonatomic) float alphaTop;

@property (strong, nonatomic) UIColor *colorLine;

@property (nonatomic) float alphaLine;

@property (nonatomic) float widthLine;

@property (strong, nonatomic) UIColor *colorXaxisLabel;

@end


