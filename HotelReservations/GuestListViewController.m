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
#import "AppDelegate.h"
#import "CoreDataStack.h"

static const CGFloat kTableViewEstimatedRowHeight = 44;
static const CGFloat kTextViewSpacerHeight = 7;
static const CGFloat kTextViewHeight = 100;       // could not get textView to resize

@interface GuestListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView* tableViewSpacer;
@property (strong, nonatomic) NSArray *tableViewSpacerConstraints;

@property (nonatomic) NSInteger selectedGuestIndex;

@end

@implementation GuestListViewController

#pragma mark - Private Property Getters, Setters

- (UIView *)textView {
  if (!_textView) {
    _textView = [[UITextView alloc] init];
    _textView.editable = NO;
    _textView.selectable = NO;
    _textView.scrollEnabled = NO;
    _textView.backgroundColor = [UIColor almond];
  }
  return _textView;
}

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
    _tableView.allowsSelection = YES;
    _tableView.estimatedRowHeight = kTableViewEstimatedRowHeight;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = [UIColor vanDykeBrown];
  }
  return _tableView;
}

#pragma mark - Life Cycle Methods

- (void)loadView {
  
  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor vanDykeBrown];
  
  [self createConstraintsAndViewsForSuperView: rootView];
  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  self.navigationItem.title = [ViewUtility menuItemGuests];
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.tableView registerClass: [TableViewCell class] forCellReuseIdentifier: @"TableCell"];
  
  if ([[CoreDataStack sharedInstance] fetchGuestCount] > 0) {
    [[CoreDataStack sharedInstance] fetchGuestsAscendingOnKeys: @[@"lastName",@"firstName"]];
    self.selectedGuest = [CoreDataStack sharedInstance].savedGuests.firstObject;
  }
  [self updateUI];
}

#pragma mark - Helper Methods

- (void) createConstraintsAndViewsForSuperView:(UIView *)rootView {
  
  UIView* topSpacerView = [[UIView alloc] init];
  topSpacerView.backgroundColor = [UIColor gold];
  self.tableViewSpacer = [[UIView alloc] init];
  self.tableViewSpacer.backgroundColor = [UIColor gold];
  
  [topSpacerView addToSuperViewWithConstraints: rootView withViewAbove: nil height: kTextViewSpacerHeight topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [self.textView addToSuperViewWithConstraints: rootView withViewAbove: topSpacerView height: kTextViewHeight topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  
  self.tableViewSpacerConstraints = [self.tableViewSpacer addToSuperViewWithConstraints: rootView withViewAbove: self.textView height: kTextViewSpacerHeight topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
  [self.tableView addToSuperViewWithConstraints: rootView withViewAbove: self.tableViewSpacer height: 0 topSpacing: 0 bottomSpacing: 0 width: 0 leadingSpacing: 0 trailingSpacing: 0];
}

- (void) updateUI {
  [self updateTextView];
  [self updateTableView];
}
- (void) updateTextView {
  AttributedString *atString = [[AttributedString alloc] init];
  
  [atString assignHeadline: self.selectedGuest.firstName withPlaceholder: nil withSelector: nil];
  [atString assignHeadline2: self.selectedGuest.lastName withSelector: nil];
  [atString assignSubheadline: self.selectedGuest.city withPlaceholder: nil withSelector: nil];
  [atString assignSubheadline2: self.selectedGuest.state withSelector: nil];
  [atString assignFootnote: [ViewUtility reservationCount: self.selectedGuest.reservations.count] withSelector: nil];
  
  self.textView.attributedText = [atString hypertextStringWithColor: [UIColor vanDykeBrown]];
}
- (void) updateTableView {
  [self.tableView reloadData];
}

#pragma mark - Selector Methods

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [CoreDataStack sharedInstance].savedGuests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  TableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"TableCell" forIndexPath: indexPath];
  AttributedString *atString = [[AttributedString alloc] init];
  Guest* guest = [CoreDataStack sharedInstance].savedGuests[indexPath.row];
  
  [atString assignHeadline: [ViewUtility nameWithLast: guest.lastName first: guest.firstName] withPlaceholder: nil withSelector: nil];
  [atString assignFootnote: guest.city withSelector: nil];
  [atString assignFootnote2: guest.state withSelector: nil];
  
  cell.textView.backgroundColor = [UIColor almond];
  cell.borderColor = [UIColor vanDykeBrown];
  cell.textView.attributedText = [atString hypertextStringWithColor: [UIColor vanDykeBrown]];
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  self.selectedGuest = [CoreDataStack sharedInstance].savedGuests[indexPath.row];
  [tableView deselectRowAtIndexPath: indexPath animated: NO];
  self.selectedGuestIndex = indexPath.row;
  [self updateTextView];
}

@end
