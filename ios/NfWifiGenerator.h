#import <Foundation/Foundation.h>

@interface NfWifiGenerator : NSObject
{
@private NSMutableArray* _bytesArray;
}
-(id) initWithSsid: (NSString*) ssid withKey:(NSString*) key;
-(NSArray*) getBytesArray;
@end
