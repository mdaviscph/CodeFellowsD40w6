//
//  MenuViewController.m
//  HotelReservations
//
//  Created by mike davis on 9/9/15.
//  Copyright (c) 2015 mike davis. All rights reserved.
//

#import "MenuViewController.h"
#import "HotelListViewController.h"
#import "RoomListViewController.h"
#import "GuestListViewController.h"
#import "ReservationListViewController.h"
#import "UIViewExtension.h"
#import "UIColorExtension.h"
#import "JSONFileImport.h"
#import "CoreDataStack.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) NSArray *menuItemsVC;

@property (strong, nonatomic) HotelListViewController* hotelVC;
@property (strong, nonatomic) RoomListViewController* roomVC;
@property (strong, nonatomic) GuestListViewController* guestVC;
@property (strong, nonatomic) ReservationListViewController* reservationVC;

@end

@implementation MenuViewController

NSString *const menuItemHotels = @"Hotels";
NSString *const menuItemRooms = @"Rooms";
NSString *const menuItemGuests = @"Guests";
NSString *const menuItemReservations = @"Reservations";

#pragma mark - Private Property Getters, Setters

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
    _tableView.allowsSelection = YES;
    _tableView.backgroundColor = [UIColor vividTangerine];
  }
  return _tableView;
}

- (NSArray *)menuItems {
  if (!_menuItems) {
    _menuItems = @[menuItemHotels, menuItemRooms, menuItemGuests, menuItemReservations];
  }
  return _menuItems;
}

- (NSArray *)menuItemsVC {
  if (!_menuItemsVC) {
    _menuItemsVC = @[self.hotelVC, self.roomVC, self.guestVC, self.reservationVC];
  }
  return _menuItemsVC;
}

- (HotelListViewController *)hotelVC {
  if (!_hotelVC) {
    _hotelVC = [[HotelListViewController alloc] init];
  }
  return _hotelVC;
}

- (RoomListViewController *)roomVC {
  if (!_roomVC) {
    _roomVC = [[RoomListViewController alloc] init];
  }
  return _roomVC;
}

- (GuestListViewController *)guestVC {
  if (!_guestVC) {
    _guestVC = [[GuestListViewController alloc] init];
  }
  return _guestVC;
}

- (ReservationListViewController *)reservationVC {
  if (!_reservationVC) {
    _reservationVC = [[ReservationListViewController alloc] init];
  }
  return _reservationVC;
}

#pragma mark - Life Cycle Methods

- (void)loadView {
  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor tumbleweed];
  
  [self.tableView addToSuperViewWithConstraints: rootView];
    
  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.navigationItem.title = @"Hotel Reservations";
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"MenuCell"];

  NSArray *importedHotels;
  NSArray *importedGuests;
  if ([[CoreDataStack sharedInstance] fetchHotelCount] == 0) {
    importedHotels = [JSONFileImport loadSavedHotelsFromJSON];
  }
  if ([[CoreDataStack sharedInstance] fetchGuestCount] == 0) {
    importedGuests = [JSONFileImport loadSavedGuestsFromJSON];
  }
  if (importedHotels || importedGuests) {
    [JSONFileImport relateHotels: importedHotels toGuests: importedGuests];
    [JSONFileImport relateGuests: importedGuests toHotels: importedHotels];
    [[CoreDataStack sharedInstance] saveAll];
  }
  [[CoreDataStack sharedInstance] fetchAll];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear: animated];
  
  // TODO - figure out how to release VCs
  self.menuItemsVC = nil;
  self.hotelVC = nil;
  self.roomVC = nil;
  self.guestVC = nil;
  self.reservationVC = nil;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  self.tableView.rowHeight = self.tableView.bounds.size.height / 4;
}
  
//- (void)nslogHotels:(NSArray *)hotels {
//  for (Hotel *hotel in hotels) {
//    for (Room *room in hotel.rooms) {
//      NSLog(@"Hotel %@ room %@", hotel.name, room.number);
//    }
//    for (Reservation *reservation in hotel.reservations) {
//      NSLog(@"Hotel %@ reservation guest %@ arrival %@ departure %@", hotel.name, reservation.guest.lastName, reservation.arrival, reservation.departure);
//    }
//  }
//}

#pragma mark - UITableViewDataSource
  
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"MenuCell" forIndexPath: indexPath];

  UIColor *cellColor = (indexPath.row % 2 == 0) ? [UIColor gold] : [UIColor lightGold];
  cell.backgroundColor = cellColor;
  cell.textLabel.backgroundColor = cellColor;
  cell.textLabel.textColor = [UIColor brownColor];
  cell.textLabel.font = [UIFont systemFontOfSize: 24 weight: 0.1];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textLabel.text = self.menuItems[indexPath.row];
  
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UIViewController *menuItemVC = self.menuItemsVC[indexPath.row];
  [self.navigationController pushViewController: menuItemVC animated: YES];
}

@end
