package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.gl.eg;
import android.opengl.GLES20;
import objd.collection.PArray;

public class IBO {
    public static static ImmutableIndexBuffer applyPointerCount(final Pointer pointer, final int count) {
        final ImmutableIndexBuffer ib = new ImmutableIndexBuffer(eg.egGenBuffer(), GLES20.GL_TRIANGLES, ((int)(count * 4)), ((int)(count)));
        ib.bind();
        GLES20.glBufferData(GLES20.GL_ELEMENT_ARRAY_BUFFER, ((long)(count * 4)), pointer, GLES20.GL_STATIC_DRAW);
        return ib;
    }
    public static static ImmutableIndexBuffer applyData(final PArray<Integer> data) {
        final ImmutableIndexBuffer ib = new ImmutableIndexBuffer(eg.egGenBuffer(), GLES20.GL_TRIANGLES, data.length, data.count);
        ib.bind();
        GLES20.glBufferData(GLES20.GL_ELEMENT_ARRAY_BUFFER, ((long)(data.length)), data.bytes, GLES20.GL_STATIC_DRAW);
        return ib;
    }
    public static static MutableIndexBuffer mutModeUsage(final int mode, final int usage) {
        return new MutableIndexBuffer(eg.egGenBuffer(), mode, usage);
    }
    public static static MutableIndexBuffer mutUsage(final int usage) {
        return IBO.mutModeUsage(GLES20.GL_TRIANGLES, usage);
    }
}