//
//  AddManualDetailViewController.h
//  LocationLogger
//
//  Created by Erin Krentz on 10/29/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocalEntry.h"
#import "Entry.h"

@interface AddManualDetailViewController : UIViewController

@property (nullable, nonatomic, strong) Entry *entry;

@property (nullable, nonatomic, strong) LocalEntry *localEntry;


@property (nullable, nonatomic, strong) NSString *entryCity;
@property (nullable, nonatomic, strong) NSString *entryState;
@property (nullable, nonatomic, strong) NSString *entryCountry;

@end
