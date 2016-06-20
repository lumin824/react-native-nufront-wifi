//
//  NfWifiSocketClient.m
//  UDPdemo
//
//  Created by 陆民 on 16/5/26.
//  Copyright © 2016年 HeMac. All rights reserved.
//

#import "NfWifiSocketClient.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@interface NfWifiSocketClient()
@property(nonatomic, assign) int _socket;
@property(nonatomic, assign) volatile BOOL _isClosed;
@property(nonatomic, strong) volatile NSLock* _lock;

@end

@implementation NfWifiSocketClient

-(id) init
{
    self = [super init];
    
    if(self){
        self._socket = socket(AF_INET, SOCK_DGRAM, 0);
    }
    return self;
}

-(void) dealloc
{
    [self close];
}

-(void) close
{
    [self._lock lock];
    if(!self._isClosed){
        close(self._socket);
        self._isClosed = YES;
    }
    [self._lock unlock];
}

-(void) sendDataWithBytesArray:(NSArray*) bytesArray
                    withTarget:(NSString*) target withPort:(int)port withInterval:(long) interval
{
    [self sendDataWithBytesArray:bytesArray withOffset:0 withCount:[bytesArray count] withTarget:target withPort:port withInterval:interval];
}

-(void) sendDataWithBytesArray:(NSArray*) bytesArray withOffset:(NSUInteger) offset withCount:(NSUInteger)count
    withTarget:(NSString*) target withPort:(int)port withInterval:(long) interval
{
    bool isBroadcast = [target isEqualToString:@"255.255.255.255"];
    
    socklen_t addr_len;
    struct sockaddr_in target_addr;
    memset(&target_addr, 0, sizeof(target_addr));
    target_addr.sin_family = AF_INET;
    target_addr.sin_addr.s_addr = inet_addr([target cStringUsingEncoding:NSASCIIStringEncoding]);
    target_addr.sin_port = htons(port);
    addr_len = sizeof(target_addr);
    
    if(isBroadcast){
        const int opt = 1;
        if(setsockopt(self._socket, SOL_SOCKET, SO_BROADCAST, &opt, sizeof(opt)) < 0){
            
        }
    }
    int timeout = 3000;
    setsockopt(self._socket, SOL_SOCKET, SO_SNDTIMEO, &timeout, sizeof(timeout));
    setsockopt(self._socket, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));
    
    for(NSUInteger i = offset; i < offset + count && !self._isClosed; i++){
        NSData* data = [bytesArray objectAtIndex:i];
        NSUInteger dataLen = [data length];
        if(0 == dataLen) continue;
        
        Byte bytes[dataLen];
        
        [data getBytes:bytes length:dataLen];
        
        for(int j = 0; j < 20 && !self._isClosed;j++){
        
            ssize_t error = sendto(self._socket, bytes, dataLen, 0, (struct sockaddr*)&target_addr, addr_len);
            if(error < 0){
                NSLog(@"error:%zu",error);
            }
            usleep(10*1000);
        }
        
        usleep(20*1000);
    }
}

-(void) stop
{
  [self close];
}
@end
