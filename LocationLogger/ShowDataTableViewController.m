//
//  ShowDataTableViewController.m
//  LocationLogger
//
//  Created by Erin Krentz on 10/29/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import "ShowDataTableViewController.h"
#import "LocationEntryController.h"
#import "listByDayCustomCellTableViewCell.h"

@interface ShowDataTableViewController ()

@end

@implementation ShowDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;

    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LocationEntryController sharedInstance].entries.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Entry *entry = [LocationEntryController sharedInstance].entries[indexPath.row];
    
    listByDayCustomCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"listByDayCell"];
    
    //Get the date to display
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d, y"];
    
    NSString *dateString = [dateFormatter stringFromDate:entry.timestamp];
    NSString *partOfDayString = entry.partOfDay;
    NSString *topString = [NSString stringWithFormat:@"%@   %@", dateString, partOfDayString];
    
    cell.topStringLabel.text = topString;
    
    // Get the city and state
    NSString *cityString = [NSString stringWithFormat:@"%@", entry.placemark.locality];
    NSString *stateString = [NSString stringWithFormat:@"%@", entry.placemark.administrativeArea];
    NSString *lowerString = [NSString stringWithFormat:@"%@, %@", cityString, stateString];
    cell.lowerStringLabel.text = lowerString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //remove the row from the Entry array in the model
    Entry *entry = [LocationEntryController sharedInstance].entries[indexPath.row];
    [[LocationEntryController sharedInstance] removeEntry:entry];
    
    //reload the table data
    [tableView reloadData];
    
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
