// Public header for jiggle
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Jiggle : NSObject

// Vibrate for duration in milliseconds
- (void)vibrate:(NSNumber *)duration;

// Simple test method
@end

NS_ASSUME_NONNULL_END
