//
//  MainViewController.m
//  Test-Task-Alex-Peda-ObjC
//
//  Created by Alex Peda on 1/17/16.
//  Copyright © 2016 Alex Peda. All rights reserved.
//

#import "MainViewController.h"

#import "MessagesTableViewCell.h"
#import "UIViewController+ECSlidingViewController.h"

NSString *const kMessagesTableViewCellID = @"MessagesTableViewCellID";
CGFloat const kTextPanelHeight = 200.0;


@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *textPanelView;

@property (strong, nonatomic) NSLayoutConstraint *textPanelHeigthConstraint;

@property (strong, nonatomic) NSArray *messages;

@end


@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    
//    // added next code to viewDidAppear just show the progress even on a fast network
//    if messages.count == 0 {
//        SwiftSpinner.show(NSLocalizedString("Messages", comment: ""))
//        MessagesService().loadMessages { (messages: [Message]?) -> () in
//            if let validMessages = messages {
//                self.messages = validMessages
//                self.tableView.reloadData()
//            }
//            SwiftSpinner.hide()
//        }
//    }
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        MessagesTableViewCell *cell = (MessagesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kMessagesTableViewCellID];
    
//    cell.expanded = (indexPath.row == expandedRow)
//    
//    let message = messages[indexPath.row]
//    cell.titleLabel.text = message.id
//    cell.expandableLabel.text = message.rawJSON
//    
//    // it's a part of hack to get flexible cell height (http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights)
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}


@end
