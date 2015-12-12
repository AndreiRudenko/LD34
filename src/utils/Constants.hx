package utils;

class Constants {
	// collision group
	public static inline var GROUP_ALL:Int = 0xFFFFFFFF;      	// 11111111111111111111111111111111
	public static inline var GROUP_SCENE:Int = 0x00000001;    	// 00000000000000000000000000000001
	public static inline var GROUP_ENEMY:Int = 0x00000002;   	// 00000000000000000000000000000010
	public static inline var GROUP_ENEMY2:Int = 0x00000004;	    // 00000000000000000000000000000100

	// wall types
	public static inline var GROUP_WALL1:Int = 0x00000100;		// 00000000000000000000000100000000
	public static inline var GROUP_WALL2:Int = 0x00000200;		// 00000000000000000000001000000000


	// Players
	public static inline var GROUP_PLAYER1:Int = 0x00010000;	// 00000000000000010000000000000000
	public static inline var GROUP_PLAYER2:Int = 0x00020000;	// 00000000000000100000000000000000
	public static inline var GROUP_PLAYER3:Int = 0x00040000;	// 00000000000001000000000000000000
	public static inline var GROUP_PLAYER4:Int = 0x00080000;	// 00000000000010000000000000000000
	public static inline var GROUP_PLAYER5:Int = 0x00100000;	// 00000000000100000000000000000000
	public static inline var GROUP_PLAYER6:Int = 0x00200000;	// 00000000001000000000000000000000
	public static inline var GROUP_PLAYER7:Int = 0x00400000;	// 00000000010000000000000000000000
	public static inline var GROUP_PLAYER8:Int = 0x00800000;	// 00000000100000000000000000000000

	public static inline var EPSILON:Float = 1.0E-9;
	
	public static var MIN_VALUE (get, null):Float;
	public static var MAX_VALUE (get, null):Float;
	
	
	private static inline function get_MIN_VALUE ():Float {
		
		#if flash
		
		return untyped __global__ ["Number"].MIN_VALUE;
		
		#elseif js
		
		return untyped __js__ ("Number.MIN_VALUE");
		
		#else
		
		return 2.2250738585072014e-308;
		
		#end
		
	}
	
	
	private static inline function get_MAX_VALUE ():Float {
		
		#if flash
		
		return untyped __global__ ["Number"].MAX_VALUE;
		
		#elseif js
		
		return untyped __js__ ("Number.MAX_VALUE");
		
		#else
		
		return 1.7976931348623158e+308;
		
		#end
		
	}
}