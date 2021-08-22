#import <Foundation/Foundation.h>

@interface CPP_Wrapper : NSObject
- (NSData *) generateClipboardForTSPNativeData: (NSString*)filePath;
- (NSData *) generateClipboardMetadata;
- (NSData *) decodeAndEncodeClip: (NSData*) data;
@end
