//
//  AddManualDetailViewController.h
//  LocationLogger
//
//  Created by Erin Krentz on 10/29/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Entry.h"
#import "TemporaryEntry.h"

@interface AddManualDetailViewController : UIViewController

@property (nullable, nonatomic, strong) TemporaryEntry *tmpEntry;

@property (nullable, nonatomic, strong) NSString *entryCity;
@property (nullable, nonatomic, strong) NSString *entryState;
@property (nullable, nonatomic, strong) NSString *entryCountry;

// The local properties of an entry to store location data until saved in Stored Database
@property (nullable, strong, nonatomic) NSString *addManualStateUS;
@property (nullable, strong, nonatomic) CLLocation *addManualLocation;
@property (nullable, strong, nonatomic) CLPlacemark *addManualPlacemark;
@property (nullable, strong, nonatomic) NSDate *addManualTimestamp;
@property (nullable, strong, nonatomic) NSNumber *addManualManualFlag;
@property (nullable, strong, nonatomic) NSString *addManualPartOfDay;


@end
