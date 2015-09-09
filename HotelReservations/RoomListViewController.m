//
//  RoomListViewController.m
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "RoomListViewController.h"
#import "Room.h"
#import "AppDelegate.h"
#import "CoreDataStack.h"

@interface RoomListViewController () <UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation RoomListViewController

#pragma mark - Private Property Getters, Setters

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] init];
  }
  return _tableView;
}

#pragma mark - Life Cycle Methods

- (void)loadView {
  NSLog(@"loading list view for Rooms");
  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor whiteColor];
  [rootView addSubview: self.tableView];
  
  [self.tableView setTranslatesAutoresizingMaskIntoConstraints: NO];
  NSDictionary *viewsInfo = @{@"tableView" : self.tableView};
  NSArray *tableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:|[tableView]|" options: 0  metrics: nil views: viewsInfo];
  NSArray *tableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[tableView]|" options: 0  metrics: nil views: viewsInfo];
  [rootView addConstraints: tableViewVerticalConstraints];
  [rootView addConstraints: tableViewHorizontalConstraints];
  
  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.dataSource = self;
  [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"RoomCell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [CoreDataStack sharedInstance].savedRooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"RoomCell" forIndexPath: indexPath];
  Room *room = [CoreDataStack sharedInstance].savedRooms[indexPath.row];
  cell.textLabel.text = room.number;
  
  return cell;
}

@end