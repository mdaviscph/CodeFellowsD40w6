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
#import "Room.h"
#import "AppDelegate.h"
#import "CoreDataStack.h"

static const NSInteger kDefaultRoomType = 1;

@interface ReservationListViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIView *selectionView;
@property (strong, nonatomic) UIPickerView *roomTypeOrGuestPickerView;
@property (strong, nonatomic) UIDatePicker *datePickerView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *queryRooms;
@property (nonatomic) NSInteger selectedGuest;

@end

@implementation ReservationListViewController

#pragma mark - Private Property Getters, Setters

- (UIView *)textView {
  if (!_textView) {
    _textView = [[UITextView alloc] init];
    _textView.editable = NO;
    _textView.selectable = NO;
    _textView.scrollEnabled = NO;
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

- (UIPickerView *)roomTypeOrGuestPickerView {
  if (!_roomTypeOrGuestPickerView) {
    _roomTypeOrGuestPickerView = [[UIPickerView alloc] init];
    _roomTypeOrGuestPickerView.backgroundColor = [UIColor peach];
  }
  return _roomTypeOrGuestPickerView;
}

- (UIDatePicker *)datePickerView {
  if (!_datePickerView) {
    _datePickerView = [[UIDatePicker alloc] init];
    _datePickerView.datePickerMode = UIDatePickerModeDate;
    _datePickerView.backgroundColor = [UIColor peach];
  }
  return _datePickerView;
}

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
    _tableView.allowsSelection = YES;
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
  
  UIView* spacer1 = [[UIView alloc] init];
  spacer1.backgroundColor = [UIColor middleRed];
  UIView* spacer2 = [[UIView alloc] init];
  spacer2.backgroundColor = [UIColor middleRed];

  [spacer1 addToSuperViewWithConstraints: rootView withViewAbove: nil height: 10 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [self.textView addToSuperViewWithConstraints: rootView withViewAbove: spacer1 height: 80 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [self.selectionView addToSuperViewWithConstraints: rootView withViewAbove: self.textView height: 180 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [spacer2 addToSuperViewWithConstraints: rootView withViewAbove: self.selectionView height: 10 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [self.tableView addToSuperViewWithConstraints: rootView withViewAbove: spacer2 height: 0 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];

  [self.roomTypeOrGuestPickerView addToSuperViewWithConstraintsAndIntrinsicHeight: self.selectionView withViewAbove: nil topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [self.datePickerView addToSuperViewWithConstraintsAndIntrinsicHeight: self.selectionView withViewAbove: nil topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];

  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = @"Reservations";
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(addButtonTapped)];

  self.textView.delegate = self;
  
  self.roomTypeOrGuestPickerView.dataSource = self;
  self.roomTypeOrGuestPickerView.delegate = self;
  [self.datePickerView addTarget: self action: @selector(dateChanged:) forControlEvents: UIControlEventValueChanged];
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.tableView registerClass: [ReservationTableViewCell class] forCellReuseIdentifier: @"ReservationCell"];
  
  self.roomTypeOrGuestPickerView.hidden = YES;
  self.datePickerView.hidden = YES;
  
  if ([[CoreDataStack sharedInstance] fetchReservationCount] > 0) {
    [[CoreDataStack sharedInstance] fetchReservations];
    self.selectedReservation = [CoreDataStack sharedInstance].savedReservations[0];
  }
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

  [self.roomTypeOrGuestPickerView reloadAllComponents];
  [self.tableView reloadData];
}

- (void) queryForRooms {
  self.queryRooms = [[CoreDataStack sharedInstance] roomsAscendingOnKeys: @[@"hotel.name",@"number"] usingReservation: self.selectedReservation];
  [self updateUI];
}

#pragma mark - Selector Methods

- (void)addButtonTapped {
  self.newReservation = YES;
  self.textView.selectable = YES;
  
  NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
  self.selectedReservation = [NSEntityDescription insertNewObjectForEntityForName: @"Reservation" inManagedObjectContext: context];
  
  //self.selectedReservation.guest = [CoreDataStack sharedInstance].savedGuests.firstObject;
  self.selectedReservation.roomType = @(kDefaultRoomType);
  self.selectedReservation.arrival = [NSDate date];
  self.selectedReservation.departure = [NSDate date];
  
  UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target: self action: @selector(saveButtonTapped)];
  self.navigationItem.rightBarButtonItem = saveButton;
  [self queryForRooms];
  [self guestTapped];
}
- (void)saveButtonTapped {
  self.newReservation = NO;
  self.textView.selectable = YES;
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(addButtonTapped)];
  [[CoreDataStack sharedInstance] saveAll];
  self.selectedReservation = nil;
}

- (void)guestTapped {
  self.nowSelecting = SelectingGuest;
  self.roomTypeOrGuestPickerView.hidden = NO;
  self.datePickerView.hidden = YES;
  [self.roomTypeOrGuestPickerView.superview setNeedsDisplay];
  [self.roomTypeOrGuestPickerView selectRow: self.selectedGuest inComponent: 0 animated: YES];
  [self updateUI];
}
- (void)arrivalTapped {
  self.nowSelecting = SelectingArrival;
  self.datePickerView.hidden = NO;
  self.roomTypeOrGuestPickerView.hidden = YES;
  self.datePickerView.date = self.selectedReservation.arrival;
  [self updateUI];
}
- (void)departureTapped {
  self.nowSelecting = SelectingDeparture;
  self.datePickerView.hidden = NO;
  self.roomTypeOrGuestPickerView.hidden = YES;
  self.datePickerView.date = self.selectedReservation.departure;
  [self updateUI];
}
- (void)hotelTapped {
  self.nowSelecting = SelectingHotel;
  self.roomTypeOrGuestPickerView.hidden = YES;
//  [self.roomTypePickerView selectRow: 1 inComponent: 0 animated: YES];
  [self updateUI];
}
- (void)roomTypeTapped {
  self.nowSelecting = SelectingRoomType;
  self.roomTypeOrGuestPickerView.hidden = NO;
  self.datePickerView.hidden = YES;
  [self.roomTypeOrGuestPickerView.superview setNeedsDisplay];
  [self.roomTypeOrGuestPickerView selectRow: self.selectedReservation.roomType.integerValue inComponent: 0 animated: YES];
  [self updateUI];
}

- (void)dateChanged:(UIDatePicker *)sender {
  
  switch (self.nowSelecting) {
    case SelectingArrival:
      self.selectedReservation.arrival = sender.date;
      [self queryForRooms];
      break;
    case SelectingDeparture:
      self.selectedReservation.departure = sender.date;
      [self queryForRooms];
      break;
    default:
      break;
  }
}

#pragma mark - UITableViewDataSource
  
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.newReservation) {
    return self.queryRooms ? self.queryRooms.count : 0;
  } else {
    return [CoreDataStack sharedInstance].savedReservations.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  ReservationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"ReservationCell" forIndexPath: indexPath];
  AttributedString *atString = [[AttributedString alloc] init];
  
  if (self.newReservation) {
    Room* room = self.queryRooms[indexPath.row];

    [atString assignHeadline: [ViewUtility roomNumber: room.number] withSelector: nil];
    [atString assignHeadline2: room.hotel.name withSelector: nil];
    [atString assignCaption: [ViewUtility roomType: self.selectedReservation.roomType] withSelector: nil];
  } else {
    Reservation* reservation = [CoreDataStack sharedInstance].savedReservations[indexPath.row];
    
    [atString assignHeadline: [ViewUtility nameWithLast: reservation.guest.lastName first: reservation.guest.firstName] withSelector: nil];
    [atString assignSubheadline: [ViewUtility dateOnly: reservation.arrival] withSelector: nil];
    [atString assignSubheadline2: [ViewUtility dateOnly: reservation.departure] withSelector: nil];
    [atString assignBody: reservation.hotel.name withSelector: nil];
    [atString assignBody2: [ViewUtility roomType: reservation.roomType] withSelector: nil];
  }
  cell.textView.attributedText = [atString hypertextStringWithColor: [UIColor darkVenetianRed]];
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.newReservation) {
    
  } else {
    self.selectedReservation = [CoreDataStack sharedInstance].savedReservations[indexPath.row];
    [self updateUI];
  }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
  // TODO: change to using real selectors?
  if ([URL.absoluteString isEqualToString: @"guestTapped"]) {
    [self guestTapped];
  }
  else if ([URL.absoluteString isEqualToString: @"arrivalTapped"]) {
    [self arrivalTapped];
  }
  else if ([URL.absoluteString isEqualToString: @"departureTapped"]) {
    [self departureTapped];
  }
  else if ([URL.absoluteString isEqualToString: @"hotelTapped"]) {
    [self hotelTapped];
  }
  else if ([URL.absoluteString isEqualToString: @"roomTypeTapped"]) {
    [self roomTypeTapped];
  }
  return NO;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  NSInteger count;
  switch (self.nowSelecting) {
    case SelectingGuest:
      count = 1;
      break;
    case SelectingRoomType:
      count = 1;
      break;
    default:
      count = 1; // minimum number of components to prevent exception from selectRow: calls
      break;
  }
  return count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  NSInteger count;
  switch (self.nowSelecting) {
    case SelectingGuest:
      count = [CoreDataStack sharedInstance].savedGuests.count;
      break;
    case SelectingRoomType:
      count = [ViewUtility roomTypes].count;
      break;
    default:
      count = 0;
      break;
  }
  return count;
}

#pragma mark - UIPickerViewDelegate

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
  AttributedString *atString = [[AttributedString alloc] init];
  switch (self.nowSelecting) {
    case SelectingGuest:
    {
      Guest *guest = [CoreDataStack sharedInstance].savedGuests[row];
      [atString assignHeadline: [ViewUtility nameWithLast: guest.lastName first: guest.firstName] withSelector: nil];
    }
      break;
    case SelectingRoomType:
      [atString assignHeadline: [ViewUtility roomTypes][row] withSelector: nil];
      break;
    default:
      break;
  }
  return [atString hypertextStringWithColor: [UIColor darkVenetianRed]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  switch (self.nowSelecting) {
    case SelectingGuest:
      self.selectedReservation.guest = [CoreDataStack sharedInstance].savedGuests[row];
      self.selectedGuest = row;
      [self updateUI];
      break;
    case SelectingRoomType:
      self.selectedReservation.roomType = @(row);
      [self queryForRooms];
      break;
    default:
      break;
  }
}

@end
