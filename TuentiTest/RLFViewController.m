//
//  RLFViewController.m
//  TuentiTest
//
//  Created by Raimon Lapuente on 09/03/13.
//  Copyright (c) 2013 RaimonLapuente. All rights reserved.
//

#import "RLFViewController.h"
#import "RLF_MainData.h"
#import "RLF_TransactionsViewController.h"

@interface RLFViewController ()

@end

@implementation RLFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //load the Dictionaries
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    //we download the data once the view is showed
    [self downloadInfo];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Choose Transaction";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) downloadInfo
{
    dispatch_queue_t async = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    
    //block that downloads the info
    dispatch_async(async, ^{
        NSURL *url = [NSURL URLWithString:@"http://quiet-stone-2094.herokuapp.com/rates.json"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //save dictrionary
        [[RLF_MainData sharedStore] setRates:dict];
        url = [NSURL URLWithString:@"http://quiet-stone-2094.herokuapp.com/transactions.json"];
        data = [NSData dataWithContentsOfURL:url];
        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [[RLF_MainData sharedStore] setTransactions:dict];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.transactionTypes reloadData];
        });
    });
}

#pragma mark - Table data

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[RLF_MainData sharedStore] getNoRepeat];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *identifier = @"Transaction";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [[RLF_MainData sharedStore] getNoRepeatAtIndex:indexPath.row];

    return cell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Element selected %@",[[RLF_MainData sharedStore] getNoRepeatAtIndex:indexPath.row]);
    RLF_TransactionsViewController *transactionsView = [[RLF_TransactionsViewController alloc] initWithNibName:@"RLF_TransactionsViewController" bundle:nil];
    [transactionsView setTransactionViewWithElement:[[RLF_MainData sharedStore] getNoRepeatAtIndex:indexPath.row]];
    [[self navigationController] pushViewController:transactionsView animated:YES];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

@end
