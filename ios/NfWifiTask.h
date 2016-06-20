
#import <Foundation/Foundation.h>

@interface NfWifiTask : NSObject
- (id) initWithSsid: (NSString*) ssid withKey:(NSString*) key;

- (void) start:(void(^)(NSString* evt))callback;

- (void) stop;
@end