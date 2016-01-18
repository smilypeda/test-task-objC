//
//  MessagesTableViewCell.m
//  Test-Task-Alex-Peda-ObjC
//
//  Created by Alex Peda on 1/17/16.
//  Copyright © 2016 Alex Peda. All rights reserved.
//

#import "MessagesTableViewCell.h"


@interface MessagesTableViewCell ()

@end


@implementation MessagesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupInitialParams];
    }
    return self;
}

- (void)setupInitialParams {
    self.selectedBackgroundView = [UIView new];
    self.selectedBackgroundView.backgroundColor = [UIColor greenColor];
    
    _expandableLabel = [UILabel new];
    self.expandableLabel.numberOfLines = 0;
    self.expandableLabel.font = [UIFont systemFontOfSize:10];
    
    _titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // it's a part of hack to get flexible cell height (http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights)
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.expandableLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.expandableLabel.frame);
    
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [self.contentView removeConstraints:self.titleLabel.constraints];
    [self.contentView removeConstraints:self.expandableLabel.constraints];
    

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_titleLabel]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_titleLabel)]];
    
    NSDictionary *views = @{@"titleLabel": self.titleLabel,
                            @"expandableLabel": self.expandableLabel};
    
    if (self.expanded) {
        
        [self.contentView addSubview:self.expandableLabel];
        self.expandableLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_expandableLabel]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(_expandableLabel)]];
        //code below is a part of hack to get flexible cell height (http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights)
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[titleLabel]-15-[expandableLabel]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        
        [self.expandableLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.expandableLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
    }
    else {

        [self.expandableLabel removeFromSuperview];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[titleLabel]-15-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
}

@end
