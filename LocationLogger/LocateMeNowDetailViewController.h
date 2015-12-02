
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
#import "Entry.h"




@interface LocateMeNowDetailViewController : UIViewController <CLLocationManagerDelegate>

@property (nullable, nonatomic, strong) CLLocationManager *locationManager;
@property (nullable, nonatomic, strong) Entry *entry;
@property (nullable, nonatomic, strong) Entry *localEntry;




//two properties passed to AddManualController with City and State
@property (nullable, nonatomic, strong) NSString *entryCity;
@property (nullable, nonatomic, strong) NSString *entryState;
@property (nullable, nonatomic, strong) NSString *entryCountry;



@property (nullable, strong, nonatomic) NSString *currentStateUS;
@property (nullable, strong, nonatomic) CLLocation *currentLocation;
@property (nullable, strong, nonatomic) CLPlacemark *currentPlacemark;
@property (nullable, strong, nonatomic) NSDate *currentTimestamp;
@property (nullable, strong, nonatomic) NSNumber *currentManualFlag;
@property (nullable, strong, nonatomic) NSString *currentPartOfDay;





@end
