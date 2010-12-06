package org.shift_style.utils {

	/**
	 * 引数で渡された値を様々な形でフォーマットするクラスです.
	 * 
	 * @author axcel-work
	 * @version 0.1
	 * @since 2010/12/06
	 * @usage
	 * 
	 */
	public class FormatDigit {
		
		/**
		 * 数値を 0 付きでフォーマットします.
		 * 
		 * @param n		フォーマットしたい値です。
		 * @param digit 桁数を指定します
		 */
		public static function atFormatNum(n:Number, digit:Number):String{
			var s:String = String(n);
            while (s.length < digit) {
                s = "0" + s;
            }
            return s;
		}
	}
}
