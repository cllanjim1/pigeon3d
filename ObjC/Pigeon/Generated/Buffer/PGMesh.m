#import "PGMesh.h"

#import "PGMat4.h"
#import "PGVertex.h"
#import "PGIndex.h"
#import "PGVertexArray.h"
#import "PGShader.h"
#import "PGShadow.h"
#import "PGMaterial.h"
#import "PGPlatformPlat.h"
#import "PGPlatform.h"
#import "PGContext.h"
#import "CNChain.h"
#import "GL.h"
#import "PGMatrixModel.h"
PGMeshData pgMeshDataMulMat4(PGMeshData self, PGMat4* mat4) {
    return PGMeshDataMake(self.uv, (pgVec4Xyz(([mat4 mulVec4:pgVec4ApplyVec3W(self.normal, 0.0)]))), (pgVec4Xyz(([mat4 mulVec4:pgVec4ApplyVec3W(self.position, 1.0)]))));
}
PGMeshData pgMeshDataUvAddVec2(PGMeshData self, PGVec2 vec2) {
    return PGMeshDataMake((pgVec2AddVec2(self.uv, vec2)), self.normal, self.position);
}
NSString* pgMeshDataDescription(PGMeshData self) {
    return [NSString stringWithFormat:@"MeshData(%@, %@, %@)", pgVec2Description(self.uv), pgVec3Description(self.normal), pgVec3Description(self.position)];
}
BOOL pgMeshDataIsEqualTo(PGMeshData self, PGMeshData to) {
    return pgVec2IsEqualTo(self.uv, to.uv) && pgVec3IsEqualTo(self.normal, to.normal) && pgVec3IsEqualTo(self.position, to.position);
}
NSUInteger pgMeshDataHash(PGMeshData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec2Hash(self.uv);
    hash = hash * 31 + pgVec3Hash(self.normal);
    hash = hash * 31 + pgVec3Hash(self.position);
    return hash;
}
CNPType* pgMeshDataType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[PGMeshDataWrap class] name:@"PGMeshData" size:sizeof(PGMeshData) wrap:^id(void* data, NSUInteger i) {
        return wrap(PGMeshData, ((PGMeshData*)(data))[i]);
    }];
    return _ret;
}
@implementation PGMeshDataWrap{
    PGMeshData _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(PGMeshData)value {
    return [[PGMeshDataWrap alloc] initWithValue:value];
}

- (id)initWithValue:(PGMeshData)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return pgMeshDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    PGMeshDataWrap* o = ((PGMeshDataWrap*)(other));
    return pgMeshDataIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return pgMeshDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation PGMeshDataModel
static CNClassType* _PGMeshDataModel_type;
@synthesize vertex = _vertex;
@synthesize index = _index;

+ (instancetype)meshDataModelWithVertex:(CNPArray*)vertex index:(CNPArray*)index {
    return [[PGMeshDataModel alloc] initWithVertex:vertex index:index];
}

- (instancetype)initWithVertex:(CNPArray*)vertex index:(CNPArray*)index {
    self = [super init];
    if(self) {
        _vertex = vertex;
        _index = index;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMeshDataModel class]) _PGMeshDataModel_type = [CNClassType classTypeWithCls:[PGMeshDataModel class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MeshDataModel(%@, %@)", _vertex, _index];
}

- (CNClassType*)type {
    return [PGMeshDataModel type];
}

+ (CNClassType*)type {
    return _PGMeshDataModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGMesh
static CNClassType* _PGMesh_type;
@synthesize vertex = _vertex;
@synthesize index = _index;

+ (instancetype)meshWithVertex:(id<PGVertexBuffer>)vertex index:(id<PGIndexSource>)index {
    return [[PGMesh alloc] initWithVertex:vertex index:index];
}

- (instancetype)initWithVertex:(id<PGVertexBuffer>)vertex index:(id<PGIndexSource>)index {
    self = [super init];
    if(self) {
        _vertex = vertex;
        _index = index;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMesh class]) _PGMesh_type = [CNClassType classTypeWithCls:[PGMesh class]];
}

+ (PGMesh*)vec2VertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData {
    return [PGMesh meshWithVertex:[PGVBO vec2Data:vertexData] index:[PGIBO applyData:indexData]];
}

+ (PGMesh*)applyVertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData {
    return [PGMesh meshWithVertex:[PGVBO meshData:vertexData] index:[PGIBO applyData:indexData]];
}

+ (PGMesh*)applyDesc:(PGVertexBufferDesc*)desc vertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData {
    return [PGMesh meshWithVertex:[PGVBO applyDesc:desc data:vertexData] index:[PGIBO applyData:indexData]];
}

- (PGVertexArray*)vaoShader:(PGShader*)shader {
    return [shader vaoVbo:_vertex ibo:((id<PGIndexBuffer>)(_index))];
}

- (PGVertexArray*)vaoShadow {
    return [self vaoShaderSystem:PGShadowShaderSystem.instance material:[PGColorSource applyColor:PGVec4Make(1.0, 1.0, 1.0, 1.0)] shadow:NO];
}

- (PGVertexArray*)vaoShadowMaterial:(PGColorSource*)material {
    return [self vaoShaderSystem:PGShadowShaderSystem.instance material:material shadow:NO];
}

- (PGVertexArray*)vaoMaterial:(id)material shadow:(BOOL)shadow {
    PGMaterialVertexArray* std = [PGMaterialVertexArray materialVertexArrayWithVao:[[material shader] vaoVbo:_vertex ibo:((id<PGIndexBuffer>)(_index))] material:material];
    if(shadow && egPlatform().shadows) return ((PGVertexArray*)([PGRouteVertexArray routeVertexArrayWithStandard:std shadow:[PGMaterialVertexArray materialVertexArrayWithVao:[[[material shaderSystem] shaderForParam:material renderTarget:PGShadowRenderTarget.aDefault] vaoVbo:_vertex ibo:((id<PGIndexBuffer>)(_index))] material:material]]));
    else return ((PGVertexArray*)(std));
}

- (PGVertexArray*)vaoShaderSystem:(PGShaderSystem*)shaderSystem material:(id)material shadow:(BOOL)shadow {
    PGMaterialVertexArray* std = [PGMaterialVertexArray materialVertexArrayWithVao:[[shaderSystem shaderForParam:material] vaoVbo:_vertex ibo:((id<PGIndexBuffer>)(_index))] material:material];
    if(shadow && egPlatform().shadows) return ((PGVertexArray*)([PGRouteVertexArray routeVertexArrayWithStandard:std shadow:[PGMaterialVertexArray materialVertexArrayWithVao:[[shaderSystem shaderForParam:material renderTarget:PGShadowRenderTarget.aDefault] vaoVbo:_vertex ibo:((id<PGIndexBuffer>)(_index))] material:material]]));
    else return ((PGVertexArray*)(std));
}

- (void)drawMaterial:(PGMaterial*)material {
    [material drawMesh:self];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Mesh(%@, %@)", _vertex, _index];
}

- (CNClassType*)type {
    return [PGMesh type];
}

+ (CNClassType*)type {
    return _PGMesh_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGMeshModel
static CNClassType* _PGMeshModel_type;
@synthesize arrays = _arrays;

+ (instancetype)meshModelWithArrays:(NSArray*)arrays {
    return [[PGMeshModel alloc] initWithArrays:arrays];
}

- (instancetype)initWithArrays:(NSArray*)arrays {
    self = [super init];
    if(self) _arrays = arrays;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMeshModel class]) _PGMeshModel_type = [CNClassType classTypeWithCls:[PGMeshModel class]];
}

+ (PGMeshModel*)applyMeshes:(NSArray*)meshes {
    return [PGMeshModel applyShadow:NO meshes:meshes];
}

+ (PGMeshModel*)applyShadow:(BOOL)shadow meshes:(NSArray*)meshes {
    return [PGMeshModel meshModelWithArrays:[[[meshes chain] mapF:^PGVertexArray*(CNTuple* p) {
        return [((PGMesh*)(((CNTuple*)(p)).a)) vaoMaterial:((CNTuple*)(p)).b shadow:shadow];
    }] toArray]];
}

- (void)draw {
    for(PGVertexArray* _ in _arrays) {
        [((PGVertexArray*)(_)) draw];
    }
}

- (void)drawOnly:(unsigned int)only {
    if(only == 0) return ;
    __block unsigned int o = only;
    for(PGVertexArray* a in _arrays) {
        [((PGVertexArray*)(a)) draw];
        o--;
        if(o > 0) continue;
        else break;
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MeshModel(%@)", _arrays];
}

- (CNClassType*)type {
    return [PGMeshModel type];
}

+ (CNClassType*)type {
    return _PGMeshModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGMeshUnite
static CNClassType* _PGMeshUnite_type;
@synthesize vertexSample = _vertexSample;
@synthesize indexSample = _indexSample;
@synthesize createVao = _createVao;
@synthesize mesh = _mesh;
@synthesize vao = _vao;

+ (instancetype)meshUniteWithVertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample createVao:(PGVertexArray*(^)(PGMesh*))createVao {
    return [[PGMeshUnite alloc] initWithVertexSample:vertexSample indexSample:indexSample createVao:createVao];
}

- (instancetype)initWithVertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample createVao:(PGVertexArray*(^)(PGMesh*))createVao {
    self = [super init];
    if(self) {
        _vertexSample = vertexSample;
        _indexSample = indexSample;
        _createVao = [createVao copy];
        _vbo = [PGVBO mutMeshUsage:GL_DYNAMIC_DRAW];
        _ibo = [PGIBO mutUsage:GL_DYNAMIC_DRAW];
        _mesh = [PGMesh meshWithVertex:_vbo index:_ibo];
        _vao = createVao(_mesh);
        __count = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMeshUnite class]) _PGMeshUnite_type = [CNClassType classTypeWithCls:[PGMeshUnite class]];
}

+ (PGMeshUnite*)applyMeshModel:(PGMeshDataModel*)meshModel createVao:(PGVertexArray*(^)(PGMesh*))createVao {
    return [PGMeshUnite meshUniteWithVertexSample:meshModel.vertex indexSample:meshModel.index createVao:createVao];
}

- (void)writeCount:(unsigned int)count f:(void(^)(PGMeshWriter*))f {
    PGMeshWriter* w = [self writerCount:count];
    f(w);
    [w flush];
}

- (void)writeMat4Array:(id<CNIterable>)mat4Array {
    PGMeshWriter* w = [self writerCount:((unsigned int)([mat4Array count]))];
    {
        id<CNIterator> __il__1i = [mat4Array iterator];
        while([__il__1i hasNext]) {
            PGMat4* _ = [__il__1i next];
            [w writeMat4:_];
        }
    }
    [w flush];
}

- (PGMeshWriter*)writerCount:(unsigned int)count {
    __count = count;
    return [PGMeshWriter meshWriterWithVbo:_vbo ibo:_ibo count:count vertexSample:_vertexSample indexSample:_indexSample];
}

- (void)draw {
    if(__count > 0) {
        PGMatrixStack* __tmp__il__0t_0self = PGGlobal.matrix;
        {
            [__tmp__il__0t_0self push];
            [[__tmp__il__0t_0self value] clear];
            [_vao draw];
            [__tmp__il__0t_0self pop];
        }
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MeshUnite(%@, %@)", _vertexSample, _indexSample];
}

- (CNClassType*)type {
    return [PGMeshUnite type];
}

+ (CNClassType*)type {
    return _PGMeshUnite_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation PGMeshWriter
static CNClassType* _PGMeshWriter_type;
@synthesize vbo = _vbo;
@synthesize ibo = _ibo;
@synthesize count = _count;
@synthesize vertexSample = _vertexSample;
@synthesize indexSample = _indexSample;

+ (instancetype)meshWriterWithVbo:(PGMutableVertexBuffer*)vbo ibo:(PGMutableIndexBuffer*)ibo count:(unsigned int)count vertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample {
    return [[PGMeshWriter alloc] initWithVbo:vbo ibo:ibo count:count vertexSample:vertexSample indexSample:indexSample];
}

- (instancetype)initWithVbo:(PGMutableVertexBuffer*)vbo ibo:(PGMutableIndexBuffer*)ibo count:(unsigned int)count vertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample {
    self = [super init];
    if(self) {
        _vbo = vbo;
        _ibo = ibo;
        _count = count;
        _vertexSample = vertexSample;
        _indexSample = indexSample;
        _vertex = cnPointerApplyTpCount(pgMeshDataType(), vertexSample.count * count);
        _index = cnPointerApplyTpCount(cnuInt4Type(), indexSample.count * count);
        __vp = _vertex;
        __ip = _index;
        __indexShift = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [PGMeshWriter class]) _PGMeshWriter_type = [CNClassType classTypeWithCls:[PGMeshWriter class]];
}

- (void)writeMat4:(PGMat4*)mat4 {
    [self writeVertex:_vertexSample index:_indexSample mat4:mat4];
}

- (void)writeVertex:(CNPArray*)vertex mat4:(PGMat4*)mat4 {
    [self writeVertex:vertex index:_indexSample mat4:mat4];
}

- (void)writeVertex:(CNPArray*)vertex index:(CNPArray*)index mat4:(PGMat4*)mat4 {
    {
        PGMeshData* __il__0__b = vertex.bytes;
        NSInteger __il__0__i = 0;
        while(__il__0__i < vertex.count) {
            {
                *(__vp) = pgMeshDataMulMat4(*(__il__0__b), mat4);
                __vp++;
            }
            __il__0__i++;
            __il__0__b++;
        }
    }
    {
        unsigned int* __il__1__b = index.bytes;
        NSInteger __il__1__i = 0;
        while(__il__1__i < index.count) {
            {
                *(__ip) = *(__il__1__b) + __indexShift;
                __ip++;
            }
            __il__1__i++;
            __il__1__b++;
        }
    }
    __indexShift += ((unsigned int)(vertex.count));
}

- (void)writeMap:(PGMeshData(^)(PGMeshData))map {
    [self writeVertex:_vertexSample index:_indexSample map:map];
}

- (void)writeVertex:(CNPArray*)vertex map:(PGMeshData(^)(PGMeshData))map {
    [self writeVertex:vertex index:_indexSample map:map];
}

- (void)writeVertex:(CNPArray*)vertex index:(CNPArray*)index map:(PGMeshData(^)(PGMeshData))map {
    {
        PGMeshData* __il__0__b = vertex.bytes;
        NSInteger __il__0__i = 0;
        while(__il__0__i < vertex.count) {
            {
                *(__vp) = map(*(__il__0__b));
                __vp++;
            }
            __il__0__i++;
            __il__0__b++;
        }
    }
    {
        unsigned int* __il__1__b = index.bytes;
        NSInteger __il__1__i = 0;
        while(__il__1__i < index.count) {
            {
                *(__ip) = *(__il__1__b) + __indexShift;
                __ip++;
            }
            __il__1__i++;
            __il__1__b++;
        }
    }
    __indexShift += ((unsigned int)(vertex.count));
}

- (void)flush {
    [_vbo setArray:_vertex count:((unsigned int)(_vertexSample.count * _count))];
    [_ibo setArray:_index count:((unsigned int)(_indexSample.count * _count))];
}

- (void)dealloc {
    cnPointerFree(_vertex);
    cnPointerFree(_index);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MeshWriter(%@, %@, %u, %@, %@)", _vbo, _ibo, _count, _vertexSample, _indexSample];
}

- (CNClassType*)type {
    return [PGMeshWriter type];
}

+ (CNClassType*)type {
    return _PGMeshWriter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

