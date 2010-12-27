package org.shift_style.utils {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.filters.BlurFilter;
	
	import flash.utils.getTimer;
	import flash.text.TextField;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author axcel-work
	 */
	public class BitmapAAText{
		public static var AA_MARGIN_WIDTH:Number   = 16;		// 生成するビットマップに多少の余白を持たせる
		public static var AA_MARGIN_HEIGHT:Number  = 16;		// 
		public static var AA_BMP_MAX_WIDTH:Number  = 2800;		// 生成するビットマップの最大サイズ
		public static var AA_BMP_MAX_HEIGHT:Number = 2800;		//
		public static var AA_MAX_SCALE:Number      = 3;		// 最大拡大率
		public static var AA_BLUR_STRENGTH:Number  = 2;		// ぼかしの強さ
		public static var AA_BLUR_QUALITY:Number   = 2;		// ぼかしのクオリティ
		
		public static var _quality:String = "BEST";
		
		public static function getAAText(target:TextField, bBest:Boolean):BitmapData {
			//if (!(typeof target == "movieclip" || target instanceof TextField)) return;
			
			var startTime:Number = getTimer();
			var oldQuality:String = _quality;
			_quality = "HIGH";	
			
			// 結果BitmapDataのサイズを取得
			var aaWidth:Number  = (target.textWidth || target.width ) + AA_MARGIN_WIDTH;
			var aaHeight:Number = (target.textHeight || target.height) + AA_MARGIN_HEIGHT;
			
			// アンチエイリアス処理の設定
			var aaScale:Number    = Math.min(AA_MAX_SCALE, Math.min(AA_BMP_MAX_WIDTH / aaWidth, AA_BMP_MAX_HEIGHT / aaHeight));
			var aaStrength:Number = AA_BLUR_STRENGTH;
			var aaQuality:Number  = AA_BLUR_QUALITY;
			
			// 「拡大用BitmapData」と「結果用BitmapData」を準備
			var bmpCanvas:BitmapData = new BitmapData(aaWidth * aaScale, aaHeight * aaScale, true, 0x00000000);
			var bmpResult:BitmapData = new BitmapData(aaWidth, aaHeight, true, 0x000000);
			
			// BESTクオリティでの描画を行うか？
			// AA(ぼかし)処理をFlash内部描画に任せます。
			// → ほとんどのサイズで綺麗だけど処理重いよ :-(
			var myMatrix:Matrix = new Matrix();
			var myColor:ColorTransform = new ColorTransform();
			
			if (bBest) {
				_quality = "BEST";
				// 1.拡大描画
				myMatrix.scale(aaScale, aaScale);
				bmpCanvas.draw( target, myMatrix, new ColorTransform(), null, null, true);		
				
				// 2.縮小描画
				myColor.alphaMultiplier= 1.3;
				myMatrix.a = myMatrix.d = 1;
				myMatrix.scale(1 / aaScale, 1 / aaScale);
				bmpResult.draw(bmpCanvas, myMatrix, myColor, null, null, true);
			}
			else {
				// 1.拡大描画
				myMatrix.scale(aaScale, aaScale);
				bmpCanvas.draw(target, myMatrix, new ColorTransform(), null, null, true);
				
				// 2.ぼかし処理
				// ToDo:フォントサイズや用途でパラメータを弄る必要有
				var myFilter:BlurFilter = new BlurFilter(aaStrength, aaStrength, aaQuality);
				bmpCanvas.applyFilter(bmpCanvas, new Rectangle(0, 0, bmpCanvas.width, bmpCanvas.height), new Point(0, 0), myFilter);
				bmpCanvas.draw(target, myMatrix, new ColorTransform(), null, null, true);
				
				// 3.縮小描画
				myColor.alphaMultiplier= 1.1;
				myMatrix.a = myMatrix.d = 1;
				myMatrix.scale(1 / aaScale, 1 / aaScale);
				bmpResult.draw(bmpCanvas, myMatrix, myColor, null, null, true);
				bmpResult.draw(bmpCanvas, myMatrix, new ColorTransform(), null, null, true);
			}
			
			// 後処理
			bmpCanvas.dispose();
			_quality = oldQuality;
			
			trace("scale:" + aaScale + " time:" + (getTimer() - startTime));
			return bmpResult;
		}
	}
}