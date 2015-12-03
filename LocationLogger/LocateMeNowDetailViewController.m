//
//  LocateMeNowDetailViewController.m
//  LocationLogger
//
//  Created by Erin Krentz on 10/29/15.
//  Copyright © 2015 EMK. All rights reserved.
//
//  There are two ways a user can enter a location.
//      1. The phone provides his current location and the user saves it.
//      2. The user manually adds the fields.
//
//  This detail view controller provides the first way.
//      1. gets the user location using GPS,
//      2. sets all the properties on that Entry location
//
//  User has option to SAVE location or CHANGE location
//  If this is a duplicate Entry, asks User which Entry to keep
//      3. calls LocationEntryController to SAVE that location in Core Data
//      4. segues to AddManualDetailViewController if user selects CHANGE
//         to change the location manually

#import "LocateMeNowDetailViewController.h"
#import "LocationEntryController.h"
#import "Entry.h"
#import "Entry.h"
#import "AddManualDetailViewController.h"
#import "CheckEntryController.h"
#import "TemporaryEntry.h"


@interface LocateMeNowDetailViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;


@property (weak, nonatomic) IBOutlet UIButton *locateSaveButton;
@property (weak, nonatomic) IBOutlet UIButton *locateChangeButton;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pleaseWaitLabel;

@property (weak, nonatomic) NSString *locationString;


@end

@implementation LocateMeNowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationLabel.text = nil;
    self.dateLabel.text = nil;
    self.pleaseWaitLabel.text = @"Please Wait For Location";
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    // hides the save and change buttons until the
    // GPS has a chance to locate the user & set the map
    self.locateSaveButton.hidden = YES;
    self.locateChangeButton.hidden = YES;
    self.pleaseWaitLabel.hidden = NO;
    
    // Uses CLLocation manager to locate the user
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [self.locationManager requestLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    UIAlertController* errorAlert = [UIAlertController alertControllerWithTitle:@"LocationAlert"
        message:@"Failed to get your location."
        preferredStyle:UIAlertControllerStyleAlert];
    
    [errorAlert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Alert");
        }]];
    
    
    [self presentViewController:errorAlert animated:YES completion:nil];
    
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"Did change status");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //When the location manager gets a new location, update the user's location

    
    //Get the location from which the 6 properties are derived
    
    //1. Set the location property, latitude and longitude coordinates
    if (locations) {
        self.currentLocation = [locations lastObject];
        self.currentTimestamp = self.currentLocation.timestamp;
    } else {
        self.currentTimestamp = [NSDate date];
    }
    
    //2. Set the timestamp property
    NSLog(@"\n\nCurrentLocation Timestamp in LocateMeNow %@", self.currentTimestamp);
    
    //3. In order to set the Part Of Day property, calculate the hour in the day
    //      Use NSDateFormatter and NSCalendar to get these from timestamp
    
    //Get the month and day
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, y"];
    
    //Create the date string that will be added to the label in the view
    NSString *dateString = [dateFormatter stringFromDate:self.currentTimestamp];
    

    
    //3. Set the part of day property and label
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSCalendarUnit units = NSCalendarUnitHour | NSCalendarUnitDay| NSCalendarUnitMonth| NSCalendarUnitYear;
    
    NSDateComponents *components = [calendar components:units fromDate:self.currentTimestamp];
    
    NSInteger hour = [components hour];
    
    NSString *partOfDayString = [[NSString alloc] init];
    NSString *dateAndPartOfDayString = [[NSString alloc] init];
    
    if (hour <= 8)
    {
        partOfDayString = @"AM";
        dateAndPartOfDayString = [dateString stringByAppendingString:@"   AM"];

        
    }
    else if ((hour > 8) && (hour <16))
    {
        partOfDayString = @"MID";
        dateAndPartOfDayString = [dateString stringByAppendingString:@"   MID"];

    }
    else if (hour >= 16) {
        partOfDayString = @"PM";
        dateAndPartOfDayString = [dateString stringByAppendingString:@"   PM"];

    }
    
    
    //3. set the Part Of Day property
    self.currentPartOfDay = partOfDayString;
    
    //4. set the Manual Flag property
    self.currentManualFlag = [NSNumber numberWithBool:YES];
    
    //5. set the Placemark property by
    //          - getting the geocode placemark
    //          - activating activity indicator view since may take awhile
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    
    [self.activityIndicatorView startAnimating];
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error is in reverse Geocode %@", error.description);
        } else if (placemarks && placemarks.count > 0 ) {

            self.currentPlacemark = [placemarks lastObject];
            
            
            [self.activityIndicatorView stopAnimating];
            self.entryCity = self.currentPlacemark.locality;
            self.entryState = self.currentPlacemark.administrativeArea;
            self.entryCountry = self.currentPlacemark.country;
            
            
            //set the label on the view with the location
            
            //First check to see if there is a street number
            NSString *streetNumberString = @"";
            NSString *streetString = @"";
            
            if (self.currentPlacemark.subThoroughfare) {
                streetNumberString = [NSString stringWithFormat:@"%@ ",self.currentPlacemark.subThoroughfare];
            } else {
                streetNumberString = @"";
            }
            
            //Check to see if street
            if (self.currentPlacemark.thoroughfare) {
                streetString = [NSString stringWithFormat:@"%@, ", self.currentPlacemark.thoroughfare];
            } else {
                streetString = @"";
            }

            
            self.locationString = [NSString stringWithFormat:@"%@%@%@, %@  %@", streetNumberString, streetString, self.currentPlacemark.locality, self.currentPlacemark.administrativeArea, self.currentPlacemark.postalCode];
                
           
            //add the labels to the Locate Me Now view
            [self.activityIndicatorView stopAnimating];
            self.locationLabel.text = self.locationString;
            self.dateLabel.text = dateAndPartOfDayString;
                
            //finish the label on the View Screen by adding the part of day
            self.locateSaveButton.hidden = NO;
            self.locateChangeButton.hidden = NO;
            self.pleaseWaitLabel.hidden = YES;
        } else {
            NSLog(@"Error getting placemarks %@", placemarks);
        }
    
        // 6. set the stateUS property
        self.currentStateUS = self.entryState;
    }];
}



- (IBAction)saveButtonPressed:(id)sender {
    
    //PART ONE: If the User selects SAVE, check to see if there is a duplicate entry
    // FUTURE - if you have an auto entry, do you let user change?
    
    TemporaryEntry *testThisEntry = [CheckEntryController checkEntryWithTimestamp:self.currentTimestamp
                                                                location:self.currentLocation
                                                               placemark:self.currentPlacemark
                                                               partOfDay:self.currentPartOfDay
                                                              manualFlag:self.currentManualFlag
                                                                 stateUS:self.currentStateUS];
   
    
    
    
    // if it is not unique, there will be another entry returned above as testThisEntry
    // if you have two of the same entries, you have these cases:
    //      a) user wants to use entry they entered
    //      b) user wants to keep old entry
    
    if (testThisEntry != nil) {
        
        NSLog(@"testThisEntry in LocateMeNow is NOT nil");
        
        
        //FIRST ask the user what they want to do
        //start by getting the date from the alternate entry
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM d, y"];
        NSString *dateString = [dateFormatter stringFromDate:testThisEntry.timestamp];
        NSString *manualString = @"";
        if ([testThisEntry.manualFlag isEqualToNumber: [NSNumber numberWithBool:YES]]) {
            manualString = @"Manual";
        } else {
            manualString = @"Auto";
        }
        
        
        //NEXT create the full string
        NSString *alternateString = [NSString stringWithFormat:@"Conflicting Entry:\n%@, %@, %@\n%@ %@ %@", testThisEntry.placemark.locality, testThisEntry.placemark.administrativeArea, testThisEntry.placemark.country, dateString, testThisEntry.partOfDay, manualString];
        
        
        //THEN ask which entry to use
        UIAlertController* errorAlert = [UIAlertController alertControllerWithTitle:@"LocationAlert"
                                                                            message:alternateString
                                                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //USER picks using the entry he just entered
        [errorAlert addAction:[UIAlertAction actionWithTitle:@"Use Just Entered Location" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //remove the old one Entry from the Shared Model
            NSLog(@"User is saving entry he just entered in LocateMeNow");
            
            
            //save to the shared instance
            [[LocationEntryController sharedInstance] createEntryWithTimestamp:
             self.currentTimestamp
            location:self.currentLocation
            placemark:self.currentPlacemark
            partOfDay:self.currentPartOfDay
            manualFlag:self.currentManualFlag
             stateUS:self.currentStateUS];
            
            //remove the old entry from the shared instance
            //create an entry from the model to remove
            [[LocationEntryController sharedInstance] removeEntryWithTimestamp:testThisEntry.timestamp
                                                                      location:testThisEntry.location
                                                                     placemark:testThisEntry.placemark
                                                                     partOfDay:testThisEntry.partOfDay
                                                                    manualFlag:testThisEntry.manualFlag
                                                                       stateUS:testThisEntry.stateUS];
            
        }]];
        
        //USER picks keeping the old entry
        // You don't have to do anything
        [errorAlert addAction:[UIAlertAction actionWithTitle:@"Use Stored Location" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"User is keeping the old location in LocateMeNow");
        }]];
        
        [self presentViewController:errorAlert animated:YES completion:nil];
        
        //If there is no previous entry, save what the user entered
    } else {
        
        
        //create some fake data to test
        self.currentTimestamp = [NSDate dateWithTimeIntervalSinceNow:(0.0)];
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:40.6821 longitude:-111.4713];
        self.currentLocation = newLocation;
        
        
        //save to the shared instance
        [[LocationEntryController sharedInstance] createEntryWithTimestamp:self.currentTimestamp
                                                                  location:self.currentLocation
                                                                 placemark:self.currentPlacemark
                                                                    partOfDay:self.currentPartOfDay
                                                                manualFlag:self.currentManualFlag
                                                                   stateUS:self.currentStateUS];
        NSLog(@"No matching entry. Store user's in LocateMeNow");
        
    }
    
}



#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // If the User selects CHANGE, go to the next View Controller
    
    // Get the new view controller using [segue destinationViewController].
    if ([segue.identifier isEqualToString:@"goToAddManualSegue"]) {
        AddManualDetailViewController *viewController = segue.destinationViewController;
        

        //create a temporary entry to send to the next View Controller
        TemporaryEntry *tmpEntry = [[TemporaryEntry alloc] init];
        tmpEntry.location = self.currentLocation;
        tmpEntry.placemark = self.currentPlacemark;
        tmpEntry.timestamp = self.currentTimestamp;
        tmpEntry.partOfDay = self.currentPartOfDay;
        tmpEntry.manualFlag = self.currentManualFlag;
        tmpEntry.stateUS = self.currentStateUS;

        
        
      //pass the object to the new view controller
            //pass in the City, State, and Country so don't take time to geocode it when the next view controller is displaying
        viewController.tmpEntry = tmpEntry;
        viewController.entryCity = self.entryCity;
        viewController.entryState = self.entryState;
        viewController.entryCountry = self.entryCountry;
    }
}
@end
