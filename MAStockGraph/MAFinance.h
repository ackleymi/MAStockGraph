//
//  MAFinance.h
//  MAStockGraph
//

#import <UIKit/UIKit.h>

typedef enum {
    MAFinanceTimeFiveDays,
    MAFinanceTimeTenDays,
    MAFinanceTimeOneMonth,
    MAFinanceTimeThreeMonths,
    MAFinanceTimeOneYear,
    MAFinanceTimeFiveYears,
} MAFinanceTimePeriod;

typedef void (^MAFinanceResultBlock)(NSDictionary *stockData, NSError *error);


@interface MAFinance : NSObject

@property (readwrite, assign) MAFinanceTimePeriod period;
@property (strong, nonatomic) NSString *symbol;

- (void)findStockDataWithBlock:(MAFinanceResultBlock)block;


@end
