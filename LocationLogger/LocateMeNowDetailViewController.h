
//
//  LocateMeNowDetailViewController.h
//  LocationLogger
//
//  Created by Erin Krentz on 10/29/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import <CoreLocation/CoreLocation.h>
#import "Entry.h"
#import "LocalEntry.h"




@interface LocateMeNowDetailViewController : UIViewController <CLLocationManagerDelegate>

@property (nullable, nonatomic, strong) CLLocationManager *locationManager;
@property (nullable, nonatomic, strong) Entry *entry;
@property (nullable, nonatomic, strong) LocalEntry *localEntry;




//two properties passed to AddManualController with City and State
@property (nullable, nonatomic, strong) NSString *entryCity;
@property (nullable, nonatomic, strong) NSString *entryState;
@property (nullable, nonatomic, strong) NSString *entryCountry;




@end
