//
//  MessagesService.h
//  Test-Task-Alex-Peda-ObjC
//
//  Created by Alex Peda on 1/17/16.
//  Copyright © 2016 Alex Peda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Message;

@interface MessagesService : NSObject

- (void)loadMessagesWithCompletion:(nullable void (^)(NSArray<Message *>  * _Nullable messages,  NSError * _Nullable error))completion;

@end
