//
//  FestivalDetailBaseViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 09/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "ConcertDetailBaseViewController.h"
#import "OverlayViewController.h"
#import "OverlayTransitionManager.h"
#import "TicketShopDetailViewController.h"

@interface ConcertDetailBaseViewController () <OverlayViewControllerDelegate>
@property (nonatomic, strong) OverlayTransitionManager *overlayTransitionManager;
@property (nonatomic, strong) OverlayViewController *overlayViewController;
@end

@implementation ConcertDetailBaseViewController

- (IBAction)shareButtonPressed:(id)sender
{
    if (!self.concertToDisplay.name) {
        return;
    }

    [TRACKER userTapsLadeFreundeEin];

    NSString *stringToShare = [NSString stringWithFormat:@"Hab ein cooles Konzerte gefunden: %@. Die app findest Du ubrigens unter www.soundlove.io", self.concertToDisplay.name];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[stringToShare]
                                                                                         applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                                     UIActivityTypePrint,
                                                     UIActivityTypeCopyToPasteboard,
                                                     UIActivityTypeAssignToContact,
                                                     UIActivityTypePostToVimeo,
                                                     UIActivityTypePostToTencentWeibo,
                                                     UIActivityTypePostToFlickr,
                                                     UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

- (IBAction)ticketShopButtonPressed:(id)sender
{
    [TRACKER userTapsToTicketShopButton];
    [self showToTicketShopPopup];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showTicketShop"])
    {
        TicketShopDetailViewController *ticketShopViewController = segue.destinationViewController;
        ticketShopViewController.concertToDisplay = self.concertToDisplay;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"showTicketShop"]) {
        return NO;
    }
    return YES;
}

#pragma mark - popup handling
- (void)showToTicketShopPopup
{
    self.overlayTransitionManager = [[OverlayTransitionManager alloc] init];
    self.overlayViewController = [self.overlayTransitionManager presentOverlayViewWithType:OverlayTypeRSVP onViewController:self];
    self.overlayViewController.delegate = self;
}

- (void)overlayViewControllerConfirmButtonPressed
{
    [self performSegueWithIdentifier:@"showTicketShop" sender:nil];
}

- (void)refreshView
{
    // implemented in subclasses
}

@end
