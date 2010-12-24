/**
 * ...
 * @author axcel-work
 */
package org.shift_style.utils {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class MaskLayout{
		
		/**
		 * 
		 * @param	target
		 * @param	_mask
		 */
		public static function atInit( target:DisplayObject, _mask:Sprite = null ):void {
			if ( _mask == null ) {
				_mask.graphics.beginFill( 0x000000, 1.0 );
				_mask.graphics.drawRect( 0, 0, target.width, target.height );
				_mask.graphics.endFill();
			}
			
			target.mask = _mask;
		}
		
	}
}