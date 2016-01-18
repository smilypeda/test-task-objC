//
//  MessagesMapper.h
//  Test-Task-Alex-Peda-ObjC
//
//  Created by Alex Peda on 1/17/16.
//  Copyright © 2016 Alex Peda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Message;

@interface MessagesMapper : NSObject

@property (nonatomic, strong, readonly) NSArray<Message *>* messages;
@property (nonatomic, strong, readonly) NSError* error; // to handle parsing cycle errors (not used)

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
