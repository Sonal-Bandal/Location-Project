//
//  ViewController.h
//  locationproject
//
//  Created by Felix-ITS 004 on 02/11/17.
//  Copyright © 2017 sonal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
@property CLLocationManager *locationmanager;

@property (strong, nonatomic) IBOutlet MKMapView *mapkit;

- (IBAction)btnaction:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *changemaptype;
- (IBAction)changemap:(id)sender;

@end

