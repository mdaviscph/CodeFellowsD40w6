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
#import "ViewUtility.h"
#import "AttributedString.h"
#import "Room.h"
#import "AppDelegate.h"
#import "CoreDataStack.h"

@interface RoomListViewController () <UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UILabel *numberLabel;
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

- (UILabel *)numberLabel {
  if (!_numberLabel) {
    _numberLabel = [[UILabel alloc] init];
    //_numberLabel.textColor = [UIColor darkVenetianRed];
  }
  return _numberLabel;
}

- (UIPickerView *)pickerView {
  if (!_pickerView) {
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.backgroundColor = [UIColor peach];
  }
  return _pickerView;
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
  
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor venetianRed];

  [self.headerView addToSuperViewWithConstraints: rootView withViewAbove: nil height: 250 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [self.tableView addToSuperViewWithConstraints: rootView withViewAbove: self.headerView height: 0 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [self.numberLabel addToSuperViewWithConstraintsAndIntrinsicHeight: self.headerView withViewAbove: nil topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [self.pickerView addToSuperViewWithConstraintsAndIntrinsicHeight: self.headerView withViewAbove: self.numberLabel topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  
  self.view = rootView;
}


- (void)viewDidLoad {
  [super viewDidLoad];

  self.pickerView.dataSource = self;
  self.pickerView.delegate = self;
  
  self.tableView.dataSource = self;
  [self.tableView registerClass: [RoomTableViewCell class] forCellReuseIdentifier: @"RoomCell"];
  
  [[CoreDataStack sharedInstance] fetchRoomsAscendingOnKey: @"number" whereKey: @"type" isEqualTo: @2];
  [self updateUI];
}

#pragma mark - Helper Methods

-(void) updateUI {
  self.numberLabel.attributedText = [AttributedString stringFromHeadline: @"test" subheadline: nil body: nil footnote: nil color: [UIColor darkVenetianRed]];
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

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return [ViewUtility roomTypes].count;
}

#pragma mark - UIPickerViewDelegate

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return [AttributedString stringFromHeadline: nil subheadline: nil body: nil footnote: [ViewUtility roomTypes][row] color: [UIColor darkVenetianRed]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  NSLog(@"picker selected: %@", [ViewUtility roomTypes][row]);
}

@end
