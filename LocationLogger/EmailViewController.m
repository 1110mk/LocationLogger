//
//  EmailViewController.m
//  LocationLogger
//
//  Created by Erin Krentz on 11/7/15.
//  Copyright © 2015 EMK. All rights reserved.
//

#import "EmailViewController.h"

static NSString * const MyPDF = @"MyPDF";

@interface EmailViewController ()

@end

@implementation EmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//create the pdf when the button is pressed
//- (NSData *)generatePDFData {
//    
//    //get your image of the table
//    UIImage *tableViewImage = [self imageToShare];
//    CGRect imageFrame = CGRectMake(0, 0, tableViewImage.size.width, tableViewImage.size.height);
//    
//    NSMutableData *pdfData = [NSMutableData data];
//    
//    //create the PDF Context
//    UIGraphicsBeginPDFContextToData(pdfData, imageFrame, nil);
//    
//    UIGraphicsBeginPDFPage();
//    
//    [tableViewImage drawInRect:imageFrame];
//    
//    // Close the PDF context and write the contents out.
//    UIGraphicsEndPDFContext();
//    
//    if (pdfData) {
//        return pdfData;
//    }
//    return nil;
//}


- (IBAction)emailButtonPushed:(id)sender {
    
    // Email Subject
    NSString *emailTitle = @"Test Email and PDF";
    // Email Content
    NSString *messageBody = @"Testing this sample e-mail!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"emk@krentzfolio.com"];
    
    MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
    mailComposeVC.mailComposeDelegate = self;
    [mailComposeVC setSubject:emailTitle];
    [mailComposeVC setMessageBody:messageBody isHTML:NO];
    [mailComposeVC setToRecipients:toRecipents];
    
//    NSData *pdfData = [self generatePDFData];
//    
//    [mailComposeVC addAttachmentData:pdfData mimeType:@"application/pdf" fileName:MyPDF];
    
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
