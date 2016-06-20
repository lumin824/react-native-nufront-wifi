//
//  NfWifiSocketClient.h
//  UDPdemo
//
//  Created by 陆民 on 16/5/26.
//  Copyright © 2016年 HeMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NfWifiSocketClient : NSObject

-(void) sendDataWithBytesArray:(NSArray*) bytesArray
                    withTarget:(NSString*) target withPort:(int)port withInterval:(long) interval;

-(void) sendDataWithBytesArray:(NSArray*) bytesArray withOffset:(NSUInteger) offset withCount:(NSUInteger)count
                    withTarget:(NSString*) target withPort:(int)port withInterval:(long) interval;

-(void) stop;

@end
