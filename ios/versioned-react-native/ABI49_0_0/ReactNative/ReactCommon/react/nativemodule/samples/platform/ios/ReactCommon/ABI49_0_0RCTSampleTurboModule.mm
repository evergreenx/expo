/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI49_0_0RCTSampleTurboModule.h"

#import <ABI49_0_0React/ABI49_0_0RCTUtils.h>
#import <UIKit/UIKit.h>

using namespace ABI49_0_0facebook::ABI49_0_0React;

@implementation ABI49_0_0RCTSampleTurboModule

// Backward-compatible export
ABI49_0_0RCT_EXPORT_MODULE()

// Backward-compatible queue configuration
+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

- (std::shared_ptr<ABI49_0_0facebook::ABI49_0_0React::TurboModule>)getTurboModule:
    (const ABI49_0_0facebook::ABI49_0_0React::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<NativeSampleTurboModuleSpecJSI>(params);
}

// Backward compatible invalidation
- (void)invalidate
{
  // Actually do nothing here.
  NSLog(@"Invalidating ABI49_0_0RCTSampleTurboModule...");
}

- (NSDictionary *)getConstants
{
  __block NSDictionary *constants;
  ABI49_0_0RCTUnsafeExecuteOnMainQueueSync(^{
    UIScreen *mainScreen = UIScreen.mainScreen;
    CGSize screenSize = mainScreen.bounds.size;

    constants = @{
      @"const1" : @YES,
      @"const2" : @(screenSize.width),
      @"const3" : @"something",
    };
  });

  return constants;
}

// TODO: Remove once fully migrated to TurboModule.
- (NSDictionary *)constantsToExport
{
  return [self getConstants];
}

ABI49_0_0RCT_EXPORT_METHOD(voidFunc)
{
  // Nothing to do
}

ABI49_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, getBool : (BOOL)arg)
{
  return @(arg);
}

ABI49_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, getEnum : (double)arg)
{
  return @(arg);
}

ABI49_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, getNumber : (double)arg)
{
  return @(arg);
}

ABI49_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSString *, getString : (NSString *)arg)
{
  return arg;
}

ABI49_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSArray<id<NSObject>> *, getArray : (NSArray *)arg)
{
  return arg;
}

ABI49_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSDictionary *, getObject : (NSDictionary *)arg)
{
  return arg;
}

ABI49_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSDictionary *, getUnsafeObject : (NSDictionary *)arg)
{
  return arg;
}

ABI49_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSNumber *, getRootTag : (double)arg)
{
  return @(arg);
}

ABI49_0_0RCT_EXPORT_SYNCHRONOUS_TYPED_METHOD(NSDictionary *, getValue : (double)x y : (NSString *)y z : (NSDictionary *)z)
{
  return @{
    @"x" : @(x),
    @"y" : y ?: [NSNull null],
    @"z" : z ?: [NSNull null],
  };
}

ABI49_0_0RCT_EXPORT_METHOD(getValueWithCallback : (ABI49_0_0RCTResponseSenderBlock)callback)
{
  if (!callback) {
    return;
  }
  callback(@[ @"value from callback!" ]);
}

ABI49_0_0RCT_EXPORT_METHOD(getValueWithPromise
                  : (BOOL)error resolve
                  : (ABI49_0_0RCTPromiseResolveBlock)resolve reject
                  : (ABI49_0_0RCTPromiseRejectBlock)reject)
{
  if (!resolve || !reject) {
    return;
  }

  if (error) {
    reject(
        @"code_1",
        @"intentional promise rejection",
        [NSError errorWithDomain:@"ABI49_0_0RCTSampleTurboModule" code:1 userInfo:nil]);
  } else {
    resolve(@"result!");
  }
}

@end
