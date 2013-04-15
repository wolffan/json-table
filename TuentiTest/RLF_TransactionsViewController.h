//
//  RLF_TransactionsViewController.h
//  TuentiTest
//
//  Created by Raimon Lapuente on 09/03/13.
//  Copyright (c) 2013 RaimonLapuente. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLF_TransactionsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UITableView *table;

- (void) setTransactionViewWithElement: (NSString *)name;

@end
