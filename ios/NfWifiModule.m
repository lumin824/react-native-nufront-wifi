#import "RCTBridgeModule.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import "NfWifiTask.h"

@import SystemConfiguration.CaptiveNetwork;

@interface NfWifiModule: NSObject<RCTBridgeModule>
@property (atomic, strong) NfWifiTask* _task;

@end

@implementation NfWifiModule

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getSSID:(RCTResponseSenderBlock)callback)
{
  NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());

  NSDictionary *SSIDInfo;
  NSString *SSID = @"";

  for (NSString *interfaceName in interfaceNames) {
    SSIDInfo = CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));

    if (SSIDInfo.count > 0) {
      SSID = SSIDInfo[@"SSID"];
      break;
    }
  }
  callback(@[SSID]);
}

RCT_EXPORT_METHOD(startConfig:(NSString *)ssid withKey:(NSString *)key withCallback:(RCTResponseSenderBlock)callback)
{
  if(self._task) [self stopConfig];

  self._task = [[NfWifiTask alloc]initWithSsid:ssid withKey:key];
  [self._task start:^(NSString* evt) {
    callback(@[evt]);
  }];
}

RCT_EXPORT_METHOD(stopConfig)
{
  if(self._task){
    [self._task stop];
    self._task = nil;
  }
}

@end
