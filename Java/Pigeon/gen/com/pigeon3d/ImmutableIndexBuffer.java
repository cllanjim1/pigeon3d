package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.gl;

public class ImmutableIndexBuffer extends Buffer<Integer> implements IndexBuffer {
    public final int mode;
    @Override
    public int mode() {
        return mode;
    }
    public final int length;
    @Override
    public int length() {
        return length;
    }
    public final int count;
    @Override
    public int count() {
        return count;
    }
    @Override
    public void bind() {
        Global.context.bindIndexBufferHandle(this.handle);
    }
    public ImmutableIndexBuffer(final int handle, final int mode, final int length, final int count) {
        super(((PType<Integer>)(((PType)(UInt4.type)))), gl.GL_ELEMENT_ARRAY_BUFFER, handle);
        this.mode = mode;
        this.length = length;
        this.count = count;
    }
    public String toString() {
        return String.format("ImmutableIndexBuffer(%d, %d, %d)", this.mode, this.length, this.count);
    }
    @Override
    public void draw() {
        Global.context.draw();
        final int n = this.count();
        if(n > 0) {
            gl.glDrawElementsModeCountTpIndices(this.mode(), ((int)(n)), gl.GL_UNSIGNED_INT, ERROR: Unknown null<uint4>);
        }
        gl.egCheckError();
    }
    @Override
    public void drawWithStartCount(final int start, final int count) {
        Global.context.draw();
        if(count > 0) {
            gl.glDrawElementsModeCountTpIndices(this.mode(), ((int)(count)), gl.GL_UNSIGNED_INT, ((Pointer)(4 * start)));
        }
        gl.egCheckError();
    }
    public boolean isMutable() {
        return false;
    }
    public boolean isEmpty() {
        return false;
    }
}