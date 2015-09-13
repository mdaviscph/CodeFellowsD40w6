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

enum PickerType {
  RoomPicker  = 1,
  GuestPicker = 2
};
typedef enum PickerType PickerType;

@interface ReservationListViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIView *selectionView;
@property (strong, nonatomic) UIPickerView *roomTypePickerView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSNumber *selectedRoomType;
@property (strong, nonatomic) NSArray *queryGuests;
@property (strong, nonatomic) NSArray *queryReservations;
@property (strong, nonatomic) NSArray *queryHotels;
@property (strong, nonatomic) NSArray *queryRooms;

@end

@implementation ReservationListViewController

#pragma mark - Public Property Getters, Setters

@synthesize selectedReservation = _selectedReservation;
- (Reservation *)selectedReservation {
  return _selectedReservation;
}
- (void) setSelectedReservation:(Reservation *)selectedReservation {
  _selectedReservation = selectedReservation;
  [self updateUI];
}

#pragma mark - Private Property Getters, Setters

- (NSNumber *)selectedRoomType {
  if (!_selectedRoomType) {
    _selectedRoomType = [[NSNumber alloc] init];
    _selectedRoomType = @(1);
  }
  return _selectedRoomType;
}

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

- (UIPickerView *)roomTypePickerView {
  if (!_roomTypePickerView) {
    _roomTypePickerView = [[UIPickerView alloc] init];
    _roomTypePickerView.backgroundColor = [UIColor peach];
    _roomTypePickerView.tag = RoomPicker;
  }
  return _roomTypePickerView;
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

  [self.roomTypePickerView addToSuperViewWithConstraintsAndIntrinsicHeight: self.selectionView withViewAbove: nil topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];

  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = @"Reservations";
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(addButtonTapped)];

  self.textView.delegate = self;
  
  self.roomTypePickerView.dataSource = self;
  self.roomTypePickerView.delegate = self;
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.tableView registerClass: [ReservationTableViewCell class] forCellReuseIdentifier: @"ReservationCell"];
  
  self.roomTypePickerView.hidden = YES;
  
  //self.queryGuests = [CoreDataStack sharedInstance].savedGuests;
  //self.queryReservations = [CoreDataStack sharedInstance].savedReservations;
  //self.queryHotels = [CoreDataStack sharedInstance].savedHotels;
  //self.queryRooms = [CoreDataStack sharedInstance].savedRooms;
  
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

  [self.tableView reloadData];
}

- (void)nslogHotels:(NSArray *)hotels {
  for (Hotel *hotel in hotels) {
    for (Room *room in hotel.rooms) {
      NSLog(@"Hotel %@ room %@", hotel.name, room.number);
    }
    for (Reservation *reservation in hotel.reservations) {
      NSLog(@"Hotel %@ reservation guest %@ arrival %@ departure %@", hotel.name, reservation.guest.lastName, reservation.arrival, reservation.departure);
    }
  }
}

#pragma mark - Selector Methods

- (void)addButtonTapped {
  self.newReservation = YES;
  self.textView.selectable = YES;
  NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
  self.selectedReservation = [NSEntityDescription insertNewObjectForEntityForName: @"Reservation" inManagedObjectContext: context];
  UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target: self action: @selector(saveButtonTapped)];
  self.navigationItem.rightBarButtonItem = saveButton;
}
- (void)saveButtonTapped {
  self.newReservation = NO;
  self.textView.selectable = YES;
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(addButtonTapped)];
  [[CoreDataStack sharedInstance] saveAll];
}

- (void)guestTapped {
  self.roomTypePickerView.hidden = YES;
//  [self.guestPickerView selectRow: 1 inComponent: 0 animated: YES];
  [self updateUI];
}
- (void)arrivalTapped {
  self.roomTypePickerView.hidden = YES;
//  [self.roomTypePickerView selectRow: 1 inComponent: 0 animated: YES];
  [self updateUI];
}
- (void)departureTapped {
  self.roomTypePickerView.hidden = YES;
//  [self.roomTypePickerView selectRow: 1 inComponent: 0 animated: YES];
  [self updateUI];
}
- (void)hotelTapped {
  self.roomTypePickerView.hidden = YES;
//  [self.roomTypePickerView selectRow: 1 inComponent: 0 animated: YES];
  [self updateUI];
}
- (void)roomTypeTapped {
  self.roomTypePickerView.hidden = NO;
  [self.roomTypePickerView selectRow: 1 inComponent: 0 animated: YES];
  [self updateUI];
}

#pragma mark - UITableViewDataSource
  
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.newReservation) {
    return self.queryRooms.count;
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
    [atString assignCaption: [ViewUtility roomType: self.selectedRoomType] withSelector: nil];
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
  self.selectedReservation = [CoreDataStack sharedInstance].savedReservations[indexPath.row];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
  NSLog(@"Selector: %@", URL.absoluteString);
  
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
  if (pickerView.tag == RoomPicker) {
    return 1;
  } else if (pickerView.tag == GuestPicker) {
    return 1;
  }
  return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  if (pickerView.tag == RoomPicker) {
      return [ViewUtility roomTypes].count;
  } else if (pickerView.tag == GuestPicker) {
    return [CoreDataStack sharedInstance].savedGuests.count;
  }
  return 0;
}

#pragma mark - UIPickerViewDelegate

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
  
  AttributedString *atString = [[AttributedString alloc] init];
  if (pickerView.tag == RoomPicker) {
    [atString assignHeadline: [ViewUtility roomTypes][row] withSelector: nil];
  } else if (pickerView.tag == GuestPicker) {
    Guest *guest = [CoreDataStack sharedInstance].savedGuests[row];
    [atString assignHeadline: [ViewUtility nameWithLast: guest.lastName first: guest.firstName] withSelector: nil];
  }
  return [atString hypertextStringWithColor: [UIColor darkVenetianRed]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  if (pickerView.tag == RoomPicker) {
    self.selectedRoomType = @(row);
    self.queryRooms = [[CoreDataStack sharedInstance] roomsAscendingOnKeys: @[@"hotel.name",@"number"] whereKey: @"type" isEqualTo: self.selectedRoomType];
    [self nslogHotels: self.queryHotels];
  } else if (pickerView.tag == GuestPicker) {
    self.selectedReservation.guest = [CoreDataStack sharedInstance].savedGuests[row];
  }
  [self updateUI];
}

@end
