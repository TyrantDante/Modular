//
//  DYCURL.m
//  DYCModular
//
//  Created by 戴易超 on 2019/10/31.
//

#import "DYCURL.h"
#define kDYCModularQueryMarkAnd     @"&"
#define kDYCModularQueryMarkEqual   @"="
#define kDYCModularObjectRegex @"\\w+\\[(.*?)\\]"
#define kDYCModularRegex @"\\[(.*?)\\]"
@interface DYCURL()
@property (nonatomic, strong) NSString *module_action;
@property (nonatomic, strong) NSDictionary *module_param;
@property (nonatomic, strong) NSArray<NSString *>* module_names;
@property (nonatomic, copy) NSString *module_method;
@end
@implementation DYCURL

- (instancetype)initWithString:(NSString *)URLString {
   if (self = [super initWithString:URLString]) {
      self.module_names = [self _analyzePath];
      self.module_param = [self _analyzeQuery];
      self.module_method = [[self host] copy];
   }
   return self;
}

- (NSArray<NSString *> *)_analyzePath {
   NSMutableArray<NSString *> *pathComponents = [self.pathComponents mutableCopy];
   if (pathComponents.count > 1) {
      [pathComponents removeObjectAtIndex:0];
   }
   return [pathComponents copy];
}

- (NSDictionary*)_analyzeQuery {
   
   NSArray<NSString *> *paramArray = [self.query componentsSeparatedByString:kDYCModularQueryMarkAnd];
   
   NSMutableDictionary *param = [NSMutableDictionary dictionary];
   
   [paramArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSArray<NSString *> *queryKV = [obj componentsSeparatedByString:kDYCModularQueryMarkEqual];
      
      if (queryKV.count != 2) {
         return;
      }
      
      NSString *key = [queryKV firstObject];
      key = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      
      NSString *value = [queryKV lastObject];
      value = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      
      BOOL isSpecialObj = [self isValidateSpecialObject:key];
      if (!isSpecialObj) {
         [param setObject:value forKey:key];
         return;
      }
      
      NSArray *subKeys = [self matchString:key toRegexString:kDYCModularRegex];
      __block NSString *parentKey = [key substringWithRange:NSMakeRange(0, [key rangeOfString:[subKeys firstObject]].location)];
      __block id targetObj = param[parentKey];
      __block id parentObj = param;
      
      [subKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         NSString *subKeyStr = [[obj stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
         
         if (!subKeyStr.length) {
            if (!targetObj) {
               targetObj = [NSMutableArray array];
               [parentObj setValue:targetObj forKey:parentKey];
            }
            [targetObj addObject:value];
            *stop = YES;
         } else {
            if (!targetObj) {
               targetObj = [NSMutableDictionary dictionary];
               [parentObj setValue:targetObj forKey:parentKey];
            }
            
            parentObj = targetObj;
            targetObj = targetObj[subKeyStr];
            
            if (idx == subKeys.count - 1) {
               [parentObj setObject:value forKey:subKeyStr];
            }
         }
         parentKey = subKeyStr;
      }];
   }];
   return [param copy];
}


- (BOOL)isValidateSpecialObject:(NSString *)objectKey {
   NSString *objectRegex = kDYCModularObjectRegex;
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", objectRegex];
   return [predicate evaluateWithObject:objectKey];
}


- (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr {
   NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
   NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
   NSMutableArray *array = [NSMutableArray array];
   
   for (NSTextCheckingResult *match in matches) {
      
      NSString *component = [string substringWithRange:[match range]];
      [array addObject:component];
   }
   
   return [array copy];
}

@end
