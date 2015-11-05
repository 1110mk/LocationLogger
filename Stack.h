//
//  Stack.h
//  LocationLog
//
//  Created by Erin Krentz on 10/13/15.
//  Copyright © 2015 Erin Krentz. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface Stack : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;


+ (Stack *)sharedInstance;


@end
