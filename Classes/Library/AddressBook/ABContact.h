//
//  ABContactor.h
//  QuickContacts
//	联系人对象
//
//  Created by 赵 海波 on 12-8-8.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface ABContact : NSObject {

}

@property (nonatomic, readonly) ABRecordRef record;
@property (nonatomic, readonly) NSString *fullName;			// 全名
@property (nonatomic, readonly) NSString *phoneTic;			// 音标 
@property (nonatomic, readonly) NSString *phoneNumber;		// 第一个电话
@property (nonatomic, readonly) BOOL isOnlyAPhone;			// 判断是否只有一个电话

- (id)initWithRef:(ABRecordRef)ref;

@end
