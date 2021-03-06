package objd.collection;

import objd.lang.*;

public final class FilledList<T> extends ImList<T> {
    public final T _head;
    public final ImList<T> tail;
    @Override
    public ImList<T> tail() {
        return tail;
    }
    public final int count;
    @Override
    public int count() {
        return count;
    }
    @Override
    public T head() {
        return this._head;
    }
    @Override
    public boolean isEmpty() {
        return false;
    }
    @Override
    public ImList<T> filterF(final F<T, Boolean> f) {
        if(f.apply(this._head)) {
            return ((ImList<T>)(((ImList)(new FilledList<T>(this._head, this.tail.filterF(f))))));
        } else {
            return this.tail.filterF(f);
        }
    }
    @Override
    public ImList<T> reverse() {
        return reverseAndAddList(((ImList<T>)(((ImList)(EmptyList.instance)))));
    }
    private ImList<T> reverseAndAddList(final ImList<T> list) {
        FilledList<T> ret = new FilledList<T>(this._head, list);
        ImList<T> l = this.tail;
        while(!(l.isEmpty())) {
            ret = new FilledList<T>(((FilledList<T>)(((FilledList)(l))))._head, ret);
            l = l.tail();
        }
        return ret;
    }
    @Override
    public void forEach(final P<T> each) {
        FilledList<T> list = this;
        while(true) {
            each.apply(list._head);
            final ImList<T> tail = list.tail;
            if(tail.isEmpty()) {
                return ;
            }
            list = ((FilledList<T>)(((FilledList)(tail))));
        }
    }
    @Override
    public <C extends Comparable<C>> ImList<C> insertItem(final C item) {
        ImList<C> before = ImList.<C>apply();
        FilledList<C> list = ((FilledList<C>)(((FilledList)(this))));
        while(true) {
            final C h = list._head;
            if(item.compareTo(h) < 0) {
                return new FilledList<C>(item, before).reverseAndAddList(list);
            }
            before = ImList.<C>applyItemTail(h, before);
            if(list.tail.isEmpty()) {
                return new FilledList<C>(item, before).reverse();
            }
            list = ((FilledList<C>)(((FilledList)(list.tail))));
        }
    }
    public FilledList(final T _head, final ImList<T> tail) {
        this._head = _head;
        this.tail = tail;
        this.count = tail.count() + 1;
    }
    public String toString() {
        return String.format("FilledList(%s, %s)", this._head, this.tail);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof FilledList)) {
            return false;
        }
        final FilledList<T> o = ((FilledList<T>)(((FilledList)(to))));
        return this._head.equals(o._head) && this.tail.equals(o.tail);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this._head.hashCode();
        hash = hash * 31 + this.tail.hashCode();
        return hash;
    }
}