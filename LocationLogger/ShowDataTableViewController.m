//
//  ShowDataTableViewController.m
//  LocationLogger
//
//  Created by Erin Krentz on 10/29/15.
//  Copyright © 2015 EMK. All rights reserved.
//
//  This TableView Controller does 3 things:
//  1) sorts the data based on the segmented control
//  2) displays the custom table view cells
//  3) allows the user to print the table and send pdf

#import "ShowDataTableViewController.h"

#import "listByDayCustomCellTableViewCell.h"
#import "ListByStateCustomCellTableViewCell.h"
#import "ListByPercentCustomCellTableViewCell.h"

#import "StateData.h"
#import "LocationEntryController.h"
#import "CheckEntryController.h"
#import "SearchEntriesController.h"


static NSString * const MyPDF = @"MyPDF";

@interface ShowDataTableViewController ()
{
CGSize *pageSize;
}

//This is the Entry Model Shared Instance array
@property (nonatomic, strong) NSArray *entriesArray;

//This is a mutable array of the Entry Model Shared Instance array
@property (nonatomic, strong) NSMutableArray *sortedEntries;

//This is the states array with abbreviation, count, and percentage
@property (nonatomic, strong) NSMutableArray *allTheStatesArray;

@property (weak, nonatomic) IBOutlet UILabel *segmentedLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedSortType;
@end

@implementation ShowDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    
    [self.segmentedSortType setSelectedSegmentIndex:0];
    
    
    // GET the Core Data stored entries to diplay
    // Use the segmented control to determine whether to sort by:
    //      date
    //      state alphabetically
    //      percent of time spent in state
    
    [self sortEntries];
    
}

- (void)sortEntries {
//    self.sortedEntries = [SearchEntriesController sortAllTheEntriesByDate:self.entriesArray];
    
    [[LocationEntryController sharedInstance] loadEntries];
    self.entriesArray = [LocationEntryController sharedInstance].entries;

//    self.segmentedSortType.selectedSegmentIndex = 0;
    if (self.segmentedSortType.selectedSegmentIndex == 0) {
        
        //SORT by date
        self.sortedEntries = [SearchEntriesController sortAllTheEntriesByDate:self.entriesArray];
        
    } else if (self.segmentedSortType.selectedSegmentIndex == 1) {
        
        //SORT by state
        self.sortedEntries = [SearchEntriesController sortAllTheEntriesByState:self.entriesArray];
        
    } else if (self.segmentedSortType.selectedSegmentIndex == 2)   {
        
        //SORT by percentage
        self.sortedEntries = [SearchEntriesController sortAllTheEntriesByPercent:self.entriesArray];
    }

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sortEntries];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// PART 2: Display the data on the view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    self.segmentedSortType.selectedSegmentIndex = 0;
    if (self.segmentedSortType.selectedSegmentIndex == 0 || self.segmentedSortType.selectedSegmentIndex == 1) {
        return self.sortedEntries.count;
    } else {
        return self.allTheStatesArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //There are going to be 3 sets table cells depending on the segmentedIndex
    //    self.segmentedSortType.selectedSegmentIndex = 0;

    if (self.segmentedSortType.selectedSegmentIndex == 0) {
        Entry *entry = self.sortedEntries[indexPath.row];

        //Get the custom tableview cell for displaying by date
        listByDayCustomCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"listByDayCell"];
        
        //You have 3 labels to display:
        //      topStringLabel,
        //      lowerStringLabel,
        //      and mLabel
    
        //Get the date to display for topStringLabel
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM d, y"];
    
        NSString *dateString = [dateFormatter stringFromDate:entry.timestamp];
        NSString *partOfDayString = entry.partOfDay;
        NSString *topString = [NSString stringWithFormat:@"%@   %@", dateString, partOfDayString];
        
        //DISPLAY topStringLabel
        cell.topStringLabel.text = topString;
    
        // Get the city and state for the lowerStringLabel
        NSString *cityString = [NSString stringWithFormat:@"%@", entry.placemark.locality];
        NSString *stateString = [NSString stringWithFormat:@"%@", entry.placemark.administrativeArea];
        NSString *lowerString = [NSString stringWithFormat:@"%@, %@", cityString, stateString];
        
        //DISPLAY lowerStringLabel
        cell.lowerStringLabel.text = lowerString;
        
        //get the manual flag for the mLabel
        NSString *manualString = [[NSString alloc] init];
        if ([entry.manualFlag isEqualToNumber:[NSNumber numberWithBool:NO]]) {
            manualString = [NSString stringWithFormat:@"A"];
            
        } else {
            manualString = [NSString stringWithFormat:@"M"];
        }
        
        //DISPLAY mLabel
        cell.mLabel.text = manualString;
        return cell;
        
    } else if (self.segmentedSortType.selectedSegmentIndex == 1) {
        Entry *entry = self.sortedEntries[indexPath.row];

        //Get the custom tableview cell for displaying alphabetically by State
        ListByStateCustomCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"listByStateCell"];
        
//        You have 3 strings to display:
//             countryLabel
//             stateLabel
//             dateLabel
        
//        DISPLAY countryLabel
        cell.countryLabel.text = [NSString stringWithFormat:@"%@", entry.placemark.country];
        
        //DISPLAY stateLabel
        cell.stateLabel.text = [NSString stringWithFormat:@"%@", entry.placemark.administrativeArea];
        
        //DISPLAY dateLabel
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM d, y"];
        
        NSString *dateString = [dateFormatter stringFromDate:entry.timestamp];
        NSString *partOfDayString = entry.partOfDay;
        NSString *topString = [NSString stringWithFormat:@"%@   %@", dateString, partOfDayString];
 
        cell.dateLabel.text = topString;
        return cell;

        
    } else if (self.segmentedSortType.selectedSegmentIndex == 2) {
        
        StateData *stateData = self.allTheStatesArray[indexPath.row];
        
        //Get the custom tableview cell for displaying by state with the most percentage
        ListByPercentCustomCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"listByPercentCell"];
        
        NSString *stateUSString = [NSString stringWithFormat:@"%@", stateData.stateAbbreviation];
        cell.stateUSLabel.text = stateUSString;
        
        
        NSString *percentString = [NSString stringWithFormat:@"%.02f", [stateData.statePercentage doubleValue]];
        cell.percentLabel.text = percentString;
        
        NSString *dayString = [NSString stringWithFormat:@"%@", stateData.stateCount];
        cell.dayLabel.text = dayString;
        
        return cell;

        
    } else {
        
        //entry category
        
        listByDayCustomCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listByDayCell"];
        cell.topStringLabel.text = @"Error";
        return cell;
    }
    
    
    
}


//Delete a row in the TableView
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    
        //remove the row from the Entry array in the model
        Entry *entry = [LocationEntryController sharedInstance].entries[indexPath.row];
        [[LocationEntryController sharedInstance] removeEntry:entry];
    }
    
    [self sortEntries];
    
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    [self.tableView reloadData];
    
}



#pragma mark - Sort the data based on the segmented control

//PART 1: Sort the Core Data

- (IBAction)segmentedSortTypeChanged:(id)sender {
   
        //Determine which way to sort the location entries
    if (self.segmentedSortType.selectedSegmentIndex == 0) {
        
        self.sortedEntries = [SearchEntriesController
                              sortAllTheEntriesByDate:self.entriesArray];
        
    } else if (self.segmentedSortType.selectedSegmentIndex == 1) {
        
        self.sortedEntries = [SearchEntriesController sortAllTheEntriesByState:self.entriesArray];
        
    } else if (self.segmentedSortType.selectedSegmentIndex == 2)   {
        
        self.allTheStatesArray = [SearchEntriesController sortAllTheEntriesByPercent:self.entriesArray];
    }
    [self.tableView reloadData];
    
}


#pragma mark - Email a pdf version of the table view

// PART 3: Get an image view of the Table View, convert to PDF, and send e-mail

//Get the image of the table view
-(UIImage *)imageToShare {
    CGSize newSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height);
    UIImage *image = [[UIImage alloc] init];
    
    //set up the graphics context
    UIGraphicsBeginImageContextWithOptions(newSize, TRUE, 0.0);
    
    //store the offset and frame to reset at end
    CGPoint tempContentOffset = self.tableView.contentOffset;
    CGRect tempFrame = self.tableView.frame;
    
    //get image of the screen
    self.tableView.contentOffset = CGPointZero;
    self.tableView.frame = CGRectMake(0, 0, newSize.width, newSize.height);
    [self.tableView drawViewHierarchyInRect:self.tableView.frame afterScreenUpdates:YES];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    //reset your variables
    self.tableView.contentOffset = tempContentOffset;
    self.tableView.frame = tempFrame;
    
    //release the graphics context
    UIGraphicsEndImageContext();
    return image;
}


//generate the PDF Data using the image view you create
- (NSData *)generatePDFData {
    
    //get your image of the table
    UIImage *tableViewImage = [self imageToShare];
    CGRect imageFrame = CGRectMake(0, 0, tableViewImage.size.width, tableViewImage.size.height);
    
    NSMutableData *pdfData = [NSMutableData data];
    
    //create the PDF Context
    UIGraphicsBeginPDFContextToData(pdfData, imageFrame, nil);
    
    UIGraphicsBeginPDFPage();
    
    [tableViewImage drawInRect:imageFrame];
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
    if (pdfData) {
        return pdfData;
    }
    return nil;
}

- (IBAction)printButtonPressed:(id)sender {
    //try to e-mail PDF
         // Email Subject
    NSString *emailTitle = @"Location Logger Data";
        // Email Content
    NSString *messageBody = @"Look at your Location PDF";
        // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"emk@krentzfolio.com"];
        
        
        MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
        mailComposeVC.mailComposeDelegate = self;
        [mailComposeVC setSubject:emailTitle];
        [mailComposeVC setMessageBody:messageBody isHTML:NO];
        [mailComposeVC setToRecipients:toRecipents];
        
        NSData *pdfData = [self generatePDFData];
        
        [mailComposeVC addAttachmentData:pdfData mimeType:@"application/pdf" fileName:MyPDF];
        
        // Present mail view controller on screen
        [self presentViewController:mailComposeVC animated:YES completion:NULL];
        
}
    
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
        switch (result) {
            case MFMailComposeResultCancelled:
                NSLog(@"Mail cancelled");
                break;
            case MFMailComposeResultSaved:
                NSLog(@"Mail saved");
                break;
            case MFMailComposeResultSent:
                NSLog(@"Mail sent");
                break;
            case MFMailComposeResultFailed:
                NSLog(@"Mail sent failure: %@", [error localizedDescription]);
                break;
            default:
                break;
        }
        
    [self dismissViewControllerAnimated:YES completion:NULL];
}
    
@end
