//
//  Stack.m
//  LocationLog
//
//  Created by Erin Krentz on 10/13/15.
//  Copyright © 2015 Erin Krentz. All rights reserved.
//

#import "Stack.h"

@interface Stack ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end


@implementation Stack

+ (Stack *)sharedInstance {
    static Stack *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [Stack new];
    });
    return sharedInstance;
}

-(id)init {
    self = [super init];
    if (self) {
        [self setupManagedObjectContext];
    }
    return self;
}

-(void)setupManagedObjectContext {
        self.managedObjectContext = [[NSManagedObjectContext alloc]
                                     initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSError *error;
    [self.managedObjectContext.persistentStoreCoordinator
        addPersistentStoreWithType:NSSQLiteStoreType
        configuration:nil
        URL:self.storeURL
        options:nil
        error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
    }
    
    self.managedObjectContext.undoManager = [[NSUndoManager alloc] init];
}

-(NSURL *)storeURL {
    NSURL *documentsDirectory = [[NSFileManager defaultManager]
                                URLForDirectory:NSDocumentDirectory
                                inDomain:NSUserDomainMask
                                appropriateForURL:nil
                                create:YES
                                error:NULL];
    return [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];
}


- (NSURL *)modelURL {
    return [[NSBundle mainBundle] URLForResource:@"EntryModel" withExtension:@"momd"];
}

- (NSManagedObjectModel *)managedObjectModel
{
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
}

@end
