//
//  ViewController.m
//  MobileMapper
//
//  Created by Kyle Magnesen on 1/20/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;
@property MKPointAnnotation *mobileMakersAnnotation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mobileMakersAnnotation = [[MKPointAnnotation alloc] init];
    self.mobileMakersAnnotation.title = @"Mobile Makers";
    self.mobileMakersAnnotation.subtitle = @"IOS BootCamp";
    self.mobileMakersAnnotation.coordinate = CLLocationCoordinate2DMake(41.89373984, -87.63532979);
    [self.mapView addAnnotation:self.mobileMakersAnnotation];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:@"8265 Steepleside Drive, Burr Ridge, IL 60527" completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *place in placemarks) {
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = @"Home";
            annotation.subtitle = @"Where the heart is";
            annotation.coordinate = place.location.coordinate;
            [self.mapView addAnnotation:annotation];
        }
    }];

    CLGeocoder *geocoder2 = [[CLGeocoder alloc] init];
    [geocoder2 geocodeAddressString:@"4923 Woolworth Ave, Omaha, NE 68164" completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *place in placemarks) {
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = @"Home-aha";
            annotation.subtitle = @"Where the heart is not";
            annotation.coordinate = place.location.coordinate;
            [self.mapView addAnnotation:annotation];
        }
    }];

    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView.showsUserLocation = YES;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    if (annotation == mapView.userLocation) {
        return nil;
    }

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];

    pin.canShowCallout = YES;
    if (annotation == self.mobileMakersAnnotation) {
        pin.image = [UIImage imageNamed:@"don_bora"];
    }
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    CLLocationCoordinate2D centerCoordinate = view.annotation.coordinate;

    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;

    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = span;

    [self.mapView setRegion:region animated:YES];
}

@end
