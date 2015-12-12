package utils;

class Bits {
	/**
	 * Returns <code>x</code> AND <code>mask</code>.
	 */
	inline public static function getBits(x:Int, mask:Int):Int { return x & mask; }
	
	/**
	 * Returns true if <code>x</code> AND <code>mask</code> != 0. 
	 */
	inline public static function hasBits(x:Int, mask:Int):Bool { return (x & mask) != 0; }
	
	/**
	 * Returns true if <code>x</code> AND <code>mask</code> == <code>mask</code> (<code>x</code> includes all <code>mask</code> bits). 
	 */
	inline public static function incBits(x:Int, mask:Int):Bool { return (x & mask) == mask; }
	
	/**
	 * Returns <code>x</code> OR <code>mask</code>. 
	 */
	inline public static function setBits(x:Int, mask:Int):Int { return x | mask; }
	
	/**
	 * Returns <code>x</code> AND ~<code>mask</code>. 
	 */
	inline public static function clrBits(x:Int, mask:Int):Int {
		return x & ~mask;
	}
	
	/**
	 * Returns <code>x</code> ^ <code>mask</code>. 
	 */
	inline public static function invBits(x:Int, mask:Int):Int { return x ^ mask; }
	
	/**
	 * Sets all <code>mask</code> bits in <code>x</code> if <code>expr</code> is true,
	 * or clears all <code>mask</code> bits in <code>x</code> if <code>expr</code> is false. */
	inline public static function setBitsIf(x:Int, mask:Int, expr:Bool):Int {
		return expr ? (x | mask) : (x & ~mask);
	}
	
	/**
	 * Counts the number of "1"-bits.<br/>
	 * e.g. 00110111 has 5 bits set.
	 */
	inline public static function ones(x:Int) {
		x -= ((x >> 1) & 0x55555555);
		x = (((x >> 2) & 0x33333333) + (x & 0x33333333));
		x = (((x >> 4) + x) & 0x0f0f0f0f);
		x += (x >> 8);
		x += (x >> 16);
		return(x & 0x0000003f);
	}
	
	/**
	 * Bitwise rotates the integer <code>x</code> by <code>n</code> places to the left. 
	 */
	inline public static function rol(x:Int, n:Int) { return (x << n) | (x >>> (32 - n)); }
	
	/**
	 * Bitwise rotates the integer <code>x</code> by <code>n</code> places to the right. 
	 */
	inline public static function ror(x:Int, n:Int) { return (x >>> n) | (x << (32 - n)); }

}