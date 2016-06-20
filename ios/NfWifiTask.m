
#import "NfWifiTask.h"

#import "NfWifiSocketServer.h"
#import "NfWifiSocketClient.h"
#import "NfWifiGenerator.h"

@interface NfWifiTask()

@property(nonatomic, strong) NSString* _ssid;
@property(nonatomic, strong) NSString* _key;
@property(nonatomic, strong) NfWifiSocketClient* _client;
@property(nonatomic, strong) NfWifiSocketServer* _server;
@property(nonatomic, assign) volatile BOOL _isClosed;
@property(nonatomic, copy) void (^_callback)(NSString* evt);

@end

@implementation NfWifiTask

-(id) initWithSsid: (NSString*) ssid withKey:(NSString*) key {
    
    self = [super init];
    
    if(self){
        self._ssid = ssid;
        self._key = key;
        self._client = [[NfWifiSocketClient alloc] init];
        self._server = [[NfWifiSocketServer alloc] initWithPort:60002];
    }
    
    return self;
}

-(void)start:(void(^)(NSString* evt))callback;
{
  self._callback = callback;
  self._isClosed = false;
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_async(queue, ^{
    //Byte receiveOneByte = -1;
    Byte receiveAll[24];
    while(!self._isClosed){
      NSData* receiveData = [self._server receiveSpecLenBytes:24];
      
      if(receiveData){
        [receiveData getBytes:receiveAll length: 24];
        
        if(receiveAll[0] == 0x18
           && receiveAll[8] == 0x06 && receiveAll[9] == 0x00
           && receiveAll[10] == 0x01){
          
          NSString * deviceId = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", receiveAll[11], receiveAll[12], receiveAll[13], receiveAll[14], receiveAll[15], receiveAll[16] ];
          self._callback(deviceId);
        }
      }else
      {
        break;
      }
    }
  });
  
  dispatch_async(queue, ^{
    NfWifiGenerator* generator = [[NfWifiGenerator alloc]initWithSsid:self._ssid withKey:self._key];
    NSArray* bytesArray = [generator getBytesArray];
    while(!self._isClosed){
      [self._client sendDataWithBytesArray:bytesArray withTarget:@"239.1.2.110" withPort:60001 withInterval:1];
    }
    
  });
}

- (void) stop
{
  self._isClosed = true;
  if(self._server){
    [self._server stop];
  }
  
  if(self._client){
    [self._client stop];
  }
}

@end
