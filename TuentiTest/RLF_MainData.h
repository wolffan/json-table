//
//  RLF_MainData.h
//  TuentiTest
//
//  Created by Raimon Lapuente on 09/03/13.
//  Copyright (c) 2013 RaimonLapuente. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLF_MainData : NSObject
{
    NSDictionary *rates;
    NSArray *transactions;
    NSSet *transactionList;
    NSMutableDictionary *transactionHash;
}
+ (RLF_MainData *) sharedStore;
+ (id) allocWithZone:(NSZone *)zone;
- (void) setRates: (NSDictionary *)JSON;
- (void) setTransactions: (NSDictionary *) JSON;
- (NSDictionary *) getTransactions;
- (NSDictionary *) getRates;
- (int) getNoRepeat;
- (NSString *) getNoRepeatAtIndex: (NSInteger)index;
- (NSArray *) getArrayForSku: (NSString *) sku;

@end
