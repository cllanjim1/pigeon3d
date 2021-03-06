#import "CNFuture.h"

#import "CNDispatchQueue.h"
#import "CNAtomic.h"
#import "CNLock.h"
@implementation CNFuture
static CNClassType* _CNFuture_type;

+ (instancetype)future {
    return [[CNFuture alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNFuture class]) _CNFuture_type = [CNClassType classTypeWithCls:[CNFuture class]];
}

+ (CNFuture*)applyF:(id(^)())f {
    CNPromise* p = [CNPromise apply];
    [[CNDispatchQueue aDefault] asyncF:^void() {
        [p successValue:f()];
    }];
    return p;
}

+ (CNFuture*)joinA:(CNFuture*)a b:(CNFuture*)b {
    return [CNFuture mapA:a b:b f:^CNTuple*(id _a, id _b) {
        return tuple(_a, _b);
    }];
}

+ (CNFuture*)joinA:(CNFuture*)a b:(CNFuture*)b c:(CNFuture*)c {
    return [CNFuture mapA:a b:b c:c f:^CNTuple3*(id _a, id _b, id _c) {
        return tuple3(_a, _b, _c);
    }];
}

+ (CNFuture*)joinA:(CNFuture*)a b:(CNFuture*)b c:(CNFuture*)c d:(CNFuture*)d {
    return [CNFuture mapA:a b:b c:c d:d f:^CNTuple4*(id _a, id _b, id _c, id _d) {
        return tuple4(_a, _b, _c, _d);
    }];
}

+ (CNFuture*)joinA:(CNFuture*)a b:(CNFuture*)b c:(CNFuture*)c d:(CNFuture*)d e:(CNFuture*)e {
    return [CNFuture mapA:a b:b c:c d:d e:e f:^CNTuple5*(id _a, id _b, id _c, id _d, id _e) {
        return tuple5(_a, _b, _c, _d, _e);
    }];
}

+ (CNFuture*)mapA:(CNFuture*)a b:(CNFuture*)b f:(id(^)(id, id))f {
    CNPromise* p = [CNPromise apply];
    __block volatile id _a = nil;
    __block volatile id _b = nil;
    CNAtomicInt* n = [CNAtomicInt atomicInt];
    [a onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            _a = [t get];
            if([n incrementAndGet] == 2) [p successValue:f(_a, _b)];
        } else {
            [p completeValue:((CNTry*)(t))];
        }
    }];
    [b onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            _b = [t get];
            if([n incrementAndGet] == 2) [p successValue:f(_a, _b)];
        } else {
            [p completeValue:((CNTry*)(t))];
        }
    }];
    return p;
}

+ (CNFuture*)mapA:(CNFuture*)a b:(CNFuture*)b c:(CNFuture*)c f:(id(^)(id, id, id))f {
    CNPromise* p = [CNPromise apply];
    __block volatile id _a = nil;
    __block volatile id _b = nil;
    __block volatile id _c = nil;
    CNAtomicInt* n = [CNAtomicInt atomicInt];
    [a onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            _a = [t get];
            if([n incrementAndGet] == 3) [p successValue:f(_a, _b, _c)];
        } else {
            [p completeValue:((CNTry*)(t))];
        }
    }];
    [b onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            _b = [t get];
            if([n incrementAndGet] == 3) [p successValue:f(_a, _b, _c)];
        } else {
            [p completeValue:((CNTry*)(t))];
        }
    }];
    [c onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            _c = [t get];
            if([n incrementAndGet] == 3) [p successValue:f(_a, _b, _c)];
        } else {
            [p completeValue:((CNTry*)(t))];
        }
    }];
    return p;
}

+ (CNFuture*)mapA:(CNFuture*)a b:(CNFuture*)b c:(CNFuture*)c d:(CNFuture*)d f:(id(^)(id, id, id, id))f {
    CNPromise* p = [CNPromise apply];
    __block volatile id _a = nil;
    __block volatile id _b = nil;
    __block volatile id _c = nil;
    __block volatile id _d = nil;
    CNAtomicInt* n = [CNAtomicInt atomicInt];
    [a onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            _a = [t get];
            if([n incrementAndGet] == 4) [p successValue:f(_a, _b, _c, _d)];
        } else {
            [p completeValue:((CNTry*)(t))];
        }
    }];
    [b onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            _b = [t get];
            if([n incrementAndGet] == 4) [p successValue:f(_a, _b, _c, _d)];
        } else {
            [p completeValue:((CNTry*)(t))];
        }
    }];
    [c onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            _c = [t get];
            if([n incrementAndGet] == 4) [p successValue:f(_a, _b, _c, _d)];
        } else {
            [p completeValue:((CNTry*)(t))];
        }
    }];
    [d onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            _d = [t get];
            if([n incrementAndGet] == 4) [p successValue:f(_a, _b, _c, _d)];
        } else {
            [p completeValue:((CNTry*)(t))];
        }
    }];
    return p;
}

+ (CNFuture*)mapA:(CNFuture*)a b:(CNFuture*)b c:(CNFuture*)c d:(CNFuture*)d e:(CNFuture*)e f:(id(^)(id, id, id, id, id))f {
    CNPromise* p = [CNPromise apply];
    __block volatile id _a = nil;
    __block volatile id _b = nil;
    __block volatile id _c = nil;
    __block volatile id _d = nil;
    __block volatile id _e = nil;
    CNAtomicInt* n = [CNAtomicInt atomicInt];
    [a onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            _a = [t get];
            if([n incrementAndGet] == 5) [p successValue:f(_a, _b, _c, _d, _e)];
        } else {
            [p completeValue:((CNTry*)(t))];
        }
    }];
    [b onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            _b = [t get];
            if([n incrementAndGet] == 5) [p successValue:f(_a, _b, _c, _d, _e)];
        } else {
            [p completeValue:((CNTry*)(t))];
        }
    }];
    [c onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            _c = [t get];
            if([n incrementAndGet] == 5) [p successValue:f(_a, _b, _c, _d, _e)];
        } else {
            [p completeValue:((CNTry*)(t))];
        }
    }];
    [d onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            _d = [t get];
            if([n incrementAndGet] == 5) [p successValue:f(_a, _b, _c, _d, _e)];
        } else {
            [p completeValue:((CNTry*)(t))];
        }
    }];
    [e onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            _e = [t get];
            if([n incrementAndGet] == 5) [p successValue:f(_a, _b, _c, _d, _e)];
        } else {
            [p completeValue:((CNTry*)(t))];
        }
    }];
    return p;
}

+ (CNFuture*)successfulResult:(id)result {
    return [CNKeptPromise keptPromiseWithValue:[CNSuccess successWithGet:result]];
}

- (CNTry*)result {
    @throw @"Method result is abstract";
}

- (BOOL)isCompleted {
    return [self result] != nil;
}

- (BOOL)isSucceeded {
    CNTry* __tmp = [self result];
    if(__tmp != nil) return [((CNTry*)([self result])) isSuccess];
    else return NO;
}

- (BOOL)isFailed {
    CNTry* __tmp = [self result];
    if(__tmp != nil) return [((CNTry*)([self result])) isFailure];
    else return YES;
}

- (void)onCompleteF:(void(^)(CNTry*))f {
    @throw @"Method onComplete is abstract";
}

- (void)onSuccessF:(void(^)(id))f {
    [self onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) f([t get]);
    }];
}

- (void)onFailureF:(void(^)(id))f {
    [self onCompleteF:^void(CNTry* t) {
        if([t isFailure]) f([t reason]);
    }];
}

- (CNFuture*)mapF:(id(^)(id))f {
    CNPromise* p = [CNPromise apply];
    [self onCompleteF:^void(CNTry* tr) {
        [p completeValue:[tr mapF:f]];
    }];
    return p;
}

- (CNFuture*)forF:(void(^)(id))f {
    CNPromise* p = [CNPromise apply];
    [self onCompleteF:^void(CNTry* tr) {
        if([tr isSuccess]) {
            f([tr get]);
            [p successValue:nil];
        } else {
            [p completeValue:((CNTry*)(tr))];
        }
    }];
    return p;
}

- (CNFuture*)flatMapF:(CNFuture*(^)(id))f {
    CNPromise* p = [CNPromise apply];
    [self onCompleteF:^void(CNTry* tr) {
        if([tr isFailure]) {
            [p completeValue:((CNTry*)(tr))];
        } else {
            CNFuture* fut = f([tr get]);
            [fut onCompleteF:^void(CNTry* ftr) {
                [p completeValue:ftr];
            }];
        }
    }];
    return p;
}

- (CNTry*)waitResultPeriod:(CGFloat)period {
    NSConditionLock* lock = [NSConditionLock conditionLockWithCondition:0];
    [self onCompleteF:^void(CNTry* _) {
        [lock lock];
        [lock unlockWithCondition:1];
    }];
    if([lock lockWhenCondition:1 period:period]) [lock unlock];
    return [self result];
}

- (CNTry*)waitResult {
    NSConditionLock* lock = [NSConditionLock conditionLockWithCondition:0];
    [self onCompleteF:^void(CNTry* _) {
        [lock lock];
        [lock unlockWithCondition:1];
    }];
    [lock lockWhenCondition:1];
    [lock unlock];
    return ((CNTry*)(nonnil([self result])));
}

- (void)waitAndOnSuccessAwait:(CGFloat)await f:(void(^)(id))f {
    CNTry* __tr = [self waitResultPeriod:await];
    if(__tr != nil) {
        if([((CNTry*)(__tr)) isSuccess]) f([((CNTry*)(__tr)) get]);
    }
}

- (void)waitAndOnSuccessFlatAwait:(CGFloat)await f:(void(^)(id))f {
    CNTry* __il__0__tr = [((CNFuture*)(self)) waitResultPeriod:await];
    if(__il__0__tr != nil) {
        if([((CNTry*)(__il__0__tr)) isSuccess]) {
            id<CNTraversable> __tr2 = [((CNTry*)(__il__0__tr)) get];
            [((id<CNTraversable>)(__tr2)) forEach:f];
        }
    }
}

- (id)getResultAwait:(CGFloat)await {
    return [((CNTry*)(nonnil([self waitResultPeriod:await]))) get];
}

- (CNFuture*)joinAnother:(CNFuture*)another {
    CNPromise* p = [CNPromise apply];
    __block volatile id a = nil;
    __block volatile id b = nil;
    CNAtomicInt* n = [CNAtomicInt atomicInt];
    [self onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            a = [t get];
            if([n incrementAndGet] == 2) [p successValue:[CNTuple tupleWithA:a b:b]];
        } else {
            [p completeValue:((CNTry*)(t))];
        }
    }];
    [another onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            b = [t get];
            if([n incrementAndGet] == 2) [p successValue:[CNTuple tupleWithA:a b:b]];
        } else {
            [p completeValue:((CNTry*)(t))];
        }
    }];
    return p;
}

- (NSString*)description {
    return @"Future";
}

- (CNClassType*)type {
    return [CNFuture type];
}

+ (CNClassType*)type {
    return _CNFuture_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation CNPromise
static CNClassType* _CNPromise_type;

+ (instancetype)promise {
    return [[CNPromise alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNPromise class]) _CNPromise_type = [CNClassType classTypeWithCls:[CNPromise class]];
}

+ (CNPromise*)apply {
    return [CNDefaultPromise defaultPromise];
}

- (BOOL)completeValue:(CNTry*)value {
    @throw @"Method complete is abstract";
}

- (BOOL)successValue:(id)value {
    @throw @"Method success is abstract";
}

- (BOOL)failureReason:(id)reason {
    @throw @"Method failure is abstract";
}

- (NSString*)description {
    return @"Promise";
}

- (CNClassType*)type {
    return [CNPromise type];
}

+ (CNClassType*)type {
    return _CNPromise_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation CNDefaultPromise
static CNClassType* _CNDefaultPromise_type;

+ (instancetype)defaultPromise {
    return [[CNDefaultPromise alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) __state = [CNAtomicObject atomicObjectWithValue:(@[])];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNDefaultPromise class]) _CNDefaultPromise_type = [CNClassType classTypeWithCls:[CNDefaultPromise class]];
}

- (CNTry*)result {
    id v = [__state value];
    if([v isKindOfClass:[CNTry class]]) return ((CNTry*)(v));
    else return nil;
}

- (BOOL)completeValue:(CNTry*)value {
    while(YES) {
        id v = [__state value];
        if([v isKindOfClass:[CNTry class]]) {
            return NO;
        } else {
            if([__state compareAndSetOldValue:v newValue:value]) {
                for(void(^f)(CNTry*) in ((NSArray*)(v))) {
                    f(value);
                }
                return YES;
            }
        }
    }
}

- (BOOL)successValue:(id)value {
    return [self completeValue:[CNSuccess successWithGet:value]];
}

- (BOOL)failureReason:(id)reason {
    return [self completeValue:[CNFailure failureWithReason:[self result]]];
}

- (void)onCompleteF:(void(^)(CNTry*))f {
    while(YES) {
        id v = [__state value];
        if([v isKindOfClass:[CNTry class]]) {
            f(((CNTry*)(v)));
            return ;
        } else {
            NSArray* vv = ((NSArray*)(v));
            if([__state compareAndSetOldValue:vv newValue:[vv addItem:f]]) return ;
        }
    }
}

- (NSString*)description {
    return @"DefaultPromise";
}

- (CNClassType*)type {
    return [CNDefaultPromise type];
}

+ (CNClassType*)type {
    return _CNDefaultPromise_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation CNKeptPromise
static CNClassType* _CNKeptPromise_type;
@synthesize value = _value;

+ (instancetype)keptPromiseWithValue:(CNTry*)value {
    return [[CNKeptPromise alloc] initWithValue:value];
}

- (instancetype)initWithValue:(CNTry*)value {
    self = [super init];
    if(self) _value = value;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNKeptPromise class]) _CNKeptPromise_type = [CNClassType classTypeWithCls:[CNKeptPromise class]];
}

- (CNTry*)result {
    return _value;
}

- (void)onCompleteF:(void(^)(CNTry*))f {
    f(_value);
}

- (CNTry*)waitResultPeriod:(CGFloat)period {
    return _value;
}

- (CNTry*)waitResult {
    return _value;
}

- (BOOL)completeValue:(CNTry*)value {
    return NO;
}

- (BOOL)successValue:(id)value {
    return NO;
}

- (BOOL)failureReason:(id)reason {
    return NO;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"KeptPromise(%@)", _value];
}

- (CNClassType*)type {
    return [CNKeptPromise type];
}

+ (CNClassType*)type {
    return _CNKeptPromise_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

