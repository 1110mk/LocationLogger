//
//  LocateMeNowDetailViewController.m
//  LocationLogger
//
//  Created by Erin Krentz on 10/29/15.
//  Copyright © 2015 EMK. All rights reserved.
//
//  This detail view controller gets the user location, sets all the properties on that Entry location
//  calls LocationEntryController to update that location in Core Data
//  and forwards the Entry to the AddManualDetailViewController if the user selects to go there

#import "LocateMeNowDetailViewController.h"
#import "LocationEntryController.h"
#import "Entry.h"
#import "LocalEntry.h"
#import "AddManualDetailViewController.h"


@interface LocateMeNowDetailViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;


@property (weak, nonatomic) IBOutlet UIButton *locateSaveButton;
@property (weak, nonatomic) IBOutlet UIButton *locateChangeButton;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) NSString *locationString;

@end

@implementation LocateMeNowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.localEntry = [LocalEntry new];
}

- (void) viewDidAppear:(BOOL)animated {
    self.locateSaveButton.hidden = YES;
    self.locateChangeButton.hidden = YES;
    
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
    
    //Get the location from which all the properties are derived
    CLLocation *currentLocation = [locations lastObject];
    self.localEntry.location = currentLocation;
    self.localEntry.timestamp = currentLocation.timestamp;
    
    
    //Get the latitude and longitude
    if (currentLocation != nil) {
        NSLog(@"CLLocation: %@",currentLocation);
        
    }
    
    
    //Get the month and day
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, y"];
    
    //Create the date string that will be added to the label in the view
    NSString *dateString = [dateFormatter stringFromDate:currentLocation.timestamp];
    

    
    //Get the part of day label
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSCalendarUnit units = NSCalendarUnitHour | NSCalendarUnitDay| NSCalendarUnitMonth| NSCalendarUnitYear;
    
    NSDateComponents *components = [calendar components:units fromDate:currentLocation.timestamp];
    
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
    
    
    //set the Entry property of partOfDay
    self.localEntry.partOfDay = partOfDayString;
    
    //set the Entry property of manualFlag
    self.localEntry.manualFlag = [NSNumber numberWithBool:YES];
    
    //Get the city and state
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [self.activityIndicatorView startAnimating];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error is %@", error.description);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            
            
            self.localEntry.placemark = placemark;
            [self.activityIndicatorView stopAnimating];
            self.entryCity = placemark.locality;
            self.entryState = placemark.administrativeArea;
            self.entryCountry = placemark.country;
            
            
            //set the label on the view with the location
            if ((placemark.subThoroughfare) || (placemark.thoroughfare)) {
                self.locationString = [NSString stringWithFormat:@"%@ %@, %@, %@  %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode];
                
            } else if ((placemark.subThoroughfare) || (!placemark.thoroughfare)) {
            
                self.locationString = [NSString stringWithFormat:@"%@, %@, %@  %@", placemark.subThoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode];
                
            } else if ((placemark.thoroughfare) || (!placemark.subThoroughfare)) {
                self.locationString = [NSString stringWithFormat:@"%@, %@, %@  %@", placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode];
                
                
            } else if ((!placemark.subThoroughfare) || (!placemark.subThoroughfare)) {
                self.locationString = [NSString stringWithFormat:@"%@, %@  %@", placemark.locality, placemark.administrativeArea, placemark.postalCode];
            }
            
            //add the labels to the Locate Me Now view
            self.locationLabel.text = self.locationString;
            self.dateLabel.text = dateAndPartOfDayString;
            //finish the label on the View Screen by adding the part of day
            self.locateSaveButton.hidden = NO;
            self.locateChangeButton.hidden = NO;
        }
    }];
}


//Save the Entry on the View Screen
- (IBAction)saveButtonPressed:(id)sender {
    
    [[LocationEntryController sharedInstance] createEntryWithTimestamp:self.localEntry.timestamp
        location:self.localEntry.location
        placemark:self.localEntry.placemark
        partOfDay:self.localEntry.partOfDay
        manualFlag:self.localEntry.manualFlag];
}



#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if ([segue.identifier isEqualToString:@"goToAddManualSegue"]) {
        AddManualDetailViewController *viewController = segue.destinationViewController;
        
        
      //pass the object to the new view controller
        viewController.localEntry = self.localEntry;
        viewController.entryCity = self.entryCity;
        viewController.entryState = self.entryState;
        viewController.entryCountry = self.entryCountry;
    }
}
@end
