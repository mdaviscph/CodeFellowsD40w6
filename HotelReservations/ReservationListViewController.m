//
//  ReservationListViewController.m
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "ReservationListViewController.h"
#import "TableViewCell.h"
#import "UIViewExtension.h"
#import "UIColorExtension.h"
#import "ViewUtility.h"
#import "AttributedString.h"
#import "Guest.h"
#import "Hotel.h"
#import "Room.h"
#import "AppDelegate.h"
#import "CoreDataStack.h"

static const NSInteger kUnselectedIndex = -1;

@interface ReservationListViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIView *selectionView;
@property (strong, nonatomic) UIPickerView *entityPickerView;
@property (strong, nonatomic) UIDatePicker *datePickerView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView* tableViewSpacer;
@property (strong, nonatomic) NSArray *tableViewSpacerConstraints;

@property (strong, nonatomic) NSArray *queryRooms;
@property (nonatomic) NSInteger selectedGuestIndex;
@property (nonatomic) NSInteger selectedQueryRoomIndex;

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
    _datePickerView.minimumDate = [NSDate date];
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

  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor venetianRed];
  
  [self createConstraintsAndViewsForSuperView: rootView];
  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  self.navigationItem.title = NSLocalizedString(@"Reservations", @"navigation item title");
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
  
  if ([[CoreDataStack sharedInstance] fetchReservationCount] > 0) {
    [[CoreDataStack sharedInstance] fetchReservationsAscendingOnKeys: @[@"arrival"]];
    self.selectedReservation = [CoreDataStack sharedInstance].savedReservations.firstObject;
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
  if (self.isNewReservation) {
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

  if (self.isNewReservation) {
    Guest *guest = self.selectedGuestIndex != kUnselectedIndex ? [CoreDataStack sharedInstance].savedGuests[self.selectedGuestIndex] : nil;
    NSString *hotelName = self.selectedQueryRoomIndex != kUnselectedIndex ? [self.queryRooms[self.selectedQueryRoomIndex] hotel].name : nil;
    [atString assignHeadline: [ViewUtility nameWithLast: guest.lastName first: guest.firstName] withPlaceholder: [ViewUtility guestPlaceholder] withSelector: @"guestTapped"];
    [atString assignSubheadline: hotelName withPlaceholder: nil withSelector: nil];
    [atString assignBody: [ViewUtility roomType: self.selectedReservation.roomType] withPlaceholder: [ViewUtility roomTypePlaceholder] withSelector: @"roomTypeTapped"];
    [atString assignFootnote: [ViewUtility dateOnly: self.selectedReservation.arrival] withSelector: @"arrivalTapped"];
    [atString assignFootnote2: [ViewUtility dateOnly: self.selectedReservation.departure] withSelector: @"departureTapped"];

  } else {
    [atString assignHeadline: [ViewUtility nameWithLast: self.selectedReservation.guest.lastName first: self.selectedReservation.guest.firstName] withPlaceholder: nil withSelector: @"guestTapped"];
    [atString assignSubheadline: self.selectedReservation.hotel.name withPlaceholder: nil withSelector: nil];
    [atString assignBody: [ViewUtility roomType: self.selectedReservation.roomType] withPlaceholder: nil withSelector: @"roomTypeTapped"];
    [atString assignFootnote: [ViewUtility dateOnly: self.selectedReservation.arrival] withSelector: @"arrivalTapped"];
    [atString assignFootnote2: [ViewUtility dateOnly: self.selectedReservation.departure] withSelector: @"departureTapped"];
  }
  self.textView.attributedText = [atString hypertextStringWithColor: [UIColor darkVenetianRed]];
}
- (void) updateSelectionView {
  switch (self.nowSelecting) {
    case SelectingGuest:
    case SelectingRoomType:
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
  self.queryRooms = [[CoreDataStack sharedInstance] roomsAscendingOnKeys: @[@"hotel.name",@"number"] usingReservation: self.selectedReservation];
  [self updateUI];
}

#pragma mark - Selector Methods

- (void)addButtonTapped {
  self.newReservation = YES;
  [self adjustTableViewSpacingUsingContraints];
  self.textView.selectable = YES;
  
  // create an unassociated object to user until we are ready to save; downside is that
  // we cannot save the associated guest with an unassociated object
  NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
  NSEntityDescription *entity = [NSEntityDescription entityForName: @"Reservation" inManagedObjectContext: context];
  self.selectedReservation = [[Reservation alloc] initWithEntity: entity insertIntoManagedObjectContext: nil];

  self.selectedReservation.roomType = @(kUnselectedIndex);
  self.selectedGuestIndex = kUnselectedIndex;
  self.selectedQueryRoomIndex = kUnselectedIndex;
  self.selectedReservation.arrival = [NSDate date];
  self.selectedReservation.departure = [NSDate date];
  
  self.navigationItem.title = NSLocalizedString(@"Make a Reservation", @"navigation item title");
  UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target: self action: @selector(saveButtonTapped)];
  self.navigationItem.rightBarButtonItem = saveButton;
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(cancelButtonTapped)];

  [self queryForAvailableRooms];
  
  self.selectionView.hidden = NO;
  [self guestTapped];
}
- (void)saveButtonTapped {
  self.newReservation = NO;
  [self adjustTableViewSpacingUsingContraints];
  [self.view layoutIfNeeded];
  
  self.textView.selectable = NO;

  self.navigationItem.title = NSLocalizedString(@"Reservations", @"navigation item title");
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(addButtonTapped)];
  self.navigationItem.leftBarButtonItem = nil;

  if (self.selectedQueryRoomIndex != kUnselectedIndex && self.selectedGuestIndex != kUnselectedIndex && self.selectedReservation.arrival && self.selectedReservation.departure && self.selectedReservation.roomType.integerValue != kUnselectedIndex) {

    // associate object in order to save
    NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
    [context insertObject: self.selectedReservation];

    // connect related objects
    self.selectedReservation.guest = [CoreDataStack sharedInstance].savedGuests[self.selectedGuestIndex];
    self.selectedReservation.hotel = [self.queryRooms[self.selectedQueryRoomIndex] hotel];

    [[CoreDataStack sharedInstance] saveAll];
    [[CoreDataStack sharedInstance] fetchReservationsAscendingOnKeys: @[@"arrival"]];
  }

  self.entityPickerView.hidden = YES;
  self.datePickerView.hidden = YES;
  self.selectionView.hidden = YES;

  self.selectedReservation = [CoreDataStack sharedInstance].savedReservations.firstObject;
  [self updateUI];
}
- (void)cancelButtonTapped {
  self.selectedQueryRoomIndex = kUnselectedIndex;
  [self saveButtonTapped];
}

- (void)guestTapped {
  self.nowSelecting = SelectingGuest;
  self.entityPickerView.hidden = NO;
  self.datePickerView.hidden = YES;
  if (self.selectedGuestIndex != kUnselectedIndex) {
    [self.entityPickerView selectRow: self.selectedGuestIndex inComponent: 0 animated: YES];
  }
  [self updateUI];
}
- (void)arrivalTapped {
  self.nowSelecting = SelectingArrival;
  self.datePickerView.hidden = NO;
  self.entityPickerView.hidden = YES;
  self.datePickerView.date = self.selectedReservation.arrival;
  [self updateUI];
}
- (void)departureTapped {
  self.nowSelecting = SelectingDeparture;
  self.datePickerView.hidden = NO;
  self.entityPickerView.hidden = YES;
  self.datePickerView.date = self.selectedReservation.departure;
  [self updateUI];
}
//- (void)hotelTapped {
//}
- (void)roomTypeTapped {
  self.nowSelecting = SelectingRoomType;
  self.entityPickerView.hidden = NO;
  self.datePickerView.hidden = YES;
  if (self.selectedReservation.roomType.integerValue != kUnselectedIndex) {
    [self.entityPickerView selectRow: self.selectedReservation.roomType.integerValue inComponent: 0 animated: YES];
  }
  [self updateUI];
}

- (void)dateChanged:(UIDatePicker *)sender {
  
  switch (self.nowSelecting) {
    case SelectingArrival:
      self.selectedReservation.arrival = sender.date;
      [self queryForAvailableRooms];
      break;
    case SelectingDeparture:
      self.selectedReservation.departure = sender.date;
      [self queryForAvailableRooms];
      break;
    default:
      break;
  }
}

#pragma mark - UITableViewDataSource
  
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.isNewReservation) {
    return self.queryRooms ? self.queryRooms.count : 0;
  } else {
    return [CoreDataStack sharedInstance].savedReservations.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  TableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"TableCell" forIndexPath: indexPath];
  AttributedString *atString = [[AttributedString alloc] init];
  
  if (self.isNewReservation) {
    Room* room = self.queryRooms[indexPath.row];

    [atString assignHeadline: [ViewUtility roomNumber: room.number] withPlaceholder: nil withSelector: nil];
    [atString assignHeadline2: room.hotel.name withSelector: nil];
    [atString assignCaption: [ViewUtility roomType: self.selectedReservation.roomType] withSelector: nil];
  } else {
    Reservation* reservation = [CoreDataStack sharedInstance].savedReservations[indexPath.row];
    
    [atString assignHeadline: [ViewUtility nameWithLast: reservation.guest.lastName first: reservation.guest.firstName] withPlaceholder: nil withSelector: nil];
    [atString assignSubheadline: reservation.hotel.name withPlaceholder: nil withSelector: nil];
    [atString assignBody: [ViewUtility roomType: reservation.roomType] withPlaceholder: nil withSelector: nil];
    [atString assignFootnote: [ViewUtility dateOnly: reservation.arrival] withSelector: nil];
    [atString assignFootnote2: [ViewUtility dateOnly: reservation.departure] withSelector: nil];
  }
  cell.textView.backgroundColor = [UIColor apricot];
  cell.borderColor = [UIColor darkVenetianRed];
  cell.textView.attributedText = [atString hypertextStringWithColor: [UIColor darkVenetianRed]];
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isNewReservation) {
    // retaining hotel indicates we are ready to save
    //self.selectedReservation.hotel = [self.queryRooms[indexPath.row] hotel];
    self.selectedQueryRoomIndex = indexPath.row;
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
  } else {
    self.selectedReservation = [CoreDataStack sharedInstance].savedReservations[indexPath.row];
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
//  else if ([URL.absoluteString isEqualToString: @"hotelTapped"]) {
//    [self hotelTapped];
//  }
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
      [atString assignHeadline: [ViewUtility nameWithLast: [[CoreDataStack sharedInstance].savedGuests[row] lastName] first: [[CoreDataStack sharedInstance].savedGuests[row] firstName]] withPlaceholder: nil withSelector: nil];
      break;
    case SelectingRoomType:
      [atString assignHeadline: [ViewUtility roomTypes][row] withPlaceholder: nil withSelector: nil];
      break;
    default:
      break;
  }
  return [atString hypertextStringWithColor: [UIColor darkVenetianRed]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  switch (self.nowSelecting) {
    case SelectingGuest:
      //self.selectedReservation.guest = [CoreDataStack sharedInstance].savedGuests[row];
      self.selectedGuestIndex = row;
      [self updateUI];
      break;
    case SelectingRoomType:
      self.selectedReservation.roomType = @(row);
      [self queryForAvailableRooms];
      break;
    default:
      break;
  }
}

@end
