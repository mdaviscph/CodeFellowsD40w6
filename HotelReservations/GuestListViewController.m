//
//  GuestListViewController.m
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "GuestListViewController.h"
#import "TableViewCell.h"
#import "UIViewExtension.h"
#import "UIColorExtension.h"
#import "ViewUtility.h"
#import "AttributedString.h"
#import "Guest.h"
#import "Reservation.h"
#import "AppDelegate.h"
#import "CoreDataStack.h"

@interface GuestListViewController () <UITableViewDataSource>

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation GuestListViewController

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
  NSLog(@"loading list view for Guests");
  
  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor rawSienna];
  
  [self.headerView addToSuperViewWithConstraints: rootView withViewAbove: nil height: 192 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [self.tableView addToSuperViewWithConstraints: rootView withViewAbove: self.headerView height: 0 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];

  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.dataSource = self;
  [self.tableView registerClass: [TableViewCell class] forCellReuseIdentifier: @"TableCell"];
  
  [[CoreDataStack sharedInstance] fetchGuests];
  [self updateUI];
}

#pragma mark - Helper Methods

-(void) updateUI {
  [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [CoreDataStack sharedInstance].savedGuests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"GuestCell" forIndexPath: indexPath];

  //cell.textView.text = [CoreDataStack sharedInstance].savedGuests[indexPath.row];
  return cell;
}

@end
