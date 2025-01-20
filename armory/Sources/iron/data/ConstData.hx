package iron.data;

import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.Usage;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexData;

class ConstData {

	public static var screenAlignedVB: VertexBuffer = null;
	public static var screenAlignedIB: IndexBuffer = null;
	#if (rp_decals || rp_probes)
	public static var boxVB: VertexBuffer = null;
	public static var boxIB: IndexBuffer = null;
	#end
	#if arm_deinterleaved
	public static var skydomeVB: Array<VertexBuffer> = null;
	#else
	public static var skydomeVB: VertexBuffer = null;
	#end
	public static var skydomeIB: IndexBuffer = null;

	public static function createScreenAlignedData() {
		// Over-sized triangle
		var data = [-1.0, -1.0, 3.0, -1.0, -1.0, 3.0];
		var indices = [0, 1, 2];

		// Mandatory vertex data names and sizes
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float2);
		screenAlignedVB = new VertexBuffer(Std.int(data.length / Std.int(structure.byteSize() / 4)), structure, Usage.StaticUsage);
		var vertices = screenAlignedVB.lock();
		for (i in 0...Std.int(vertices.byteLength / 4)) vertices.setFloat32(i * 4, data[i]);
		screenAlignedVB.unlock();

		screenAlignedIB = new IndexBuffer(indices.length, Usage.StaticUsage);
		var id = screenAlignedIB.lock();
		for (i in 0...id.length) id[i] = indices[i];
		screenAlignedIB.unlock();
	}

	#if (rp_decals || rp_probes)
	public static function createBoxData() {
		var data = [
			-1.0,1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,1.0,-1.0,1.0,1.0,-1.0,
			1.0,1.0,1.0,1.0,1.0,1.0,1.0,-1.0,-1.0,1.0,-1.0,1.0,1.0,1.0,1.0,-1.0,
			1.0,1.0,-1.0,-1.0,1.0,1.0,-1.0,-1.0,-1.0,-1.0,1.0,-1.0,-1.0,1.0,-1.0,
			1.0,-1.0,-1.0,1.0,-1.0,-1.0,-1.0,-1.0,1.0,-1.0,1.0,1.0,-1.0,1.0,-1.0,
			-1.0,1.0,-1.0,1.0,1.0,1.0,1.0,-1.0,1.0,1.0,-1.0,-1.0,1.0
		];
		var indices = [
			0,1,2,0,2,3,4,5,6,4,6,7,8,9,10,8,10,11,12,13,14,12,14,15,16,17,18,16,
			18,19,20,21,22,20,22,23
		];

		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		boxVB = new VertexBuffer(Std.int(data.length / Std.int(structure.byteSize() / 4)), structure, Usage.StaticUsage);
		var vertices = boxVB.lock();
		for (i in 0...Std.int(vertices.byteLength / 4)) vertices.setFloat32(i * 4, data[i]);
		boxVB.unlock();

		boxIB = new IndexBuffer(indices.length, Usage.StaticUsage);
		var id = boxIB.lock();
		for (i in 0...id.length) id[i] = indices[i];
		boxIB.unlock();
	}
	#end

	public static function createSkydomeData() {
		var pos = skydomePos;
		var nor = skydomeNor;

		#if arm_deinterleaved
		skydomeVB = [];

		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		var structLength = Std.int(structure.byteSize() / 4);
		skydomeVB[0] = new VertexBuffer(Std.int(pos.length / 3), structure, Usage.StaticUsage);
		var vertices = skydomeVB[0].lock();
		for (i in 0...Std.int(vertices.byteLength / 4 / structLength)) {
			vertices.setFloat32((i * structLength) * 4, pos[i * 3]);
			vertices.setFloat32((i * structLength + 1) * 4, pos[i * 3 + 1]);
			vertices.setFloat32((i * structLength + 2) * 4, pos[i * 3 + 2]);
		}
		skydomeVB[0].unlock();

		structure = new VertexStructure();
		structure.add("nor", VertexData.Float3);
		structLength = Std.int(structure.byteSize() / 4);
		skydomeVB[1] = new VertexBuffer(Std.int(nor.length / 3), structure, Usage.StaticUsage);
		vertices = skydomeVB[1].lock();
		for (i in 0...Std.int(vertices.byteLength / 4 / structLength)) {
			vertices.setFloat32((i * structLength) * 4, nor[i * 3]);
			vertices.setFloat32((i * structLength + 1) * 4, nor[i * 3 + 1]);
			vertices.setFloat32((i * structLength + 2) * 4, nor[i * 3 + 2]);
		}
		skydomeVB[1].unlock();
		#else
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		structure.add("nor", VertexData.Float3);
		var structLength = Std.int(structure.byteSize() / 4);
		skydomeVB = new VertexBuffer(Std.int(pos.length / 3), structure, Usage.StaticUsage);
		var vertices = skydomeVB.lock();
		for (i in 0...Std.int(vertices.byteLength / 4 / structLength)) {
			vertices.setFloat32((i * structLength) * 4, pos[i * 3]);
			vertices.setFloat32((i * structLength + 1) * 4, pos[i * 3 + 1]);
			vertices.setFloat32((i * structLength + 2) * 4, pos[i * 3 + 2]);
			vertices.setFloat32((i * structLength + 3) * 4, nor[i * 3]);
			vertices.setFloat32((i * structLength + 4) * 4, nor[i * 3 + 1]);
			vertices.setFloat32((i * structLength + 5) * 4, nor[i * 3 + 2]);
		}
		skydomeVB.unlock();
		#end

		var indices = skydomeIndices;
		skydomeIB = new IndexBuffer(indices.length, Usage.StaticUsage);
		var id = skydomeIB.lock();
		for (i in 0...id.length) id[i] = indices[i];
		skydomeIB.unlock();
	}

	// Generated in Blender with armory_tools/export_skydome_geometry.py, using
	// a UV sphere with 24 segments and 12 rings.
	static var skydomeIndices = [261,8,7,258,5,4,265,12,11,257,2,156,262,9,8,259,6,5,179,12,265,0,3,2,263,10,9,260,7,6,1,4,3,264,11,10,6,17,16,179,23,12,3,14,13,10,21,20,7,18,17,4,15,14,11,22,21,8,19,18,5,16,15,12,23,22,2,13,156,9,20,19,16,27,26,23,34,33,13,24,156,20,31,30,17,28,27,179,34,23,14,25,24,21,32,31,18,29,28,15,26,25,22,33,32,19,30,29,29,40,39,26,37,36,33,44,43,30,41,40,27,38,37,34,45,44,24,35,156,31,42,41,28,39,38,179,45,34,25,36,35,32,43,42,39,50,49,179,56,45,36,47,46,43,54,53,40,51,50,37,48,47,44,55,54,41,52,51,38,49,48,45,56,55,35,46,156,42,53,52,52,63,62,49,60,59,56,67,66,46,57,156,53,64,63,50,61,60,179,67,56,47,58,57,54,65,64,51,62,61,48,59,58,55,66,65,62,73,72,59,70,69,66,77,76,63,74,73,60,71,70,67,78,77,57,68,156,64,75,74,61,72,71,179,78,67,58,69,68,65,76,75,75,86,85,72,83,82,179,89,78,69,80,79,76,87,86,73,84,83,70,81,80,77,88,87,74,85,84,71,82,81,78,89,88,68,79,156,85,96,95,82,93,92,89,100,99,79,90,156,86,97,96,83,94,93,179,100,89,80,91,90,87,98,97,84,95,94,81,92,91,88,99,98,98,109,108,95,106,105,92,103,102,99,110,109,96,107,106,93,104,103,100,111,110,90,101,156,97,108,107,94,105,104,179,111,100,91,102,101,101,112,156,108,119,118,105,116,115,179,122,111,102,113,112,109,120,119,106,117,116,103,114,113,110,121,120,107,118,117,104,115,114,111,122,121,121,132,131,118,129,128,115,126,125,122,133,132,112,123,156,119,130,129,116,127,126,179,133,122,113,124,123,120,131,130,117,128,127,114,125,124,124,135,134,131,142,141,128,139,138,125,136,135,132,143,142,129,140,139,126,137,136,133,144,143,123,134,156,130,141,140,127,138,137,179,144,133,144,155,154,134,145,156,141,152,151,138,149,148,179,155,144,135,146,145,142,153,152,139,150,149,136,147,146,143,154,153,140,151,150,137,148,147,147,159,158,154,166,165,151,163,162,148,160,159,155,167,166,145,157,156,152,164,163,149,161,160,179,167,155,146,158,157,153,165,164,150,162,161,179,178,167,158,169,168,165,176,175,162,173,172,159,170,169,166,177,176,163,174,173,160,171,170,167,178,177,157,168,156,164,175,174,161,172,171,171,183,182,178,190,189,168,180,156,175,187,186,172,184,183,179,190,178,169,181,180,176,188,187,173,185,184,170,182,181,177,189,188,174,186,185,182,193,192,189,200,199,186,197,196,183,194,193,190,201,200,180,191,156,187,198,197,184,195,194,179,201,190,181,192,191,188,199,198,185,196,195,195,206,205,179,212,201,192,203,202,199,210,209,196,207,206,193,204,203,200,211,210,197,208,207,194,205,204,201,212,211,191,202,156,198,209,208,205,216,215,212,223,222,202,213,156,209,220,219,206,217,216,179,223,212,203,214,213,210,221,220,207,218,217,204,215,214,211,222,221,208,219,218,218,229,228,215,226,225,222,233,232,219,230,229,216,227,226,223,234,233,213,224,156,220,231,230,217,228,227,179,234,223,214,225,224,221,232,231,228,239,238,179,245,234,225,236,235,232,243,242,229,240,239,226,237,236,233,244,243,230,241,240,227,238,237,234,245,244,224,235,156,231,242,241,241,252,251,238,249,248,245,256,255,235,246,156,242,253,252,239,250,249,179,256,245,236,247,246,243,254,253,240,251,250,237,248,247,244,255,254,251,260,259,248,1,0,255,264,263,252,261,260,249,258,1,256,265,264,246,257,156,253,262,261,250,259,258,179,265,256,247,0,257,254,263,262,261,7,260,258,4,1,265,11,264,262,8,261,259,5,258,0,2,257,263,9,262,260,6,259,1,3,0,264,10,263,6,16,5,3,13,2,10,20,9,7,17,6,4,14,3,11,21,10,8,18,7,5,15,4,12,22,11,9,19,8,16,26,15,23,33,22,20,30,19,17,27,16,14,24,13,21,31,20,18,28,17,15,25,14,22,32,21,19,29,18,29,39,28,26,36,25,33,43,32,30,40,29,27,37,26,34,44,33,31,41,30,28,38,27,25,35,24,32,42,31,39,49,38,36,46,35,43,53,42,40,50,39,37,47,36,44,54,43,41,51,40,38,48,37,45,55,44,42,52,41,52,62,51,49,59,48,56,66,55,53,63,52,50,60,49,47,57,46,54,64,53,51,61,50,48,58,47,55,65,54,62,72,61,59,69,58,66,76,65,63,73,62,60,70,59,67,77,66,64,74,63,61,71,60,58,68,57,65,75,64,75,85,74,72,82,71,69,79,68,76,86,75,73,83,72,70,80,69,77,87,76,74,84,73,71,81,70,78,88,77,85,95,84,82,92,81,89,99,88,86,96,85,83,93,82,80,90,79,87,97,86,84,94,83,81,91,80,88,98,87,98,108,97,95,105,94,92,102,91,99,109,98,96,106,95,93,103,92,100,110,99,97,107,96,94,104,93,91,101,90,108,118,107,105,115,104,102,112,101,109,119,108,106,116,105,103,113,102,110,120,109,107,117,106,104,114,103,111,121,110,121,131,120,118,128,117,115,125,114,122,132,121,119,129,118,116,126,115,113,123,112,120,130,119,117,127,116,114,124,113,124,134,123,131,141,130,128,138,127,125,135,124,132,142,131,129,139,128,126,136,125,133,143,132,130,140,129,127,137,126,144,154,143,141,151,140,138,148,137,135,145,134,142,152,141,139,149,138,136,146,135,143,153,142,140,150,139,137,147,136,147,158,146,154,165,153,151,162,150,148,159,147,155,166,154,152,163,151,149,160,148,146,157,145,153,164,152,150,161,149,158,168,157,165,175,164,162,172,161,159,169,158,166,176,165,163,173,162,160,170,159,167,177,166,164,174,163,161,171,160,171,182,170,178,189,177,175,186,174,172,183,171,169,180,168,176,187,175,173,184,172,170,181,169,177,188,176,174,185,173,182,192,181,189,199,188,186,196,185,183,193,182,190,200,189,187,197,186,184,194,183,181,191,180,188,198,187,185,195,184,195,205,194,192,202,191,199,209,198,196,206,195,193,203,192,200,210,199,197,207,196,194,204,193,201,211,200,198,208,197,205,215,204,212,222,211,209,219,208,206,216,205,203,213,202,210,220,209,207,217,206,204,214,203,211,221,210,208,218,207,218,228,217,215,225,214,222,232,221,219,229,218,216,226,215,223,233,222,220,230,219,217,227,216,214,224,213,221,231,220,228,238,227,225,235,224,232,242,231,229,239,228,226,236,225,233,243,232,230,240,229,227,237,226,234,244,233,231,241,230,241,251,240,238,248,237,245,255,244,242,252,241,239,249,238,236,246,235,243,253,242,240,250,239,237,247,236,244,254,243,251,259,250,248,0,247,255,263,254,252,260,251,249,1,248,256,264,255,253,261,252,250,258,249,247,257,246,254,262,253];
	static var skydomePos = [0.0,0.5,0.86603,0.0,0.70711,0.70711,0.06699,0.25,0.96593,0.12941,0.48296,0.86603,0.18301,0.68301,0.70711,0.22414,0.83652,0.5,0.25,0.93301,0.25882,0.25882,0.96593,-0.0,0.25,0.93301,-0.25882,0.22414,0.83652,-0.5,0.18301,0.68301,-0.70711,0.12941,0.48296,-0.86603,0.06699,0.25,-0.96593,0.12941,0.22414,0.96593,0.25,0.43301,0.86603,0.35355,0.61237,0.70711,0.43301,0.75,0.5,0.48296,0.83652,0.25882,0.5,0.86603,-0.0,0.48296,0.83652,-0.25882,0.43301,0.75,-0.5,0.35355,0.61237,-0.70711,0.25,0.43301,-0.86603,0.12941,0.22414,-0.96593,0.18301,0.18301,0.96593,0.35355,0.35355,0.86603,0.5,0.5,0.70711,0.61237,0.61237,0.5,0.68301,0.68301,0.25882,0.70711,0.70711,-0.0,0.68301,0.68301,-0.25882,0.61237,0.61237,-0.5,0.5,0.5,-0.70711,0.35355,0.35355,-0.86603,0.18301,0.18301,-0.96593,0.22414,0.12941,0.96593,0.43301,0.25,0.86603,0.61237,0.35355,0.70711,0.75,0.43301,0.5,0.83652,0.48296,0.25882,0.86603,0.5,-0.0,0.83652,0.48296,-0.25882,0.75,0.43301,-0.5,0.61237,0.35355,-0.70711,0.43301,0.25,-0.86603,0.22414,0.12941,-0.96593,0.25,0.06699,0.96593,0.48296,0.12941,0.86603,0.68301,0.18301,0.70711,0.83652,0.22414,0.5,0.93301,0.25,0.25882,0.96593,0.25882,-0.0,0.93301,0.25,-0.25882,0.83652,0.22414,-0.5,0.68301,0.18301,-0.70711,0.48296,0.12941,-0.86603,0.25,0.06699,-0.96593,0.25882,-0.0,0.96593,0.5,-0.0,0.86603,0.70711,-0.0,0.70711,0.86603,0.0,0.5,0.96593,-0.0,0.25882,1.0,-0.0,-0.0,0.96593,-0.0,-0.25882,0.86603,-0.0,-0.5,0.70711,-0.0,-0.70711,0.5,-0.0,-0.86603,0.25882,-0.0,-0.96593,0.25,-0.06699,0.96593,0.48296,-0.12941,0.86603,0.68301,-0.18301,0.70711,0.83652,-0.22414,0.5,0.93301,-0.25,0.25882,0.96593,-0.25882,-0.0,0.93301,-0.25,-0.25882,0.83652,-0.22414,-0.5,0.68301,-0.18301,-0.70711,0.48296,-0.12941,-0.86603,0.25,-0.06699,-0.96593,0.22414,-0.12941,0.96593,0.43301,-0.25,0.86603,0.61237,-0.35355,0.70711,0.75,-0.43301,0.5,0.83652,-0.48296,0.25882,0.86603,-0.5,-0.0,0.83652,-0.48296,-0.25882,0.75,-0.43301,-0.5,0.61237,-0.35355,-0.70711,0.43301,-0.25,-0.86603,0.22414,-0.12941,-0.96593,0.18301,-0.18301,0.96593,0.35355,-0.35355,0.86603,0.5,-0.5,0.70711,0.61237,-0.61237,0.5,0.68301,-0.68301,0.25882,0.70711,-0.70711,-0.0,0.68301,-0.68301,-0.25882,0.61237,-0.61237,-0.5,0.5,-0.5,-0.70711,0.35355,-0.35355,-0.86603,0.18301,-0.18301,-0.96593,0.12941,-0.22414,0.96593,0.25,-0.43301,0.86603,0.35355,-0.61237,0.70711,0.43301,-0.75,0.5,0.48296,-0.83652,0.25882,0.5,-0.86603,-0.0,0.48296,-0.83652,-0.25882,0.43301,-0.75,-0.5,0.35355,-0.61237,-0.70711,0.25,-0.43301,-0.86603,0.12941,-0.22414,-0.96593,0.06699,-0.25,0.96593,0.12941,-0.48296,0.86603,0.18301,-0.68301,0.70711,0.22414,-0.83652,0.5,0.25,-0.93301,0.25882,0.25882,-0.96593,-0.0,0.25,-0.93301,-0.25882,0.22414,-0.83652,-0.5,0.18301,-0.68301,-0.70711,0.12941,-0.48296,-0.86603,0.06699,-0.25,-0.96593,0.0,-0.25882,0.96593,-0.0,-0.5,0.86603,0.0,-0.70711,0.70711,0.0,-0.86603,0.5,0.0,-0.96593,0.25882,-0.0,-1.0,-0.0,0.0,-0.96593,-0.25882,0.0,-0.86603,-0.5,0.0,-0.70711,-0.70711,0.0,-0.5,-0.86603,0.0,-0.25882,-0.96593,-0.06699,-0.25,0.96593,-0.12941,-0.48296,0.86603,-0.18301,-0.68301,0.70711,-0.22414,-0.83652,0.5,-0.25,-0.93301,0.25882,-0.25882,-0.96593,-0.0,-0.25,-0.93301,-0.25882,-0.22414,-0.83652,-0.5,-0.18301,-0.68301,-0.70711,-0.12941,-0.48296,-0.86603,-0.06699,-0.25,-0.96593,-0.12941,-0.22414,0.96593,-0.25,-0.43301,0.86603,-0.35355,-0.61237,0.70711,-0.43301,-0.75,0.5,-0.48296,-0.83652,0.25882,-0.5,-0.86603,-0.0,-0.48296,-0.83652,-0.25882,-0.43301,-0.75,-0.5,-0.35355,-0.61237,-0.70711,-0.25,-0.43301,-0.86603,-0.12941,-0.22414,-0.96593,-0.0,-0.0,1.0,-0.18301,-0.18301,0.96593,-0.35355,-0.35355,0.86603,-0.5,-0.5,0.70711,-0.61237,-0.61237,0.5,-0.68301,-0.68301,0.25882,-0.70711,-0.70711,-0.0,-0.68301,-0.68301,-0.25882,-0.61237,-0.61237,-0.5,-0.5,-0.5,-0.70711,-0.35355,-0.35355,-0.86603,-0.18301,-0.18301,-0.96593,-0.22414,-0.12941,0.96593,-0.43301,-0.25,0.86603,-0.61237,-0.35355,0.70711,-0.75,-0.43301,0.5,-0.83652,-0.48296,0.25882,-0.86602,-0.5,-0.0,-0.83652,-0.48296,-0.25882,-0.75,-0.43301,-0.5,-0.61237,-0.35355,-0.70711,-0.43301,-0.25,-0.86603,-0.22414,-0.12941,-0.96593,0.0,-0.0,-1.0,-0.25,-0.06699,0.96593,-0.48296,-0.12941,0.86603,-0.68301,-0.18301,0.70711,-0.83652,-0.22414,0.5,-0.93301,-0.25,0.25882,-0.96593,-0.25882,-0.0,-0.93301,-0.25,-0.25882,-0.83652,-0.22414,-0.5,-0.68301,-0.18301,-0.70711,-0.48296,-0.12941,-0.86603,-0.25,-0.06699,-0.96593,-0.25882,-0.0,0.96593,-0.5,-0.0,0.86603,-0.70711,-0.0,0.70711,-0.86603,-0.0,0.5,-0.96593,-0.0,0.25882,-1.0,-0.0,-0.0,-0.96593,-0.0,-0.25882,-0.86603,-0.0,-0.5,-0.70711,-0.0,-0.70711,-0.5,-0.0,-0.86603,-0.25882,-0.0,-0.96593,-0.25,0.06699,0.96593,-0.48296,0.12941,0.86603,-0.68301,0.18301,0.70711,-0.83652,0.22414,0.5,-0.93301,0.25,0.25882,-0.96593,0.25882,-0.0,-0.93301,0.25,-0.25882,-0.83652,0.22414,-0.5,-0.68301,0.18301,-0.70711,-0.48296,0.12941,-0.86603,-0.25,0.06699,-0.96593,-0.22414,0.12941,0.96593,-0.43301,0.25,0.86603,-0.61237,0.35355,0.70711,-0.75,0.43301,0.5,-0.83652,0.48296,0.25882,-0.86602,0.5,-0.0,-0.83652,0.48296,-0.25882,-0.75,0.43301,-0.5,-0.61237,0.35355,-0.70711,-0.43301,0.25,-0.86603,-0.22414,0.12941,-0.96593,-0.18301,0.18301,0.96593,-0.35355,0.35355,0.86603,-0.5,0.5,0.70711,-0.61237,0.61237,0.5,-0.68301,0.68301,0.25882,-0.70711,0.70711,-0.0,-0.68301,0.68301,-0.25882,-0.61237,0.61237,-0.5,-0.5,0.5,-0.70711,-0.35355,0.35355,-0.86603,-0.18301,0.18301,-0.96593,-0.12941,0.22414,0.96593,-0.25,0.43301,0.86603,-0.35355,0.61237,0.70711,-0.43301,0.75,0.5,-0.48296,0.83652,0.25882,-0.5,0.86602,-0.0,-0.48296,0.83652,-0.25882,-0.43301,0.75,-0.5,-0.35355,0.61237,-0.70711,-0.25,0.43301,-0.86603,-0.12941,0.22414,-0.96593,-0.06699,0.25,0.96593,-0.12941,0.48296,0.86603,-0.18301,0.68301,0.70711,-0.22414,0.83652,0.5,-0.25,0.93301,0.25882,-0.25882,0.96593,-0.0,-0.25,0.93301,-0.25882,-0.22414,0.83652,-0.5,-0.18301,0.68301,-0.70711,-0.12941,0.48296,-0.86603,-0.06699,0.25,-0.96593,-0.0,0.25882,0.96593,-0.0,0.86603,0.5,-0.0,0.96593,0.25882,0.0,1.0,-0.0,-0.0,0.96593,-0.25882,-0.0,0.86603,-0.5,0.0,0.70711,-0.70711,0.0,0.5,-0.86603,-0.0,0.25882,-0.96593];
	static var skydomeNor = [0.0,-0.50807,-0.86132,0.0,-0.71246,-0.70172,-0.0696,-0.25975,-0.96317,-0.1315,-0.49075,-0.86132,-0.1844,-0.68818,-0.70172,-0.22483,-0.83909,-0.49536,-0.25018,-0.9337,-0.25615,-0.25882,-0.96593,-0.0,-0.25018,-0.9337,0.25615,-0.22483,-0.83909,0.49536,-0.1844,-0.68818,0.70172,-0.1315,-0.49075,0.86132,-0.0696,-0.25975,0.96317,-0.13445,-0.23288,-0.96317,-0.25403,-0.44,-0.86132,-0.35623,-0.61701,-0.70172,-0.43434,-0.75231,-0.49536,-0.48332,-0.83713,-0.25615,-0.5,-0.86603,0.0,-0.48332,-0.83713,0.25615,-0.43434,-0.75231,0.49536,-0.35623,-0.61701,0.70172,-0.25403,-0.44,0.86132,-0.13445,-0.23288,0.96317,-0.19015,-0.19015,-0.96317,-0.35926,-0.35926,-0.86132,-0.50378,-0.50378,-0.70172,-0.61426,-0.61426,-0.49536,-0.68352,-0.68352,-0.25615,-0.70711,-0.70711,0.0,-0.68352,-0.68352,0.25615,-0.61426,-0.61426,0.49536,-0.50378,-0.50378,0.70172,-0.35926,-0.35926,0.86132,-0.19015,-0.19015,0.96317,-0.23288,-0.13445,-0.96317,-0.44,-0.25403,-0.86132,-0.61701,-0.35623,-0.70172,-0.75231,-0.43434,-0.49536,-0.83713,-0.48332,-0.25615,-0.86603,-0.5,0.0,-0.83713,-0.48332,0.25615,-0.75231,-0.43434,0.49536,-0.61701,-0.35623,0.70172,-0.44,-0.25403,0.86132,-0.23288,-0.13445,0.96317,-0.25975,-0.0696,-0.96317,-0.49075,-0.1315,-0.86132,-0.68818,-0.1844,-0.70172,-0.83909,-0.22483,-0.49536,-0.9337,-0.25018,-0.25615,-0.96593,-0.25882,0.0,-0.9337,-0.25018,0.25615,-0.83909,-0.22483,0.49536,-0.68818,-0.1844,0.70172,-0.49075,-0.1315,0.86132,-0.25975,-0.0696,0.96317,-0.26891,-0.0,-0.96317,-0.50807,0.0,-0.86132,-0.71246,0.0,-0.70172,-0.86869,-0.0,-0.49536,-0.96664,0.0,-0.25615,-1.0,0.0,0.0,-0.96664,0.0,0.25615,-0.86869,0.0,0.49536,-0.71246,0.0,0.70172,-0.50807,0.0,0.86132,-0.26891,-0.0,0.96317,-0.25975,0.0696,-0.96317,-0.49075,0.1315,-0.86132,-0.68818,0.1844,-0.70172,-0.83909,0.22483,-0.49536,-0.9337,0.25018,-0.25615,-0.96593,0.25882,0.0,-0.9337,0.25018,0.25615,-0.83909,0.22483,0.49536,-0.68818,0.1844,0.70172,-0.49075,0.1315,0.86132,-0.25975,0.0696,0.96317,-0.23288,0.13445,-0.96317,-0.44,0.25403,-0.86132,-0.61701,0.35623,-0.70172,-0.75231,0.43434,-0.49536,-0.83713,0.48332,-0.25615,-0.86603,0.5,0.0,-0.83713,0.48332,0.25615,-0.75231,0.43434,0.49536,-0.61701,0.35623,0.70172,-0.44,0.25403,0.86132,-0.23288,0.13445,0.96317,-0.19015,0.19015,-0.96317,-0.35926,0.35926,-0.86132,-0.50378,0.50378,-0.70172,-0.61426,0.61426,-0.49536,-0.68352,0.68352,-0.25615,-0.70711,0.70711,0.0,-0.68352,0.68352,0.25615,-0.61426,0.61426,0.49536,-0.50378,0.50378,0.70172,-0.35926,0.35926,0.86132,-0.19015,0.19015,0.96317,-0.13445,0.23288,-0.96317,-0.25403,0.44,-0.86132,-0.35623,0.61701,-0.70172,-0.43434,0.75231,-0.49536,-0.48332,0.83713,-0.25615,-0.5,0.86603,0.0,-0.48332,0.83713,0.25615,-0.43434,0.75231,0.49536,-0.35623,0.61701,0.70172,-0.25403,0.44,0.86132,-0.13445,0.23288,0.96317,-0.0696,0.25975,-0.96317,-0.1315,0.49075,-0.86132,-0.1844,0.68818,-0.70172,-0.22483,0.83909,-0.49536,-0.25018,0.9337,-0.25615,-0.25882,0.96593,0.0,-0.25018,0.9337,0.25615,-0.22483,0.83909,0.49536,-0.1844,0.68818,0.70172,-0.1315,0.49075,0.86132,-0.0696,0.25975,0.96317,-0.0,0.26891,-0.96317,0.0,0.50807,-0.86132,0.0,0.71246,-0.70172,-0.0,0.86869,-0.49536,0.0,0.96664,-0.25615,0.0,1.0,0.0,-0.0,0.96664,0.25615,0.0,0.86869,0.49536,0.0,0.71246,0.70172,0.0,0.50807,0.86132,0.0,0.26891,0.96317,0.0696,0.25975,-0.96317,0.1315,0.49075,-0.86132,0.1844,0.68818,-0.70172,0.22483,0.83909,-0.49536,0.25018,0.9337,-0.25615,0.25882,0.96593,0.0,0.25018,0.9337,0.25615,0.22483,0.83909,0.49536,0.1844,0.68818,0.70172,0.1315,0.49075,0.86132,0.0696,0.25975,0.96317,0.13445,0.23288,-0.96317,0.25403,0.44,-0.86132,0.35623,0.61701,-0.70172,0.43434,0.75231,-0.49536,0.48332,0.83713,-0.25615,0.5,0.86603,0.0,0.48332,0.83713,0.25615,0.43434,0.75231,0.49536,0.35623,0.61701,0.70172,0.25403,0.44,0.86132,0.13445,0.23288,0.96317,0.0,0.0,-1.0,0.19015,0.19015,-0.96317,0.35926,0.35926,-0.86132,0.50378,0.50378,-0.70172,0.61426,0.61426,-0.49536,0.68352,0.68352,-0.25615,0.70711,0.70711,0.0,0.68352,0.68352,0.25615,0.61426,0.61426,0.49536,0.50378,0.50378,0.70172,0.35926,0.35926,0.86132,0.19015,0.19015,0.96317,0.23288,0.13445,-0.96317,0.44,0.25403,-0.86132,0.61701,0.35623,-0.70172,0.75231,0.43434,-0.49536,0.83713,0.48332,-0.25615,0.86603,0.5,0.0,0.83713,0.48332,0.25615,0.75231,0.43434,0.49536,0.61701,0.35623,0.70172,0.44,0.25403,0.86132,0.23288,0.13445,0.96317,0.0,-0.0,1.0,0.25975,0.0696,-0.96317,0.49075,0.1315,-0.86132,0.68818,0.1844,-0.70172,0.83909,0.22483,-0.49536,0.9337,0.25018,-0.25615,0.96593,0.25882,0.0,0.9337,0.25018,0.25615,0.83909,0.22483,0.49536,0.68818,0.1844,0.70172,0.49075,0.1315,0.86132,0.25975,0.0696,0.96317,0.26891,-0.0,-0.96317,0.50807,-0.0,-0.86132,0.71246,0.0,-0.70172,0.86869,0.0,-0.49536,0.96664,-0.0,-0.25615,1.0,-0.0,0.0,0.96664,0.0,0.25615,0.86869,0.0,0.49536,0.71246,-0.0,0.70172,0.50807,0.0,0.86132,0.26891,-0.0,0.96317,0.25975,-0.0696,-0.96317,0.49075,-0.1315,-0.86132,0.68818,-0.1844,-0.70172,0.83909,-0.22483,-0.49536,0.9337,-0.25018,-0.25615,0.96593,-0.25882,0.0,0.9337,-0.25018,0.25615,0.83909,-0.22483,0.49536,0.68818,-0.1844,0.70172,0.49075,-0.1315,0.86132,0.25975,-0.0696,0.96317,0.23288,-0.13445,-0.96317,0.44,-0.25403,-0.86132,0.61701,-0.35623,-0.70172,0.75231,-0.43434,-0.49536,0.83713,-0.48332,-0.25615,0.86603,-0.5,0.0,0.83713,-0.48332,0.25615,0.75231,-0.43434,0.49536,0.617,-0.35623,0.70172,0.44,-0.25403,0.86132,0.23288,-0.13445,0.96317,0.19015,-0.19015,-0.96317,0.35926,-0.35926,-0.86132,0.50378,-0.50378,-0.70172,0.61426,-0.61426,-0.49536,0.68352,-0.68352,-0.25615,0.70711,-0.70711,-0.0,0.68352,-0.68352,0.25615,0.61426,-0.61426,0.49536,0.50378,-0.50378,0.70172,0.35926,-0.35926,0.86132,0.19015,-0.19015,0.96317,0.13445,-0.23288,-0.96317,0.25403,-0.44,-0.86132,0.35623,-0.61701,-0.70172,0.43434,-0.75231,-0.49536,0.48332,-0.83713,-0.25615,0.5,-0.86603,0.0,0.48332,-0.83713,0.25615,0.43434,-0.75231,0.49536,0.35623,-0.617,0.70172,0.25403,-0.44,0.86132,0.13445,-0.23288,0.96317,0.0696,-0.25975,-0.96317,0.1315,-0.49075,-0.86132,0.1844,-0.68818,-0.70172,0.22483,-0.83909,-0.49536,0.25018,-0.9337,-0.25615,0.25882,-0.96593,0.0,0.25018,-0.9337,0.25615,0.22483,-0.83909,0.49536,0.1844,-0.68818,0.70172,0.1315,-0.49075,0.86132,0.0696,-0.25975,0.96317,0.0,-0.26891,-0.96317,0.0,-0.86869,-0.49536,0.0,-0.96664,-0.25615,0.0,-1.0,-0.0,0.0,-0.96664,0.25615,0.0,-0.86869,0.49536,0.0,-0.71246,0.70172,0.0,-0.50807,0.86132,0.0,-0.26891,0.96317];
}
