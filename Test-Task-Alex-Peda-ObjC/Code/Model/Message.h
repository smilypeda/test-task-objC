//
//  Message.h
//  Test-Task-Alex-Peda-ObjC
//
//  Created by Alex Peda on 1/17/16.
//  Copyright © 2016 Alex Peda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (strong, nonatomic, readonly) NSString *idString;
@property (strong, nonatomic, readonly) NSString *text;
@property (strong, nonatomic, readonly) NSString *rawJSON;

- (instancetype)initWithID:(NSString *)ID text:(NSString *)text rawJSON:(NSString *)rawJSON;

@end
