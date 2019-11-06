//
//  DYCParam.m
//  DYCModular
//
//  Created by 戴易超 on 2019/10/31.
//

#import "DYCParam.h"

@implementation DYCParam

+ (DYCParam *(^)(void))create {
    return ^DYCParam* (void) {
        return [[DYCParam alloc] init];
    };
}

+ (DYCParam *)creator {
    return self.create();
}


- (DYCParam *(^)(NSString *))name {
    return ^DYCParam* (NSString *name) {
        NSParameterAssert(name);
        self.paramName = name;
        return self;
    };
}

- (DYCParam *)name:(NSString *)name {
    return self.name(name);
}

- (DYCParam *(^)(DYCParamType))type {
    return ^DYCParam* (DYCParamType type) {
        self.paramType = type;
        return self;
    };
}

- (DYCParam *)type:(DYCParamType)type {
    return self.type(type);
}

- (id)formatValue:(id)value {
    switch (self.paramType) {
        case DYCParamTypeNone:
            return value;
        case DYCParamTypeString:
            return [self formatString:value];
        case DYCParamTypeObject:
            return [self formatObject:value];
        case DYCParamTypeArray:
            return [self formatArray:value];
        case DYCParamTypeMap:
            return [self formatDictionary:value];
        case DYCParamTypeNumber:
            return [self formatNumber:value];
        default:
            break;
    }
    return value;
}

- (NSString *)formatString:(id)value {
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    if ([value isKindOfClass:[NSAttributedString class]]) {
        return [(NSAttributedString *)value string];
    }
    return nil;
}

- (NSObject *)formatObject:(id)value {
    if ([value isKindOfClass:[NSObject class]]) {
        return (NSObject *)value;
    }
    return nil;
}

- (NSObject *)formatArray:(id)value {
    if ([value isKindOfClass:[NSArray class]]) {
        return (NSArray *)value;
    }
    return nil;
}
- (NSObject *)formatDictionary:(id)value {
    if ([value isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)value;
    }
    return nil;
}

- (NSObject *)formatNumber:(id)value {
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [[[NSNumberFormatter alloc] init] numberFromString:value];
    }
    return nil;
}


@end
