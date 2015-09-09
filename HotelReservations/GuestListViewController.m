//
//  GuestListViewController.m
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "GuestListViewController.h"
#import "Guest.h"
#import "AppDelegate.h"
#import "CoreDataStack.h"

@interface GuestListViewController () <UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation GuestListViewController

#pragma mark - Private Property Getters, Setters

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] init];
  }
  return _tableView;
}

#pragma mark - Life Cycle Methods

- (void)loadView {
  NSLog(@"loading list view for Guests");
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
  [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"GuestCell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [CoreDataStack sharedInstance].savedGuests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"GuestCell" forIndexPath: indexPath];
  Guest *guest = [CoreDataStack sharedInstance].savedGuests[indexPath.row];
  cell.textLabel.text = guest.lastName;
  
  return cell;
}

@end
