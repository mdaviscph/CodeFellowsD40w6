//
//  ReservationListViewController.m
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "ReservationListViewController.h"
#import "ReservationTableViewCell.h"
#import "UIViewExtension.h"
#import "UIColorExtension.h"
#import "ViewUtility.h"
#import "AttributedString.h"
#import "Guest.h"
#import "Hotel.h"
#import "AppDelegate.h"
#import "CoreDataStack.h"

@interface ReservationListViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIView *selectionView;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ReservationListViewController

#pragma mark - Public Property Getters, Setters

@synthesize selectedReservation = _selectedReservation;
- (Reservation *)selectedReservation {
  if (!_selectedReservation) {
    NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
    _selectedReservation = [NSEntityDescription insertNewObjectForEntityForName: @"Reservation" inManagedObjectContext: context];
  }
  return _selectedReservation;
}
- (void) setSelectedReservation:(Reservation *)selectedReservation {
  _selectedReservation = selectedReservation;
  [self updateUI];
}

#pragma mark - Private Property Getters, Setters

- (UIView *)textView {
  if (!_textView) {
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor peach];
  }
  return _textView;
}

- (UIView *)selectionView {
  if (!_selectionView) {
    _selectionView = [[UIView alloc] init];
    _selectionView.backgroundColor = [UIColor peach];
  }
  return _selectionView;
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
  NSLog(@"loading list view for Reservations");

  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor venetianRed];
  
//  [self.textView addToSuperViewWithConstraintsAndIntrinsicHeight: rootView withViewAbove: nil topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [self.textView addToSuperViewWithConstraints: rootView withViewAbove: nil height: 60 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [self.selectionView addToSuperViewWithConstraints: rootView withViewAbove: self.textView height: 162 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [self.tableView addToSuperViewWithConstraints: rootView withViewAbove: self.selectionView height: 0 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];

  [self.pickerView addToSuperViewWithConstraintsAndIntrinsicHeight: self.selectionView withViewAbove: nil topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];

  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.textView.delegate = self;
  
  self.pickerView.dataSource = self;
  self.pickerView.delegate = self;
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.tableView registerClass: [ReservationTableViewCell class] forCellReuseIdentifier: @"ReservationCell"];
  
  [self.pickerView selectRow: 1 inComponent: 0 animated: YES];
  [[CoreDataStack sharedInstance] fetchReservationsAscendingOnKey: @"arrival"];
  [self updateUI];
}

#pragma mark - Helper Methods

- (void) updateUI {

  AttributedString *atString = [[AttributedString alloc] init];
  [atString assignHeadline: [ViewUtility nameWithLast: self.selectedReservation.guest.lastName first: self.selectedReservation.guest.firstName] withSelector: @"guestTapped"];
  [atString assignSubheadline: [ViewUtility dateOnly: self.selectedReservation.arrival] withSelector: @"arrivalTapped"];
  [atString assignSubheadline2: [ViewUtility dateOnly: self.selectedReservation.departure] withSelector: @"departureTapped"];
  [atString assignBody: self.selectedReservation.hotel.name withSelector: @"hotelTapped"];
  [atString assignBody2: [ViewUtility roomType: self.selectedReservation.roomType] withSelector: @"roomTypeTapped"];
  
  self.textView.attributedText = [atString hypertextStringWithColor: [UIColor darkVenetianRed]];
  [self.tableView reloadData];
}

#pragma mark - Selector Methods

- (void)guestTapped {
  
}
- (void)arrivalTapped {
  
}
- (void)departureTapped {
  
}
- (void)hotelTapped {
  
}
- (void)roomTypeTapped {
  
}

#pragma mark - UITableViewDataSource
  
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [CoreDataStack sharedInstance].savedReservations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ReservationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"ReservationCell" forIndexPath: indexPath];
  
  cell.reservation = [CoreDataStack sharedInstance].savedReservations[indexPath.row];
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  self.selectedReservation = [CoreDataStack sharedInstance].savedReservations[indexPath.row];
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
  
  AttributedString *atString = [[AttributedString alloc] init];
  [atString assignHeadline: [ViewUtility roomTypes][row] withSelector: nil];
  return [atString hypertextStringWithColor: [UIColor darkVenetianRed]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  NSLog(@"picker selected: %@", [ViewUtility roomTypes][row]);
  [[CoreDataStack sharedInstance] fetchRoomsAscendingOnKey: @"number" whereKey: @"type" isEqualTo: @(row)];
  [self updateUI];
}

@end
