package objd.collection;

import objd.lang.*;

public class ImMapDefault<K, V> extends ImIterable_impl<Tuple<K, V>> {
    public final ImMap<K, V> map;
    public final F<K, V> defaultFunc;
    @Override
    public int count() {
        return this.map.count();
    }
    @Override
    public Iterator<Tuple<K, V>> iterator() {
        return ((Iterator<Tuple<K, V>>)(((Iterator)(this.map.iterator()))));
    }
    public V applyKey(final K key) {
        final V __tmp = this.map.applyKey(key);
        if(__tmp != null) {
            return __tmp;
        } else {
            return this.defaultFunc.apply(key);
        }
    }
    public Iterable<K> keys() {
        return this.map.keys();
    }
    public Iterable<V> values() {
        return this.map.values();
    }
    public boolean containsKey(final K key) {
        return this.map.containsKey(key);
    }
    public boolean isEqualMap(final Map<K, V> map) {
        return this.map.equals(map);
    }
    public boolean isEqualMapDefault(final ImMapDefault<K, V> mapDefault) {
        return this.map.equals(mapDefault.map);
    }
    @Override
    public int hashCode() {
        return this.map.hashCode();
    }
    @Override
    public MMapDefault<K, V> mCopy() {
        return new MMapDefault<K, V>(this.map.mCopy(), this.defaultFunc);
    }
    public ImMapDefault(final ImMap<K, V> map, final F<K, V> defaultFunc) {
        this.map = map;
        this.defaultFunc = defaultFunc;
    }
    public String toString() {
        return String.format("ImMapDefault(%s)", this.map);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null) {
            return false;
        }
        if(to instanceof Map) {
            return isEqualMap(((Map<K, V>)(((Map)(to)))));
        }
        if(to instanceof ImMapDefault) {
            return isEqualMapDefault(((ImMapDefault<K, V>)(((ImMapDefault)(to)))));
        }
        return false;
    }
}