//
//  MainViewController.m
//  Test-Task-Alex-Peda-ObjC
//
//  Created by Alex Peda on 1/17/16.
//  Copyright © 2016 Alex Peda. All rights reserved.
//

#import "MainViewController.h"

#import "MessagesTableViewCell.h"
#import "MessagesService.h"
#import "Message.h"

#import <ECSlidingViewController/UIViewController+ECSlidingViewController.h>
#import <MBProgressHUD/MBProgressHUD.h>

NSString *const kMessagesTableViewCellID = @"MessagesTableViewCellID";
CGFloat const kTextPanelHeight = 200.0;


@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *textPanelView;

@property (strong, nonatomic) NSLayoutConstraint *textPanelHeigthConstraint;

@property (strong, nonatomic) NSArray<Message *> *messages;
@property (assign, nonatomic) NSInteger expandedRowIndex;

@end


@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.expandedRowIndex = NSIntegerMax;
    self.navigationItem.title = NSLocalizedString(@"Messages", comment: "");
    
    // Bar button items
    UIBarButtonItem * lefItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(leftItemPressed:)];
    self.navigationItem.leftBarButtonItem = lefItem;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(rightItemPressed:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // Table view
    self.tableView = [UITableView new];
    [self.tableView registerClass:[MessagesTableViewCell class] forCellReuseIdentifier:kMessagesTableViewCellID];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_tableView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_tableView)]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    // Text Panel View
    self.textPanelView = [UILabel new];
    self.textPanelView.backgroundColor = [UIColor lightGrayColor];
    self.textPanelView.numberOfLines = 0;
    self.textPanelView.hidden = YES;
    self.textPanelView.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.textPanelView];
    self.textPanelView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_textPanelView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_textPanelView)]];
    
    
    // Common constraints
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.textPanelView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textPanelView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    self.textPanelHeigthConstraint = [NSLayoutConstraint constraintWithItem:self.textPanelView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:0.0];
    [self.view addConstraint:self.textPanelHeigthConstraint];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // added next code to viewDidAppear just show the progress even on a fast network
    if (self.messages == nil) {
        //SwiftSpinner.show(NSLocalizedString("Messages", comment: "")
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[MessagesService new] loadMessagesWithCompletion:^(NSArray * _Nullable messages, NSError * _Nullable error) {
            if (error == nil) {
                self.messages = messages;
                [self.tableView reloadData];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

#pragma mark - Actions

- (void)leftItemPressed:(id)sender {
    ECSlidingViewController *slidingViewController = [self slidingViewController];
    if ([self slidingViewController].currentTopViewPosition != ECSlidingViewControllerTopViewPositionCentered) {
        [slidingViewController resetTopViewAnimated:YES];
    }
    else {
        [slidingViewController anchorTopViewToRightAnimated:YES];
    }
}

- (void)rightItemPressed:(id)sender {
    UIViewController *viewController = [UIViewController new];
    viewController.title = NSLocalizedString(@"Empty Screen", comment: @"");
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessagesTableViewCell *cell = (MessagesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kMessagesTableViewCellID];
    [self fillTableCell:cell forIndexPath:indexPath];
    
    // next two line are the part of hack to get flexible cell height (http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights)
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // code below is a part of hack to get flexible cell height (http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights)
    MessagesTableViewCell *cell = (MessagesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kMessagesTableViewCellID];
    [self fillTableCell:cell forIndexPath:indexPath];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    cell.bounds = CGRectMake(0.0, 0.0, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // Get the actual height required for the cell
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    height += 1;
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.row];
    self.textPanelView.text = message.text;
    [self updateExpandedRowWithIndexPath:indexPath];
    [self reloadTableAndScrollToIndexPath:indexPath];
}

#pragma mark -

- (void)showTextPanelAnimated:(BOOL)show {
    if (show) {
        self.textPanelView.hidden = NO;
    }
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.textPanelHeigthConstraint.constant = show ? kTextPanelHeight : 0.0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (!show) {
            self.textPanelView.hidden = YES;
        }
    }];
}

- (void)updateExpandedRowWithIndexPath:(NSIndexPath *)indexPath {
    if (self.expandedRowIndex == indexPath.row) {
        self.expandedRowIndex = NSIntegerMax;
        [self showTextPanelAnimated:NO];
    }
    else {
        self.expandedRowIndex = indexPath.row;
        [self showTextPanelAnimated:YES];
    }
}

- (void)reloadTableAndScrollToIndexPath:(NSIndexPath *)indexPath {
    [UIView transitionWithView:self.tableView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } completion:^(BOOL finished) {
        // ensure that cell will be visible after expanding
        CGRect selectedCellRect = [self.tableView rectForRowAtIndexPath:indexPath];
        if (CGRectContainsRect(self.tableView.bounds, selectedCellRect)) {
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }];
}

- (void)fillTableCell:(MessagesTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.messages[indexPath.row];
    cell.titleLabel.text = message.idString;
    cell.expandableLabel.text = message.rawJSON;
    cell.expanded = (indexPath.row == self.expandedRowIndex);
}

@end
