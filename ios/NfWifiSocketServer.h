//
//  NfWifiSocketServer.h
//  UDPdemo
//
//  Created by 陆民 on 16/5/26.
//  Copyright © 2016年 HeMac. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BUFFER_SIZE 64

@interface NfWifiSocketServer : NSObject
{
@private
  Byte _buffer[BUFFER_SIZE];
}

-(id) initWithPort: (int)port;

-(NSData*) receiveSpecLenBytes: (int)len;

-(void) stop;

@end
