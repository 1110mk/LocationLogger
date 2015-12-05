//
//  AddManualDetailViewController.m
//  LocationLogger
//
//  Created by Erin Krentz on 10/29/15.
//  Copyright © 2015 EMK. All rights reserved.
//
//  This View Controller allows the user:
//      1. to enter their location manually by
//          typing in city, state, and country,
//          setting the date picker, and
//          setting the part of the day.
//
//      2. if there is a duplicate manual entry,
//          the user can select which entry to keep



#import "AddManualDetailViewController.h"
#import "LocationEntryController.h"
#import "LocateMeNowDetailViewController.h"
#import "CheckEntryController.h"
#import "TemporaryEntry.h"
#import "SettingsViewController.h"



@interface AddManualDetailViewController () <UITextFieldDelegate>


// View fields
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;

@property (weak, nonatomic) IBOutlet UIDatePicker *locationDatePicker;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UIImageView *savedImageView;

@property (strong, nonatomic) NSString *localYear;


// User enters location by city and state
// which needs to be converted to coordinates for Model Entry
// Geocoder does a forward address decoding to do this
@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation AddManualDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Get the year from the settings
    self.localYear =[[NSUserDefaults standardUserDefaults] objectForKey:@"yearKey"];
    
    
    
    // The LocateMeNowDetailViewController is going to send data in so the fields can be set right away
    
    //Use the text fields to get the city, state, and country
    self.savedImageView.hidden = YES;
    self.countryTextField.text = self.entryCountry;
    self.stateTextField.text = self.entryState;
    self.cityTextField.text = self.entryCity;
    
    //Set the segmented control. The user can change if they want.
    //to make none highlighted set to -1
    if ([self.tmpEntry.partOfDay isEqualToString:@"AM"]) {
        self.segmentedControl.selectedSegmentIndex = 0;
    } else if ([self.tmpEntry.partOfDay isEqualToString:@"MID"]) {
        self.segmentedControl.selectedSegmentIndex = 1;
    } else if ([self.tmpEntry.partOfDay isEqualToString:@"PM"]) {
        self.segmentedControl.selectedSegmentIndex = 2;
    }
    
    // Do NOT allow the user to set a location in the future
    //The minimum date is based on the year selected in the settings
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:[self.localYear intValue]];
    [components setMonth:1];
    [components setDay:1];
   
    NSDate *minimumDate =  [calendar dateFromComponents:components];
    
    NSDate *currentDate = [NSDate date];
    
    [self.locationDatePicker setMinimumDate:minimumDate];
    [self.locationDatePicker setMaximumDate:currentDate];
    
    //set the date picker
    [self.locationDatePicker  setDate:self.tmpEntry.timestamp];
    
    //all the fields should be set on the view controller from the LocateMeNow view
    
    //reset all the addManual fields so those are only set when the user changes
    self.addManualStateUS = nil;
    self.addManualLocation = nil;
    self.addManualPlacemark = nil;
    self.addManualTimestamp = nil;
    self.addManualManualFlag = nil;
    self.addManualPartOfDay = nil;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //If the user enters a city, it automatically goes to the state
    //After entering state, the keyboard disappears
    if (textField == self.cityTextField) {
        [self.stateTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

- (IBAction)datePickerUpdated:(id)sender {
    
    //If the user changes the picker date, change the date
    NSDate *pickerDate = [self.locationDatePicker date];
    self.addManualTimestamp = pickerDate;
}

- (IBAction)segmentedControlChanged:(id)sender {
    
    // update the part of day property based on user selection
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.addManualPartOfDay = @"AM";
            break;
        case 1:
            self.addManualPartOfDay = @"MID";
            break;
        case 2:
            self.addManualPartOfDay = @"PM";
            break;
        default:
            break;
    }
}


- (IBAction)saveButtonPressed:(id)sender {
    
    //Two things happen in this method:
    //  1. NEED to set all the parts of the user's location and time
    //  2. NEED to check if duplicate entry & ask user
    //      which to keep
    
    // PART 1: get all six properties and store in correct format
    
    //1. set the timestamp
    //      if the user didn't use the datePicker to set a date, use the one sent in from LocateMeNow
    if (!self.addManualTimestamp) {
        self.addManualTimestamp = self.tmpEntry.timestamp;
    }// END if timestamp
    
    
    
    //2. set the part of day the user selects
    //      if the user didn't use the segmented control to set a part of day, use the one sent in from LocateMeNow
    
    if (!self.addManualPartOfDay) {
        if ([self.tmpEntry.partOfDay isEqualToString:@"AM"]) {
            self.addManualPartOfDay = @"AM";
            
        } else if ([self.tmpEntry.partOfDay isEqualToString:@"MID"]) {
            self.addManualPartOfDay = @"MID";
            
        } else if ([self.tmpEntry.partOfDay isEqualToString:@"PM"]) {
            self.addManualPartOfDay = @"PM";
            
        } else {
            NSLog(@"Error on addManualPartOfDay");
        } // END if tmpEntry.partOfDay
        
    } //END if addManualPartOfDay
    
    
    //3.& 4. set the location and placemark using the fields the user enters
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    } //if geocoder
    
    //Get the latest City, State, and Country that the user has entered or been sent from LocateMeNow
    self.entryCity = self.cityTextField.text;
    self.entryState = self.stateTextField.text;
    self.entryCountry = self.countryTextField.text;
    
    //Forward Geocode those into location coordinates
    
    NSString *addressString = [NSString stringWithFormat:@"%@, %@, %@", self.entryCity, self.entryState, self.entryCountry];
    [self.geocoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            
            //3. if more than one placemark returned, pick the first one
            self.addManualPlacemark = [placemarks objectAtIndex:0];
            
            //4. set the location
            CLLocation *location = self.addManualPlacemark.location;
            self.addManualLocation = location;
            
            //5. set the state
            //???Do you want to use the state from State text field or the placemark
            self.addManualStateUS = self.entryState;
            
            //6. set the manual Flag
            //This is always manual from the LocateMeNow or AddManual view controllers
            self.addManualManualFlag = [NSNumber numberWithBool:YES];
            
            
            
            // PART 2: CHECK if unique entry
            
            // FUTURE - if you have an auto entry, do you let user change?
            TemporaryEntry *testThisEntry = nil;
            
            testThisEntry = [CheckEntryController checkEntryWithTimestamp:self.addManualTimestamp
                                                                 location:self.addManualLocation
                                                                placemark:self.addManualPlacemark
                                                                partOfDay:self.addManualPartOfDay
                                                               manualFlag:self.addManualManualFlag
                                                                  stateUS:self.addManualStateUS];
            
            
            // if it is not unique, there will be another entry returned above as testThisEntry
            // if you have two of the same entries, you have these cases:
            //      a) user wants to use entry they entered
            //      b) user wants to keep old entry
            
            if (testThisEntry != nil) {
                
                NSLog(@"\ntestThisEntry is NOT nil in saved button pressed in AddManual\n");
                
                
                //FIRST ask the user what they want to do
                
                //start by getting the date from the alternate entry
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MMM d, y"];
                
                NSString *dateString = [dateFormatter stringFromDate:testThisEntry.timestamp];
                NSString *manualString = @"";
                
                if ([testThisEntry.manualFlag isEqualToNumber:[NSNumber numberWithBool:YES]]) {
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
                    NSLog(@"User is saving entry he just entered in AddManual %@", self.addManualPlacemark.locality);
                    
                    
                    //save to the shared instance
                    [[LocationEntryController sharedInstance] createEntryWithTimestamp:self.addManualTimestamp
                                                                              location:self.addManualLocation
                                                                             placemark:self.addManualPlacemark
                                                                             partOfDay:self.addManualPartOfDay
                                                                            manualFlag:self.addManualManualFlag
                                                                               stateUS:self.addManualStateUS];
                    
                    //remove the old entry
                    [[LocationEntryController sharedInstance] removeEntryWithTimestamp:testThisEntry.timestamp
                                                                              location:testThisEntry.location
                                                                             placemark:testThisEntry.placemark
                                                                             partOfDay:testThisEntry.partOfDay
                                                                            manualFlag:testThisEntry.manualFlag
                                                                               stateUS:testThisEntry.stateUS];
                    
                    //animate a frame to show that it saved
                    self.savedImageView.hidden = NO;
                    self.savedImageView.alpha = 1.0;

                    
                    [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        self.savedImageView.alpha = 0.0;
                        
                    } completion:^(BOOL finished) {
                        
                    }];

                    
                    
                }]];  // END alert action use new location
                
                //USER picks keeping the old entry
                // You don't have to do anything
                [errorAlert addAction:[UIAlertAction actionWithTitle:@"Use Stored Location" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"User is keeping the old location in AddManual %@", testThisEntry.placemark.locality);
                    
                }]]; // END alert action use old location
                
                [self presentViewController:errorAlert animated:YES completion:nil];
                
                
            } else { //Test this entry is nil
                NSLog(@"TestThisEntry is nil in AddManual");
                
                //There is no previous entry, save what the user entered.
                [[LocationEntryController sharedInstance] createEntryWithTimestamp:self.addManualTimestamp
                                                                          location:self.addManualLocation
                                                                         placemark:self.addManualPlacemark
                                                                         partOfDay:self.addManualPartOfDay
                                                                        manualFlag:self.addManualManualFlag
                                                                           stateUS:self.addManualStateUS];
                
                //animate a frame to show that it saved
                self.savedImageView.hidden = NO;
                self.savedImageView.alpha = 1.0;
                
                [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.savedImageView.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                }];

                
                NSLog(@"No matching entry. Store user's add manual location %@", self.addManualPlacemark.locality);
                
                
                
            }  //end Test This Entry is nil
            
        }
    }];  // END geocode address string
    
//    [self.navigationController popViewControllerAnimated:YES];
    
}  // end save button pressed



@end
