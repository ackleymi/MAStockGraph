//
//  MAFinance.m
//  MAStockGraph
//


#import "MAFinance.h"

#define QUOTE_QUERY_PREFIX @"http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22"
#define QUOTE_QUERY_SUFFIX @"%22)&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&format=json"
#define QUOTE_HISTORY_PREFIX @"http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.historicaldata%20where%20symbol%20%3D%20%22"
#define QUOTE_HISTORY_PREMIDFIX @"%22%20and%20startDate%20%3D%20%22"
#define QUOTE_HISTORY_MIDFIX @"%22%20and%20endDate%20%3D%20%22"
#define QUOTE_HISTORY_SUFFIX @"%22&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&format=json"

@interface MAFinance ()
@end


@implementation MAFinance
@synthesize symbol, period;



- (void)findStockDataWithBlock:(MAFinanceResultBlock)block
{
    symbol = [symbol uppercaseString];
    
    NSString *symbolURL = [self symbolUrlText];
    NSURL *getUrl = [NSURL URLWithString:symbolURL];

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:getUrl];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue new]
                           completionHandler:^(NSURLResponse *resp, NSData *data, NSError *errorOne) {
                               
                if (!errorOne) {
                                   
                NSDictionary *oneDctnry = [[[[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]valueForKey:@"query"] valueForKey:@"results"]valueForKey:@"quote"];
                                   
                NSString *tnsURL = [self timesalesUrlText];
                NSURL *tnsUrl = [NSURL URLWithString:tnsURL];
                NSMutableURLRequest *requestTwo = [NSMutableURLRequest requestWithURL:tnsUrl];
                [NSURLConnection sendAsynchronousRequest:requestTwo
                        queue:[NSOperationQueue new]
                        completionHandler:^(NSURLResponse *respTwo, NSData *dataTwo, NSError *errorTwo) {
                            
                        if (!errorTwo) {
                                                                  
                        NSDictionary *twoDctnry = [self timesalesFromRawData:[[[[NSJSONSerialization JSONObjectWithData:dataTwo options:NSJSONReadingMutableContainers error:nil]valueForKey:@"query"]valueForKey:@"results"]valueForKey:@"quote"]];
                                                                  
                            NSArray *rversePrices = [[[twoDctnry objectForKey:@"prices"] reverseObjectEnumerator]allObjects];
                            NSArray *rverseDates = [[[twoDctnry objectForKey:@"dates"]reverseObjectEnumerator]allObjects];

                                    NSDictionary *stockData = [NSDictionary dictionaryWithObjects:@[rversePrices,rverseDates,oneDctnry] forKeys:@[@"Prices",@"Dates",@"StockInformation"]];
                            
                                    block(stockData, nil);
                                                                  
                                        }
                                                              
                        else {
                                block(nil, errorTwo);
                                                                  
                            }
                                                              
                            }];
                    }
                    else {
                    block(nil, errorOne);

                        }

            }];
}




- (NSString *)symbolUrlText{

    ////get the stock data url

    NSString *symbolURL = [NSString stringWithFormat:@"%@%@%@", QUOTE_QUERY_PREFIX, symbol, QUOTE_QUERY_SUFFIX];


    return symbolURL;

}

- (NSDictionary *)timesalesFromRawData:(id)raw{
    
    NSMutableArray *dates = [NSMutableArray array];

    for (id timePoint in [raw valueForKey:@"Date"])
    {
        
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateFromString = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@", timePoint]];
        [dateFormatter setDateFormat:@"dd"];
        [dates addObject:[dateFormatter stringFromDate:dateFromString]];

    }
    
   
    NSDictionary *ts = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[raw valueForKey:@"Close"],dates, nil] forKeys:[NSArray arrayWithObjects:@"prices", @"dates", nil]];

    return ts;

}

- (NSString *)timesalesUrlText{
    ////get the time and sales data url
    
    NSDate *then = [NSDate new];
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowString = [formatter stringFromDate:now];
    
    switch (period) {
        case MAFinanceTimeFiveDays:
            then = [now dateByAddingTimeInterval:-432000];
            break;
        case MAFinanceTimeTenDays:
            then = [now dateByAddingTimeInterval:-864000];
            break;
        case MAFinanceTimeOneMonth:
            then = [now dateByAddingTimeInterval:-2592000];
            break;
        case MAFinanceTimeThreeMonths:
            then = [now dateByAddingTimeInterval:-7776000];
            break;
        case MAFinanceTimeOneYear:
            then = [now dateByAddingTimeInterval:-31536000];
            break;
        case MAFinanceTimeFiveYears:
            then = [now dateByAddingTimeInterval:-157680000];
            break;
        default:
            break;
    }

    NSString *thenString = [formatter stringFromDate:then];
    
    NSString *timesalesURL = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",QUOTE_HISTORY_PREFIX, symbol, QUOTE_HISTORY_PREMIDFIX, thenString, QUOTE_HISTORY_MIDFIX, nowString, QUOTE_HISTORY_SUFFIX];
    
    return timesalesURL;
    
}

- (void)dealloc
{

}








@end
