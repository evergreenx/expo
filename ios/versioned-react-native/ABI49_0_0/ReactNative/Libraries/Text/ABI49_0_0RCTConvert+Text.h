/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI49_0_0React/ABI49_0_0RCTConvert.h>

#import "ABI49_0_0RCTTextTransform.h"

NS_ASSUME_NONNULL_BEGIN

@interface ABI49_0_0RCTConvert (Text)

+ (UITextAutocorrectionType)UITextAutocorrectionType:(nullable id)json;
+ (UITextSpellCheckingType)UITextSpellCheckingType:(nullable id)json;
+ (ABI49_0_0RCTTextTransform)ABI49_0_0RCTTextTransform:(nullable id)json;

@end

NS_ASSUME_NONNULL_END
