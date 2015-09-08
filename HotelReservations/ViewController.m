//
//  ViewController.m
//  HotelReservations
//
//  Created by mike davis on 9/7/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "ViewController.h"
#import "Hotel.h"
#import "HotelJSONParse.h"
#import "Room.h"
#import "RoomJSONParse.h"
#import "JSONFileImport.h"
#import "AppDelegate.h"
#import "AlertPopover.h"

@interface ViewController () <UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *savedHotels;
@property (strong, nonatomic) NSManagedObjectContext* moContext;

@end

@implementation ViewController

#pragma mark - Private Property Getters, Setters

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] init];
  }
  return _tableView;
}

- (NSManagedObjectContext *)moContext {
  if (!_moContext) {
    _moContext = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
  }
  return _moContext;
}

#pragma mark - Life Cycle Methods

- (void)loadView {
  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor whiteColor];
  
  [self.tableView setTranslatesAutoresizingMaskIntoConstraints: NO];
  self.tableView.dataSource = self;
  [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"HotelCell"];
  [rootView addSubview: self.tableView];
  
  NSDictionary *viewsInfo = @{@"tableView" : self.tableView};
  NSArray *tableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|-[tableView]-|" options: 0  metrics: nil views: viewsInfo];
  NSArray *tableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-[tableView]-|" options: 0  metrics: nil views: viewsInfo];
  [rootView addConstraints: tableViewVerticalConstraints];
  [rootView addConstraints: tableViewHorizontalConstraints];
  
  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  NSError *serializeError;
  NSData *jsonData = [JSONFileImport loadJSONFileInBundle: @"hotels" withFileType: @"json"];
  NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData: jsonData options: 0 error: &serializeError];
  if (serializeError) {
    [AlertPopover alert: @"JSON Serialization Error using hotels.json" withNSError: serializeError controller: self completion: nil];
  }
  
  NSArray *arrayOfHotels = rootDictionary[@"Hotels"];
  NSMutableArray *importedHotels = [[NSMutableArray alloc] init];
  for (NSDictionary *hotelDictionary in arrayOfHotels) {
    [importedHotels addObject: [Hotel createUsingJSON: hotelDictionary]];
  }
  
  // TODO: handle error
  NSError *saveError;
  BOOL saveOk = [self.moContext save: &saveError];
  if (saveError || !saveOk) {
    [AlertPopover alert: @"Core Data Save Error" withNSError: saveError controller: self completion: nil];
  }
  
  [self fetchHotels];
}

#pragma mark - Helper Methods

- (void) fetchHotels {
  
  NSError *fetchError;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: @"Hotel"];
  self.savedHotels = [self.moContext executeFetchRequest: request error: &fetchError];
  if (fetchError) {
    [AlertPopover alert: @"Core Data Fetch Error" withNSError: fetchError controller: self completion: nil];
  } else {
    [self.tableView reloadData];
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.savedHotels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"HotelCell" forIndexPath: indexPath];
  Hotel *hotel = self.savedHotels[indexPath.row];
  cell.textLabel.text = hotel.name;
  cell.detailTextLabel.text = hotel.city;
  return cell;
}

@end
