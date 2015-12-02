//
//  CheckEntryController.h
//  LocationLogger
//
//  Created by Erin Krentz on 11/13/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entry+CoreDataProperties.h"
#import "Stack.h"
#import "LocationEntryController.h"
#import "TemporaryEntry.h"



@interface CheckEntryController : NSObject

@property (strong, nonatomic, readonly) NSArray *entries;
@property (strong, nonatomic) NSString *requestType;

+ (TemporaryEntry *)checkEntryWithTimestamp:(NSDate *)timestamp
                          location:(CLLocation *)location
                         placemark:(CLPlacemark *)placemark
                         partOfDay:(NSString *)partOfDay
                        manualFlag:(NSNumber *)manualFlag
                           stateUS:(NSString *)stateUS;



@end
