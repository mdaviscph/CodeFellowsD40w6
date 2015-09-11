//
//  HotelListViewController.m
//  HotelReservations
//
//  Created by mike davis on 9/7/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "HotelListViewController.h"
#import "UIViewExtension.h"
#import "HotelTableViewCell.h"
#import "UIColorExtension.h"
#import "Hotel.h"
#import "Room.h"
#import "AppDelegate.h"
#import "CoreDataStack.h"

@interface HotelListViewController () <UITableViewDataSource>

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation HotelListViewController

#pragma mark - Private Property Getters, Setters

- (UIView *)headerView {
  if (!_headerView) {
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor almond];
  }
  return _headerView;
}

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStyleGrouped];
    _tableView.estimatedRowHeight = 44;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = [UIColor vanDykeBrown];
  }
  return _tableView;
}

#pragma mark - Life Cycle Methods

- (void)loadView {
  NSLog(@"loading list view for Hotels");
  
  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor rawSienna];
  
  [self.headerView addToSuperViewWithStandardConstraints: rootView withFixedHeight: 200];
  [self.tableView addToSuperViewWithStandardConstraints: rootView withStandardVerticalTopConstraintTo: self.headerView];
  
  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView.dataSource = self;
  [self.tableView registerClass: [HotelTableViewCell class] forCellReuseIdentifier: @"HotelCell"];

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

  cell.hotel = [CoreDataStack sharedInstance].savedHotels[indexPath.row];
  return cell;
}

@end
