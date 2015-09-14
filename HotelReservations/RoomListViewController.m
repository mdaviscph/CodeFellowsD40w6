//
//  RoomListViewController.m
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "RoomListViewController.h"
#import "TableViewCell.h"
#import "UIViewExtension.h"
#import "UIColorExtension.h"
#import "ViewUtility.h"
#import "AttributedString.h"
#import "Guest.h"
#import "Hotel.h"
#import "AppDelegate.h"
#import "CoreDataStack.h"

static const NSInteger kDefaultRoomType = -1;      // causes placeholder text to be used in picker view

@interface RoomListViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIView *selectionView;
@property (strong, nonatomic) UIPickerView *entityPickerView;
@property (strong, nonatomic) UIDatePicker *datePickerView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView* tableViewSpacer;
@property (strong, nonatomic) NSArray *tableViewSpacerConstraints;

@property (strong, nonatomic) NSArray *queryRooms;
@property (nonatomic) NSInteger selectedGuest;      // TODO: better way to keep track or index of selected guest since we are sharing PickerView
@property (nonatomic) NSInteger selectedHotel;      // TODO: better way to keep track or index of selected hotel since we are sharing PickerView

@end

@implementation RoomListViewController

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

- (UIPickerView *)entityPickerView {
  if (!_entityPickerView) {
    _entityPickerView = [[UIPickerView alloc] init];
    _entityPickerView.backgroundColor = [UIColor peach];
  }
  return _entityPickerView;
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
  NSLog(@"loading list view for Rooms");
  
  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor venetianRed];
  
  [self createConstraintsAndViewsForSuperView: rootView];
  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  self.navigationItem.title = NSLocalizedString(@"Rooms", @"navigation item title");
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(addButtonTapped)];
  
  self.textView.delegate = self;
  
  self.entityPickerView.dataSource = self;
  self.entityPickerView.delegate = self;
  [self.datePickerView addTarget: self action: @selector(dateChanged:) forControlEvents: UIControlEventValueChanged];
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.tableView registerClass: [TableViewCell class] forCellReuseIdentifier: @"TableCell"];
  
  [self.textView setLinkTextAttributes: @{NSForegroundColorAttributeName : [UIColor darkVenetianRed]}];

  self.entityPickerView.hidden = YES;
  self.datePickerView.hidden = YES;
  self.selectionView.hidden = YES;
  [self.view setNeedsDisplay];
  
  if ([[CoreDataStack sharedInstance] fetchRoomCount] > 0) {
    [[CoreDataStack sharedInstance] fetchRoomsAscendingOnKeys: @[@"hotel.name",@"number"]];
    self.selectedRoom = [CoreDataStack sharedInstance].savedRooms.firstObject;
  }
  [self updateUI];
}

#pragma mark - Helper Methods

- (void) createConstraintsAndViewsForSuperView:(UIView *)rootView {
  
  UIView* topSpacerView = [[UIView alloc] init];
  topSpacerView.backgroundColor = [UIColor middleRed];
  self.tableViewSpacer = [[UIView alloc] init];
  self.tableViewSpacer.backgroundColor = [UIColor middleRed];
  
  [topSpacerView addToSuperViewWithConstraints: rootView withViewAbove: nil height: 10 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [self.textView addToSuperViewWithConstraints: rootView withViewAbove: topSpacerView height: 100 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  
  [self.selectionView addToSuperViewWithConstraints: rootView withViewAbove: self.textView height: 180 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [self.entityPickerView addToSuperViewWithConstraintsAndIntrinsicHeight: self.selectionView withViewAbove: nil topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [self.datePickerView addToSuperViewWithConstraintsAndIntrinsicHeight: self.selectionView withViewAbove: nil topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  
  self.tableViewSpacerConstraints = [self.tableViewSpacer addToSuperViewWithConstraints: rootView withViewAbove: self.textView height: 10 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [self.tableView addToSuperViewWithConstraints: rootView withViewAbove: self.tableViewSpacer height: 0 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
}

- (void) adjustTableViewSpacingUsingContraints {
  
  [self.view removeConstraints: self.tableViewSpacerConstraints];
  if (self.isNewBooking) {
    self.tableViewSpacerConstraints = [self.tableViewSpacer addToSuperViewWithConstraints: self.view withViewAbove: self.selectionView height: 10 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  } else {
    self.tableViewSpacerConstraints = [self.tableViewSpacer addToSuperViewWithConstraints: self.view withViewAbove: self.textView height: 10 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  }
  [self.view layoutIfNeeded];
}

- (void) updateUI {
  [self updateTextView];
  [self updateSelectionView];
  [self updateTableView];
}
- (void) updateTextView {
  AttributedString *atString = [[AttributedString alloc] init];
  NSString *hotelPlaceholder = self.isNewBooking ? [ViewUtility hotelPlaceholder] : nil;
  NSString *guestPlaceholder = self.isNewBooking ? [ViewUtility guestPlaceholder] : nil;
  NSString *roomTypePlaceholder = self.newBooking ? [ViewUtility roomTypePlaceholder] : nil;

  [atString assignHeadline: self.selectedRoom.hotel.name withPlaceholder: hotelPlaceholder withSelector: @"hotelTapped"];
  [atString assignHeadline2: self.selectedRoom.number withSelector: nil];
  [atString assignSubheadline: [ViewUtility nameWithLast: self.selectedRoom.guest.lastName first: self.selectedRoom.guest.firstName] withPlaceholder: guestPlaceholder withSelector: @"guestTapped"];
  [atString assignBody: [ViewUtility roomType: self.selectedRoom.type] withPlaceholder: roomTypePlaceholder withSelector: @"roomTypeTapped"];
  [atString assignFootnote: [ViewUtility dateOnly: self.selectedRoom.bookedIn] withSelector: @"arrivalTapped"];
  [atString assignFootnote2: [ViewUtility dateOnly: self.selectedRoom.bookedOut] withSelector: @"departureTapped"];
  
  self.textView.attributedText = [atString hypertextStringWithColor: [UIColor darkVenetianRed]];
}
- (void) updateSelectionView {
  switch (self.nowSelecting) {
    case SelectingGuest:
    case SelectingRoomType:
    case SelectingHotel:
      [self.entityPickerView reloadAllComponents];
      break;
    default:
      break;
  }
}
- (void) updateTableView {
  [self.tableView reloadData];
}
- (void) queryForAvailableRooms {
  self.queryRooms = [[CoreDataStack sharedInstance] roomsAscendingOnKeys: @[@"hotel.name",@"number"] usingRoom: self.selectedRoom];
  [self updateUI];
}

#pragma mark - Selector Methods

- (void)addButtonTapped {
  self.newBooking = YES;
  [self adjustTableViewSpacingUsingContraints];
  self.textView.selectable = YES;
  
  NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
  self.selectedRoom = [NSEntityDescription insertNewObjectForEntityForName: @"Room" inManagedObjectContext: context];
  
  self.selectedRoom.type = @(kDefaultRoomType);
  self.selectedRoom.bookedIn = [NSDate date];
  self.selectedRoom.bookedOut = [NSDate date];
  
  self.navigationItem.title = NSLocalizedString(@"Assign a Room", @"navigation item title");
  UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target: self action: @selector(saveButtonTapped)];
  self.navigationItem.rightBarButtonItem = saveButton;
  [self queryForAvailableRooms];
  
  self.selectionView.hidden = NO;
  [self guestTapped];
  [self hotelTapped];
}
- (void)saveButtonTapped {
  self.newBooking = NO;
  [self adjustTableViewSpacingUsingContraints];
  [self.view layoutIfNeeded];
  
  self.textView.selectable = NO;
  
  self.navigationItem.title = NSLocalizedString(@"Rooms", @"navigation item title");
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(addButtonTapped)];
  
  if (self.selectedRoom.number && self.selectedRoom.guest) {
    // TODO: figure out the way to only save this room booking.
    [[CoreDataStack sharedInstance] saveAll];
  }
  
  self.entityPickerView.hidden = YES;
  self.datePickerView.hidden = YES;
  self.selectionView.hidden = YES;
  
  [[CoreDataStack sharedInstance] fetchRooms];
  self.selectedRoom = [CoreDataStack sharedInstance].savedRooms.lastObject;
  [self updateUI];
}

- (void)guestTapped {
  self.nowSelecting = SelectingGuest;
  self.entityPickerView.hidden = NO;
  self.datePickerView.hidden = YES;
  [self.entityPickerView selectRow: self.selectedGuest inComponent: 0 animated: YES];
  [self updateUI];
}
- (void)arrivalTapped {
  self.nowSelecting = SelectingArrival;
  self.datePickerView.hidden = NO;
  self.entityPickerView.hidden = YES;
  self.datePickerView.date = self.selectedRoom.bookedIn;
  [self updateUI];
}
- (void)departureTapped {
  self.nowSelecting = SelectingDeparture;
  self.datePickerView.hidden = NO;
  self.entityPickerView.hidden = YES;
  self.datePickerView.date = self.selectedRoom.bookedOut;
  [self updateUI];
}
- (void)hotelTapped {
  self.nowSelecting = SelectingHotel;
  self.entityPickerView.hidden = NO;
  self.datePickerView.hidden = YES;
  [self.entityPickerView selectRow: self.selectedHotel inComponent: 0 animated: YES];
  [self updateUI];
}
- (void)roomTypeTapped {
  self.nowSelecting = SelectingRoomType;
  self.entityPickerView.hidden = NO;
  self.datePickerView.hidden = YES;
  [self.entityPickerView selectRow: self.selectedRoom.type.integerValue inComponent: 0 animated: YES];
  [self updateUI];
}

- (void)dateChanged:(UIDatePicker *)sender {
  
  switch (self.nowSelecting) {
    case SelectingArrival:
      self.selectedRoom.bookedIn = sender.date;
      [self queryForAvailableRooms];
      break;
    case SelectingDeparture:
      self.selectedRoom.bookedOut = sender.date;
      [self queryForAvailableRooms];
      break;
    default:
      break;
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.isNewBooking) {
    return self.queryRooms ? self.queryRooms.count : 0;
  } else {
    return [CoreDataStack sharedInstance].savedRooms.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  TableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"TableCell" forIndexPath: indexPath];
  AttributedString *atString = [[AttributedString alloc] init];
  
  if (self.isNewBooking) {
    Room* room = self.queryRooms[indexPath.row];
    
    [atString assignHeadline: [ViewUtility roomNumber: room.number] withPlaceholder: nil withSelector: nil];
    [atString assignHeadline2: room.hotel.name withSelector: nil];
    [atString assignFootnote: [ViewUtility roomType: self.selectedRoom.type] withSelector: nil];
    [atString assignCaption: [ViewUtility clean: room.clean] withSelector: nil];
  } else {
    Room* room = [CoreDataStack sharedInstance].savedRooms[indexPath.row];
    
    [atString assignHeadline: [ViewUtility roomNumber: room.number] withPlaceholder: nil withSelector: nil];
    [atString assignHeadline2: room.hotel.name withSelector: nil];
    [atString assignBody: [ViewUtility dollarRating: room.rate] withPlaceholder: nil withSelector: nil];
    [atString assignBody2: [ViewUtility roomType: room.type] withSelector: nil];
    [atString assignCaption: [ViewUtility dateOnly: room.bookedIn] withSelector: nil];
    [atString assignCaption2: [ViewUtility dateOnly: room.bookedOut] withSelector: nil];
  }
  cell.textView.backgroundColor = [UIColor apricot];
  cell.borderColor = [UIColor darkVenetianRed];
  cell.textView.attributedText = [atString hypertextStringWithColor: [UIColor darkVenetianRed]];  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isNewBooking) {
    self.selectedRoom.number = [self.queryRooms[indexPath.row] number];
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
  } else {
    self.selectedRoom = [CoreDataStack sharedInstance].savedRooms[indexPath.row];
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
  }
  [self updateTextView];
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
    case SelectingRoomType:
    case SelectingHotel:
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
    case SelectingHotel:
      count = [CoreDataStack sharedInstance].savedHotels.count;
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
      [atString assignHeadline: [ViewUtility nameWithLast: [[CoreDataStack sharedInstance].savedGuests[row] lastName] first: [[CoreDataStack sharedInstance].savedGuests[row] firstName]] withPlaceholder: nil withSelector: nil];
      break;
    case SelectingRoomType:
      [atString assignHeadline: [ViewUtility roomTypes][row] withPlaceholder: nil withSelector: nil];
      break;
    case SelectingHotel:
      [atString assignHeadline: [[CoreDataStack sharedInstance].savedHotels[row] name] withPlaceholder: nil withSelector: nil];
      break;
    default:
      break;
  }
  return [atString hypertextStringWithColor: [UIColor darkVenetianRed]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  switch (self.nowSelecting) {
    case SelectingGuest:
      self.selectedRoom.guest = [CoreDataStack sharedInstance].savedGuests[row];
      self.selectedGuest = row;
      [self updateUI];
      break;
    case SelectingRoomType:
      self.selectedRoom.type = @(row);
      [self queryForAvailableRooms];
      break;
    case SelectingHotel:
      self.selectedRoom.hotel = [CoreDataStack sharedInstance].savedHotels[row];
      self.selectedHotel = row;
      [self queryForAvailableRooms];
      break;
    default:
      break;
  }
}

@end