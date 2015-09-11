//
//  RoomListViewController.m
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "RoomListViewController.h"
#import "RoomTableViewCell.h"
#import "UIVIewExtension.h"
#import "UIColorExtension.h"
#import "Room.h"
#import "AppDelegate.h"
#import "CoreDataStack.h"

@interface RoomListViewController () <UITableViewDataSource>

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation RoomListViewController

#pragma mark - Private Property Getters, Setters

- (UIView *)headerView {
  if (!_headerView) {
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor peach];
  }
  return _headerView;
}

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStyleGrouped];
    _tableView.estimatedRowHeight = 44;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = [UIColor darkVenetianRed];
  }
  return _tableView;
}

#pragma mark - Life Cycle Methods

- (void)loadView {
  NSLog(@"loading list view for Rooms");
  
  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor venetianRed];
  
  [self.headerView addToSuperViewWithStandardConstraints: rootView withFixedHeight: 180];
  [self.tableView addToSuperViewWithStandardConstraints: rootView withStandardVerticalTopConstraintTo: self.headerView];
  
  self.view = rootView;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.dataSource = self;
  [self.tableView registerClass: [RoomTableViewCell class] forCellReuseIdentifier: @"RoomCell"];
  
  [[CoreDataStack sharedInstance] fetchRoomsAscendingOnKey: @"number" whereKey: @"type" isEqualTo: @2];
  [self updateUI];
}

#pragma mark - Helper Methods

-(void) updateUI {
  [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [CoreDataStack sharedInstance].savedRooms.count;
}

- (RoomTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  RoomTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"RoomCell" forIndexPath: indexPath];

  cell.room = [CoreDataStack sharedInstance].savedRooms[indexPath.row];
  return cell;
}

@end
