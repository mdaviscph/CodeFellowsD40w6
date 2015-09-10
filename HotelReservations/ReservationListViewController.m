//
//  ReservationListViewController.m
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "ReservationListViewController.h"
#import "BaseTableView.h"
#import "Reservation.h"
#import "AppDelegate.h"
#import "CoreDataStack.h"

@interface ReservationListViewController () <UITableViewDataSource>

@property (strong, nonatomic) BaseTableView *tableView;

@end

@implementation ReservationListViewController

#pragma mark - Private Property Getters, Setters

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[BaseTableView alloc] init];
  }
  return _tableView;
}

#pragma mark - Life Cycle Methods

- (void)loadView {
  NSLog(@"loading list view for Reservations");
  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor whiteColor];

  [self.tableView addToSuperViewWithStandardConstraints: rootView];
  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.dataSource = self;
  [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"ReservationCell"];

  [[CoreDataStack sharedInstance] fetchRooms];
  [self updateUI];
}

#pragma mark - Helper Methods

-(void) updateUI {
  [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
  
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [CoreDataStack sharedInstance].savedReservations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"ReservationCell" forIndexPath: indexPath];
  Reservation *reservation = [CoreDataStack sharedInstance].savedReservations[indexPath.row];
  cell.textLabel.text = reservation.arrival.description;
  
  return cell;
}
  
@end
