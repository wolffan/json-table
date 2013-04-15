//
//  RLF_TransactionsViewController.m
//  TuentiTest
//
//  Created by Raimon Lapuente on 09/03/13.
//  Copyright (c) 2013 RaimonLapuente. All rights reserved.
//

#import "RLF_TransactionsViewController.h"
#import "RLF_MainData.h"

@interface RLF_TransactionsViewController ()

@property (nonatomic,retain) NSString *sku;
@property (nonatomic, retain) NSArray *array;
@property (assign) double totals;

@end

@implementation RLF_TransactionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _sku = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.total.text = [NSString stringWithFormat:@"%f",self.totals];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setTransactionViewWithElement: (NSString *)name
{
    self.navigationItem.title = name;
    self.sku = name;
    self.array = [[RLF_MainData sharedStore]getArrayForSku:self.sku];
    
    //calculate totals
    NSDictionary *rates = [[RLF_MainData sharedStore] getRates];
    
    for (int i = 0; i < [self.array count]; i++) {
        NSDictionary *element = [self.array objectAtIndex:i];
        
        NSString *currency = [element objectForKey:@"currency"];
        NSString *amount = [element objectForKey:@"amount"];
        
        if ([currency isEqualToString:@"EUR"]) {
            self.totals = self.totals + [amount doubleValue];
        } else {
            //get amount in value
            if ([currency isEqualToString:@"USD"]) {
                if ([rates objectForKey:@"USD-EUR"] != nil) {
                    NSString *rate = [rates objectForKey:@"USD-EUR"];
                    self.totals = self.totals + ([amount doubleValue] * [rate doubleValue]);
                } else {
                    //need rate
                    if ([rates objectForKey:@"CAD-EUR"] != nil && [rates objectForKey:@"USD-CAD"] != nil) {
                        NSString *rate1 = [rates objectForKey:@"CAD-EUR"];
                        NSString *rate2 = [rates objectForKey:@"USD-CAD"];
                        self.totals = self.totals + ([amount doubleValue] * [rate1 doubleValue] * [rate2 doubleValue]);
                    } else {
                        NSString *rate1 = [rates objectForKey:@"AUD-EUR"];
                        NSString *rate2 = [rates objectForKey:@"USD-AUD"];
                        self.totals = self.totals + ([amount doubleValue] * [rate1 doubleValue] * [rate2 doubleValue]);
                    }
                }
            } else if ([currency isEqualToString:@"CAD"]) {
                if ([rates objectForKey:@"CAD-EUR"] != nil) {
                    NSString *rate = [rates objectForKey:@"CAD-EUR"];
                    self.totals = self.totals + ([amount doubleValue] * [rate doubleValue]);
                } else {
                    //need rate
                    if ([rates objectForKey:@"USD-EUR"] != nil && [rates objectForKey:@"CAD-USD"] != nil) {
                        NSString *rate1 = [rates objectForKey:@"CAD-USD"];
                        NSString *rate2 = [rates objectForKey:@"USD-EUR"];
                        self.totals = self.totals + ([amount doubleValue] * [rate1 doubleValue] * [rate2 doubleValue]);
                    } else {
                        NSString *rate1 = [rates objectForKey:@"CAD-AUD"];
                        NSString *rate2 = [rates objectForKey:@"AUD-EUR"];
                        self.totals = self.totals + ([amount doubleValue] * [rate1 doubleValue] * [rate2 doubleValue]);                    }
                }
            } else if([currency isEqualToString:@"AUD"]) {
                if ([rates objectForKey:@"AUD-EUR"] != nil) {
                    NSString *rate = [rates objectForKey:@"AUD-EUR"];
                    self.totals = self.totals + ([amount doubleValue] * [rate doubleValue]);
                } else {
                    //need to calculate the proportion
                    if ([rates objectForKey:@"USD-EUR"] != nil && [rates objectForKey:@"UD-USD"] != nil) {
                        NSString *rate1 = [rates objectForKey:@"AUD-USD"];
                        NSString *rate2 = [rates objectForKey:@"USD-EUR"];
                        self.totals = self.totals + ([amount doubleValue] * [rate1 doubleValue] * [rate2 doubleValue]);
                    } else {
                        NSString *rate1 = [rates objectForKey:@"AUD-CAD"];
                        NSString *rate2 = [rates objectForKey:@"CAD-EUR"];
                        self.totals = self.totals + ([amount doubleValue] * [rate1 doubleValue] * [rate2 doubleValue]);
                    }
                }
            }
            
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *identifier = @"TransactionDetail";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    //calculate total
    NSDictionary *element = [self.array objectAtIndex:indexPath.row];
    
    NSString *currency = [element objectForKey:@"currency"];
    NSString *amount = [element objectForKey:@"amount"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",currency,amount];
    
    //calculate totals
    
    return cell;
    
}

@end
