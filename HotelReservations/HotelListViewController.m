//
//  HotelListViewController.m
//  HotelReservations
//
//  Created by mike davis on 9/7/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "HotelListViewController.h"
#import "BaseTableView.h"
#import "HotelTableViewCell.h"
#import "Hotel.h"
#import "Room.h"
#import "AppDelegate.h"
#import "CoreDataStack.h"

@interface HotelListViewController () <UITableViewDataSource>

@property (strong, nonatomic) BaseTableView *tableView;

@end

@implementation HotelListViewController

#pragma mark - Private Property Getters, Setters

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[BaseTableView alloc] init];
  }
  return _tableView;
}

#pragma mark - Life Cycle Methods

- (void)loadView {
  NSLog(@"loading list view for Hotels");
  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor whiteColor];

  [self.tableView addToSuperViewWithStandardConstraints: rootView];
  
  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView.dataSource = self;
  [self.tableView registerClass: [HotelTableViewCell class] forCellReuseIdentifier: @"HotelCell"];
  self.tableView.estimatedRowHeight = 44;
  self.tableView.rowHeight = 100; // UITableViewAutomaticDimension;

  [[CoreDataStack sharedInstance] fetchHotels];
  [self updateUI];
}

#pragma mark - Helper Methods 

-(void) updateUI {
  [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [CoreDataStack sharedInstance].savedHotels.count;
}

- (HotelTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  HotelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"HotelCell" forIndexPath: indexPath];
  Hotel *hotel = [CoreDataStack sharedInstance].savedHotels[indexPath.row];
  cell.hotel = hotel;
  return cell;
}

@end
