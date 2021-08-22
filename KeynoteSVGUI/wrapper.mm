#import "wrapper.h"
#include "keynote.hpp"

@implementation CPP_Wrapper


- (NSData *) generateClipboardForTSPNativeData: (NSString*) filePath {
    std::string stddata([filePath UTF8String]);
    std::string response = generateTSPNativeDataClipboardFromSVG(stddata);
    return [[NSData alloc] initWithBytes:response.data() length:response.length()];
}

- (NSData *) generateClipboardMetadata {
    std::string response = generateTSPNativeMetadataClipboard();
    return [[NSData alloc] initWithBytes:response.data() length:response.length()];
}


- (NSData *) decodeAndEncodeClip: (NSData*) data {
    std::string str = std::string((char* )data.bytes, (int)data.length);
    std::string response = decodeAndEncode(str);
    return [[NSData alloc] initWithBytes:response.data() length:response.length()];
}
@end
