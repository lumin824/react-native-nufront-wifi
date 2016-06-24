//
//  NfWifiSocketServer.m
//  UDPdemo
//
//  Created by 陆民 on 16/5/26.
//  Copyright © 2016年 HeMac. All rights reserved.
//

#import "NfWifiSocketServer.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@interface NfWifiSocketServer()

@property(nonatomic, assign) int _socket;
@property(nonatomic, assign) volatile BOOL _isClosed;
@property(nonatomic, strong) volatile NSLock* _lock;

@end

@implementation NfWifiSocketServer

-(id) initWithPort:(int)port
{
  self = [super init];
  if(self){
    self._lock =[[NSLock alloc]init];
    self._isClosed = NO;
    self._socket = socket(AF_INET, SOCK_DGRAM, 0);

    struct sockaddr_in server_addr;
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);
    server_addr.sin_addr.s_addr = INADDR_ANY;

    if(bind(self._socket, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0)
    {
      NSLog(@"bind error");
    }
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
    self._isClosed = true;
  }
  [self._lock unlock];
}

-(NSData*) receiveSpecLenBytes: (int)len
{
  ssize_t recvLen = recv(self._socket, _buffer, BUFFER_SIZE, 0);
  if(recvLen >= len) return [[NSData alloc]initWithBytes:_buffer length:recvLen];
  return nil;
}

-(void) stop
{
  [self close];
}

@end
