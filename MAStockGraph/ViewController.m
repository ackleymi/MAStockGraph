//
//  ViewController.m
//  MAStockGraph
//

#import "ViewController.h"



@interface ViewController ()

@property (strong, nonatomic) NSDictionary *allData;
@property (strong, nonatomic) NSArray *pricesArray;
@property (strong, nonatomic) NSArray *datesArray;

@property (strong, nonatomic) MAStockGraph *maV;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}
 
- (IBAction)stockBtn:(id)sender {
   
    [self symbolLookup];
    [self.symInput resignFirstResponder];
 }

// get the stock
-(void)symbolLookup{

    MAFinance *stockQuery = [MAFinance new];
    
    // set the symbol
    stockQuery.symbol = self.symInput.text;
    
    /* set time period
     MAFinanceTimeFiveDays
     MAFinanceTimeTenDays
     MAFinanceTimeOneMonth
     MAFinanceTimeThreeMonths
     MAFinanceTimeOneYear
     MAFinanceTimeFiveYears
     */
    stockQuery.period = MAFinanceTimeOneMonth;
    
    // Put an indicator in the view
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 210);
    spinner.color = [UIColor colorWithRed:0.0 green:140.0/255.0 blue:255.0/255.0 alpha:1.0];
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    // fetch the stock from Yahoo Finance
    [stockQuery findStockDataWithBlock:^(NSDictionary *stockData, NSError *error) {
       if (!error) {
           // remove the indicator
           [spinner removeFromSuperview];
           
            // we've got our data
           self.allData = stockData;
           NSLog(@"%@", [[self.allData objectForKey:@"StockInformation"] allKeys]);
           
           self.pricesArray = [stockData objectForKey:@"Prices"];
           self.datesArray = [stockData objectForKey:@"Dates"];

           [self.stockTable reloadData];
           
           self.maV = [MAStockGraph new];
           self.maV.delegate = self;
           self.maV.backgroundColor = [UIColor colorWithRed:0.0 green:140.0/255.0 blue:255.0/255.0 alpha:1.0];
           self.maV.colorTop = [UIColor clearColor];
           self.maV.colorBottom = [UIColor clearColor];
           self.maV.colorLine = [UIColor whiteColor];
           self.maV.colorXaxisLabel = [UIColor whiteColor];
           self. maV.widthLine = 1.0;
           self. maV.enableTouchReport = YES;
           
           [self.maV reloadGraph];
           
        } else {
            // something went wrong, log the error
            NSLog(@"Error - %@", error.localizedDescription);
        }
    }];
    
}


#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    else{
	return [[[self.allData objectForKey:@"StockInformation"] allKeys]count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    
    cell.textLabel.text = [[[self.allData objectForKey:@"StockInformation"] allKeys]objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[[self.allData objectForKey:@"StockInformation"] allValues]objectAtIndex:indexPath.row]];

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return self.maV;
    }
    else{
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 210;
    }
    else{
        return 0;
        
    }
}


#pragma mark - MAStockGraph Data Source

- (int)numberOfPointsInGraph {
    return (int)[self.pricesArray count];
}

- (float)valueForIndex:(NSInteger)index {
    return [[self.pricesArray objectAtIndex:index] floatValue];
}

#pragma mark - MAStockGraph Delegate

- (int)numberOfGapsBetweenLabels {
    return 1;
}

- (NSString *)labelOnXAxisForIndex:(NSInteger)index {
    return [self.datesArray objectAtIndex:index];
}
// Company name
- (NSString *)companyName{
return [[self.allData objectForKey:@"StockInformation"] valueForKey:@"Name"];
}
// Company ticker
- (NSString *)ticker{
return [[self.allData objectForKey:@"StockInformation"] valueForKey:@"Symbol"];
}
// Change in the stock price in the last trading session
- (NSString *)priceInfo{
return [NSString stringWithFormat:@"%@ (%@)", [[self.allData objectForKey:@"StockInformation"]valueForKey:@"Change"], [[self.allData objectForKey:@"StockInformation"]valueForKey:@"ChangeinPercent"]];
}
// Last price
- (NSString *)stockPrice{
return [[self.allData objectForKey:@"StockInformation"] valueForKey:@"LastTradePriceOnly"];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
