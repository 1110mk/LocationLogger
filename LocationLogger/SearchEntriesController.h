//
//  SearchEntriesController.h
//  LocationLogger
//
//  Created by Erin Krentz on 11/18/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StateData.h"
#import "Stack.h"
#import "Entry.h"


@interface SearchEntriesController : NSObject

+ (NSMutableArray *)sortAllTheEntriesByDate: (NSArray *)entriesToSort;

+ (NSMutableArray *)sortAllTheEntriesByState: (NSArray *)entriesToSort;

+ (NSMutableArray *)sortAllTheEntriesByPercent: (NSArray *)entriesToSort;

@end
