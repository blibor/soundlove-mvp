//
//  InfoViewController.m
//  Festivalama
//
//  Created by Sztanyi Szabolcs on 05/06/15.
//  Copyright (c) 2015 Sztanyi Szabolcs. All rights reserved.
//

#import "InfoViewController.h"
#import "BaseTableViewCell.h"
#import <StoreKit/StoreKit.h>
//#import "TrackingManager.h"
#import "GeneralSettings.h"
#import "CustomNavigationView.h"
#import "BaseTableViewCell.h"

@interface InfoViewController () <SKStoreProductViewControllerDelegate>
@property (nonatomic, strong) NSArray *cellTitlesArray;
@end

@implementation InfoViewController

- (NSArray*)cellTitlesArray
{
    if (!_cellTitlesArray) {
        _cellTitlesArray = @[@"Was wir machen", @"Teile die App", @"Bewerte die App", @"Unsere Festival App", @"Unsere Apps", @"Auf Jobsuche?"];
    }

    return _cellTitlesArray;
}

- (void)backButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellTitlesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseTableViewCell *cell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = self.cellTitlesArray[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosureIcon"]];
    cell.accessoryView = accessoryView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"openWhatWeDo" sender:nil];
            break;
        case 1:
            [self shareTheApp];
            break;
        case 2:
            [self rateTheApp];
            break;
        case 3:
            [self openFestivalamaApp];
            break;
        case 4:
            [self openOurApps];
            break;
        case 5:
            [self openJobSearch];
            break;
        default:
            break;
    }


    if (indexPath.row == 0) {
//        [[TrackingManager sharedManager] trackUserSelectsWasWirMachen];

    } else if (indexPath.row == 1) {
//        [[TrackingManager sharedManager] trackUserSelectsTeileDieApp];
        [self shareTheApp];
    } else {
//        [[TrackingManager sharedManager] trackUserSelectsBewerteDieApp];
        [self rateTheApp];
    }
}

- (void)shareTheApp
{
    NSString *stringToShare = @"";
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[stringToShare]
                                                                                         applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                                     UIActivityTypePrint,
                                                     UIActivityTypeCopyToPasteboard,
                                                     UIActivityTypeAssignToContact,
                                                     UIActivityTypePostToVimeo,
                                                     UIActivityTypePostToTencentWeibo,
                                                     UIActivityTypePostToFlickr,
                                                     UIActivityTypeSaveToCameraRoll,
                                                     UIActivityTypeAddToReadingList];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

- (void)rateTheApp
{
    [self presentAppStoreViewWithAppID:[GeneralSettings appStoreID]];
}

- (void)openFestivalamaApp
{
    [self presentAppStoreViewWithAppID:@"1013815740"];
}

- (void)openOurApps
{

}

- (void)openJobSearch
{

}

- (void)presentAppStoreViewWithAppID:(NSString*)appStoreID
{
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    [storeProductViewController setDelegate:self];

    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : appStoreID} completionBlock:^(BOOL result, NSError *error) {
        if (error) {
            NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);

        } else {
            // Present Store Product View Controller
            [self presentViewController:storeProductViewController animated:YES completion:nil];
        }
    }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - view methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.customNavigationView setTitle:@"Info"];
    [self.customNavigationView setButtonTarget:self selector:@selector(backButtonPressed)];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

#ifdef DEBUG
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];

    NSString *version = infoDictionary[@"CFBundleShortVersionString"];
    NSString *build = infoDictionary[(NSString*)kCFBundleVersionKey];

    self.versionNumberLabel.text = [NSString stringWithFormat:@"Version: %@, Build: %@", version, build];
#endif
}

@end
