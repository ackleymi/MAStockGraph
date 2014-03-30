//
//  ViewController.h
//  MAStockGraph
//


#import <UIKit/UIKit.h>
#import "MAFinance.h"
#import "MAStockGraph.h"


@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, StockGraphDelegate>

- (IBAction)stockBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *symInput;
@property (strong, nonatomic) IBOutlet UITableView *stockTable;


@end
