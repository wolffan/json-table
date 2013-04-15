//
//  RLF_MainData.m
//  TuentiTest
//
//  Created by Raimon Lapuente on 09/03/13.
//  Copyright (c) 2013 RaimonLapuente. All rights reserved.
//

#import "RLF_MainData.h"

@implementation RLF_MainData

- (id) init
{
    self = [super init];
    if(self){
        rates = @{@"":@""};
        transactions = @[@""];
        transactionList = [[NSSet alloc] init];
        transactionHash = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (RLF_MainData *) sharedStore
{
    static RLF_MainData *sharedStore = nil;
    if(!sharedStore)
        sharedStore = [[super allocWithZone:nil]init];
    return sharedStore;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (NSDictionary *) getRates
{
    return rates;
}

- (NSArray *) getTransactions
{
    return transactions;
}

- (NSSet *) getSimpleList
{
    return transactionList;
}

- (int) getNoRepeat
{
    return [transactionList count];
}

- (void) setRates: (NSDictionary *)JSON
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (NSDictionary *temp in JSON) {
        [dict setObject:[temp objectForKey:@"rate"] forKey:[NSString stringWithFormat:@"%@-%@",[temp objectForKey:@"from"],[temp objectForKey:@"to"]]];
    }
    rates = dict;
}

- (void) setTransactions: (NSArray *) JSON
{
    transactions = JSON;
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:@[]];
    for (NSDictionary *elemenet in transactions) {
        NSString *elementId = [elemenet objectForKey:@"sku"];
        [temp addObject:elementId];
        if ([transactionHash objectForKey:elementId] == nil){
            NSArray *tempArray = [NSArray arrayWithObject:elemenet];
            [transactionHash setObject:tempArray forKey:elementId];
        } else {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[transactionHash objectForKey:elementId]];
            [tempArray addObject:elemenet];
            [transactionHash setObject:tempArray forKey:elementId];
        }
    }
    transactionList = [NSSet setWithArray:temp];
}

- (NSString *) getNoRepeatAtIndex: (NSInteger)index
{
    NSArray *temp = [transactionList allObjects];
    return [temp objectAtIndex:index];
}

- (NSArray *) getArrayForSku: (NSString *) sku
{
    return [transactionHash objectForKey:sku];
}

@end
