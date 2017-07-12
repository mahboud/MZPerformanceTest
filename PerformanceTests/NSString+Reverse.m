//
//  NSString+Reverse.m
//  PerformanceTests
//
//  Created by mahboud on 7/12/17.
//  Copyright © 2017 Optimized. All rights reserved.
//

#import "NSString+Reverse.h"

@implementation NSString (Reverse)
- (NSString *)reverse01 {
  NSUInteger length = [self length];
  unichar *buffer = malloc(length * sizeof(unichar));
  if (buffer == nil) return nil; // error!
  [self getCharacters:buffer];

  // reverse string; only need to loop through first half
  for (NSUInteger startPosition = 0, endPosition = length - 1; startPosition < length / 2; startPosition++, endPosition--) {

    buffer[startPosition] ^= buffer[endPosition];
    buffer[endPosition] ^= buffer[startPosition];
    buffer[startPosition] ^= buffer[endPosition];
  }

  return [[NSString alloc] initWithCharactersNoCopy:buffer length:length freeWhenDone:YES];
}

- (NSString *)reverse0 {
  NSUInteger len = [self length];
  unichar *buffer = malloc(len * sizeof(unichar));
  if (buffer == nil) return nil; // error!
  [self getCharacters:buffer];

  // reverse string; only need to loop through first half
  for (NSUInteger startPosition = 0, endPosition = len - 1; startPosition  < len / 2; startPosition ++, endPosition--) {
    unichar tempChar = buffer[startPosition];
    buffer[startPosition] = buffer[endPosition];
    buffer[endPosition] = tempChar;
  }

  return [[NSString alloc] initWithCharactersNoCopy:buffer length:len freeWhenDone:YES];
}

- (NSString *)reverse1 {
  NSUInteger length = self.length;
  NSMutableString *result = [[NSMutableString alloc] initWithCapacity:length];
  for (NSUInteger i = length; i > 0; i--) {
    [result appendString: [self substringWithRange:NSMakeRange(i - 1, 1)]];

  }
  return result;
}

- (NSString *)reverse2 {
  NSMutableString *reversedString = [NSMutableString stringWithCapacity:[self length]];

  [self enumerateSubstringsInRange:NSMakeRange(0,[self length])
                           options:(NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences)
                        usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                          [reversedString appendString:substring];
                        }];
  return reversedString;
}

- (NSString *)reverse5 {
  NSUInteger len = [self length];
  NSMutableString *result = [[NSMutableString alloc] initWithCapacity:len];
  for (NSUInteger i = len; i > 0; i--) {
    [result appendFormat:@"%c", [self characterAtIndex:i - 1]];
  }
  return result;
}

- (NSString *)reverse4 {
  NSUInteger length = self.length;
  NSMutableArray *letterArray = [NSMutableArray arrayWithCapacity:length];
  for (NSUInteger i = 0; i < length; i++) {
    [letterArray insertObject:[self substringWithRange:NSMakeRange(i, 1)] atIndex:0];

  }
  return [letterArray componentsJoinedByString:@""];
}


- (NSString *)reverse3 {
  NSUInteger length = self.length;
  NSMutableArray *letterArray = [NSMutableArray arrayWithCapacity:length];
  for (NSUInteger i = length; i > 0; i--) {
    [letterArray addObject:[self substringWithRange:NSMakeRange(i - 1, 1)]];

  }
  return [letterArray componentsJoinedByString:@""];
}
@end

