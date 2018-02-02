//
//  ViewController.m
//  locationproject
//
//  Created by Felix-ITS 004 on 02/11/17.
//  Copyright © 2017 sonal. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.locationmanager=[[CLLocationManager alloc]init];
    self.locationmanager.desiredAccuracy=kCLLocationAccuracyBest;//core location use K.// for constant
    self.locationmanager.delegate=self;
    [self.locationmanager requestWhenInUseAuthorization];
       [self.locationmanager startUpdatingLocation];
     // long press gesture for a pin on the curent locaiton
    
    UILongPressGestureRecognizer *longpin=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handlelonggesture:)]; // : is given because custom method is parameterized...
    
    longpin.minimumPressDuration=2;
    [self.mapkit addGestureRecognizer:longpin];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)startDetectingLocation// to change the location and to inititalize the location we have created this method and caled it upon the button to update the location ehenever to use..
{
    self.locationmanager=[[CLLocationManager alloc]init];
    self.locationmanager.desiredAccuracy=kCLLocationAccuracyBest;
    [self.locationmanager requestWhenInUseAuthorization];
    self.locationmanager.delegate=self;
    
    [self.locationmanager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentlocation=[locations lastObject];
    if(currentlocation!=nil)
    {
        [manager stopUpdatingLocation];
    }
    CGFloat lat,lon;
    lat=currentlocation.coordinate.latitude;
    lon=currentlocation.coordinate.longitude;
    
    NSLog(@"latitiude=%f and longitude=%f",lat,lon);
    
    CLLocationCoordinate2D currentCoordinate=currentlocation.coordinate;// it is a type thats why canyt use * while declaring the variable,to map the cooordinates of real time map and map view ppintes..to map the points with real time device...
    
    //used to map a point in  a real time ccordinating system...
    
    MKCoordinateSpan span=MKCoordinateSpanMake(1,1);// increases the rdius of latitude and longitude and gives the surrounding locations... if lower th sapn exact location willl come,...pass lat delta and lon delta..
    MKCoordinateRegion region=MKCoordinateRegionMake(currentCoordinate, span);// show on map view the current latitude and longitude..only using REGION using possible..
    [self.mapkit setRegion:region];
    /* f we want ot have any other map ..i.e.of any state rather then having whole world map ,then we need to pass the hard-coded lat and lon to the REGION function*/
    
    
    
    
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        MKAnnotationView *pinview=(MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"mypin"];
        if (!pinview) {
            pinview=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"mypin"];
            pinview.canShowCallout=YES;
            pinview.calloutOffset=CGPointMake(0, 32);
            pinview.backgroundColor=[UIColor blackColor];
        }
        return pinview;
    }
    else
    {
        return nil;
    }
}

- (IBAction)btnaction:(id)sender
{
    [self startDetectingLocation];
    
    
}
- (IBAction)changemap:(id)sender
{
    
    switch (self.changemaptype.selectedSegmentIndex) {
        case 0:
            self.mapkit.mapType=MKMapTypeStandard;
            break;
        case 1:
            self.mapkit.mapType=MKMapTypeSatellite;
            break;
        case 2:
            self.mapkit.mapType=MKMapTypeHybrid;
            break;
            
        default:
            break;
    }
}


-(void)handlelonggesture:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state==UIGestureRecognizerStateBegan) {
        CGPoint locationInView=[gesture locationInView:gesture.view];// give the gesture view....
        
        
        CLLocationCoordinate2D pressedCoordinate;
        
        
        pressedCoordinate=[self.mapkit convertPoint:locationInView toCoordinateFromView:gesture.view];//1...to convert the point in  real time....2..  take cgpoint in 2dcoordinate....
        
        MKPointAnnotation *annotationPoint=[[MKPointAnnotation alloc]init];
        
    
        annotationPoint.coordinate=pressedCoordinate;
        
        
        CLLocation *location=[[CLLocation alloc]initWithLatitude:annotationPoint.coordinate.latitude longitude:annotationPoint.coordinate.longitude];
        
        
        CLGeocoder *geocoder=[[CLGeocoder alloc]init]; // use to know more about the location.....
        
        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray< CLPlacemark *> * _Nullable placemarks,NSError * _Nullable error)
         {
             if (placemarks.count>0) {// placemerk is the knwon info about the lovcation
                 CLPlacemark *placemark=placemarks.lastObject;
                 NSString *title=[placemark.subThoroughfare stringByAppendingString:placemark.thoroughfare];// thorough fare area in AREA and sub-thouroughfare means subarea in Area
                 NSString *subtitle=placemark.locality;// particular main AREA..
                 
                 annotationPoint.title=title;
                 annotationPoint.subtitle=subtitle;
                 [self.mapkit addAnnotation:annotationPoint];
             }
         
         }];
        
    }
    
}
@end
