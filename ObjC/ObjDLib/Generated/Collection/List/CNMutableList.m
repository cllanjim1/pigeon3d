#import "objd.h"
#import "CNMutableList.h"

#import "CNPlatform.h"
#import "CNType.h"
#import "CNString.h"
@implementation CNMList
static CNClassType* _CNMList_type;

+ (instancetype)list {
    return [[CNMList alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) __count = 0;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMList class]) _CNMList_type = [CNClassType classTypeWithCls:[CNMList class]];
}

- (NSUInteger)count {
    return __count;
}

- (id<CNIterator>)iterator {
    CNMListImmutableIterator* i = [CNMListImmutableIterator listImmutableIterator];
    i->_item = _headItem;
    return i;
}

- (id<CNMIterator>)mutableIterator {
    CNMListIterator* i = [CNMListIterator listIteratorWithList:self];
    i->_item = _headItem;
    return i;
}

- (void)insertIndex:(NSUInteger)index item:(id)item {
    if(index == 0) {
        [self prependItem:item];
    } else {
        if(index >= __count) {
            [self appendItem:item];
        } else {
            CNMListItem* c = _headItem;
            NSUInteger i = index;
            while(c != nil && i > 0) {
                c = ((CNMListItem*)(c))->_next;
                i--;
            }
            if(c != nil) {
                CNMListItem* li = [CNMListItem listItemWithData:item];
                {
                    CNMListItem* __tmp_0ff_3t_1 = ((CNMListItem*)(c))->_next;
                    if(__tmp_0ff_3t_1 != nil) ((CNMListItem*)(__tmp_0ff_3t_1))->_prev = li;
                }
                ((CNMListItem*)(c))->_next = li;
            } else {
                [self appendItem:item];
            }
        }
    }
}

- (void)prependItem:(id)item {
    CNMListItem* i = [CNMListItem listItemWithData:item];
    if(_headItem == nil) {
        _headItem = i;
        _lastItem = i;
        __count = 1;
    } else {
        i->_next = ((CNMListItem*)(_headItem));
        ((CNMListItem*)(_headItem))->_prev = i;
        _headItem = i;
        __count++;
    }
}

- (void)appendItem:(id)item {
    CNMListItem* i = [CNMListItem listItemWithData:item];
    if(_lastItem == nil) {
        _headItem = i;
        _lastItem = i;
        __count = 1;
    } else {
        i->_prev = ((CNMListItem*)(_lastItem));
        ((CNMListItem*)(_lastItem))->_next = i;
        _lastItem = i;
        __count++;
    }
}

- (void)removeListItem:(CNMListItem*)listItem {
    if(_headItem != nil && [_headItem isEqual:listItem]) {
        _headItem = ((CNMListItem*)(_headItem))->_next;
        ((CNMListItem*)(_headItem))->_prev = nil;
    } else {
        if(_lastItem != nil && [_lastItem isEqual:listItem]) {
            _lastItem = ((CNMListItem*)(_lastItem))->_prev;
            ((CNMListItem*)(_lastItem))->_next = nil;
        } else {
            {
                CNMListItem* __tmp_0ff_0 = listItem->_prev;
                if(__tmp_0ff_0 != nil) ((CNMListItem*)(__tmp_0ff_0))->_next = listItem->_next;
            }
            {
                CNMListItem* __tmp_0ff_1 = listItem->_next;
                if(__tmp_0ff_1 != nil) ((CNMListItem*)(__tmp_0ff_1))->_prev = listItem->_prev;
            }
        }
    }
    __count--;
}

- (void)clear {
    _headItem = nil;
    _lastItem = nil;
}

- (void)removeHead {
    CNMListItem* _ = _headItem;
    if(_ != nil) [self removeListItem:_];
}

- (void)removeLast {
    CNMListItem* _ = _lastItem;
    if(_ != nil) [self removeListItem:_];
}

- (id)takeHead {
    CNMListItem* h = _headItem;
    if(h != nil) {
        id r = ((CNMListItem*)(h))->_data;
        [self removeListItem:h];
        return r;
    } else {
        return nil;
    }
}

- (id)last {
    return ((CNMListItem*)(_lastItem)).data;
}

- (id)takeLast {
    CNMListItem* h = _lastItem;
    if(h != nil) {
        id r = ((CNMListItem*)(h))->_data;
        [self removeListItem:h];
        return r;
    } else {
        return nil;
    }
}

- (void)forEach:(void(^)(id))each {
    CNMListItem* i = _headItem;
    while(i != nil) {
        each(((CNMListItem*)(i))->_data);
        i = ((CNMListItem*)(i))->_next;
    }
}

- (CNGoR)goOn:(CNGoR(^)(id))on {
    CNMListItem* i = _headItem;
    while(i != nil) {
        if(on(((CNMListItem*)(i))->_data) == CNGo_Break) return CNGo_Break;
        i = ((CNMListItem*)(i))->_next;
    }
    return CNGo_Continue;
}

- (void)mutableFilterBy:(BOOL(^)(id))by {
    CNMListItem* i = _headItem;
    while(i != nil) {
        if(!(by(((CNMListItem*)(i))->_data))) [self removeListItem:i];
        i = ((CNMListItem*)(i))->_next;
    }
}

- (id)head {
    return ((CNMListItem*)(_headItem)).data;
}

- (NSString*)description {
    return @"MList";
}

- (CNClassType*)type {
    return [CNMList type];
}

+ (CNClassType*)type {
    return _CNMList_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation CNMListItem
static CNClassType* _CNMListItem_type;
@synthesize data = _data;
@synthesize next = _next;
@synthesize prev = _prev;

+ (instancetype)listItemWithData:(id)data {
    return [[CNMListItem alloc] initWithData:data];
}

- (instancetype)initWithData:(id)data {
    self = [super init];
    if(self) _data = data;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMListItem class]) _CNMListItem_type = [CNClassType classTypeWithCls:[CNMListItem class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MListItem(%@)", _data];
}

- (CNClassType*)type {
    return [CNMListItem type];
}

+ (CNClassType*)type {
    return _CNMListItem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation CNMListIterator
static CNClassType* _CNMListIterator_type;
@synthesize list = _list;
@synthesize item = _item;

+ (instancetype)listIteratorWithList:(CNMList*)list {
    return [[CNMListIterator alloc] initWithList:list];
}

- (instancetype)initWithList:(CNMList*)list {
    self = [super init];
    if(self) _list = list;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMListIterator class]) _CNMListIterator_type = [CNClassType classTypeWithCls:[CNMListIterator class]];
}

- (BOOL)hasNext {
    return _item != nil;
}

- (id)next {
    CNMListItem* p = ((CNMListItem*)(nonnil(_item)));
    _item = p->_next;
    _prev = p;
    return p->_data;
}

- (void)remove {
    [_list removeListItem:((CNMListItem*)(nonnil(_prev)))];
}

- (void)setValue:(id)value {
    ((CNMListItem*)(nonnil(_prev)))->_data = value;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MListIterator(%@)", _list];
}

- (CNClassType*)type {
    return [CNMListIterator type];
}

+ (CNClassType*)type {
    return _CNMListIterator_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation CNMListImmutableIterator
static CNClassType* _CNMListImmutableIterator_type;
@synthesize item = _item;

+ (instancetype)listImmutableIterator {
    return [[CNMListImmutableIterator alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMListImmutableIterator class]) _CNMListImmutableIterator_type = [CNClassType classTypeWithCls:[CNMListImmutableIterator class]];
}

- (BOOL)hasNext {
    return _item != nil;
}

- (id)next {
    CNMListItem* r = ((CNMListItem*)(nonnil(_item)));
    _item = r->_next;
    return r->_data;
}

- (NSString*)description {
    return @"MListImmutableIterator";
}

- (CNClassType*)type {
    return [CNMListImmutableIterator type];
}

+ (CNClassType*)type {
    return _CNMListImmutableIterator_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

