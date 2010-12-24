package org.shift_style.debug.inspector {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	/**
	 * DisplayInspectorからの情報を表示させるパネルです.
	 *
	 * <p>この DisplayInspector インスタンスを押下すると半透明になります。</p>
	 * 
	 * @author axcel-work
	 * @version 0.1
	 * @since 2010/07/02
	 * @usage
	 * 
	 */
	public class  DisplayInspectorPanel extends Sprite{
		private var _stage:Stage;
		
		private var _topLine:Shape;
		private var _middleLine:Shape;
		private var _bottomLine:Shape;
		
		// 
		private var _LeftPanel:LeftPanel;
		private var _RightPanel:RightPanel;
		
		private var isAlpha:Boolean = true;
		
		/**
		 * 新しい DisplayInspectorPanel インスタンスを作成します。
		 * @param	_stage Stage インスタンス
		 */
		public function DisplayInspectorPanel( _stage:Stage ) {
			this.name = "Configpanel";
			this.mouseChildren = false;
			this.addEventListener( MouseEvent.CLICK, clickHandler );
			
			this._stage = _stage;
			
			// BackGround
			this._topLine = new Shape();
			this.createdShape( this._topLine, 0xBBB9BA, 0, this._stage.stageWidth, 1 );
			
			this._middleLine = new Shape();
			this.createdShape( this._middleLine, 0xF3F3F3, 1, this._stage.stageWidth, 2 );
			
			this._bottomLine = new Shape();
			this.createdShape( this._bottomLine, 0x505050, 3, this._stage.stageWidth,1 );
			
			this.addChild( this._topLine );
			this.addChild( this._middleLine );
			this.addChild( this._bottomLine );
			
			this._LeftPanel = new LeftPanel();
			this.addChild( this._LeftPanel );
			
			this._RightPanel = new RightPanel( _stage.stageWidth );
			this._RightPanel.x = 200;
			this._RightPanel.y = 4;
			this.addChild( this._RightPanel );
		}
		
		
		private function clickHandler(e:MouseEvent):void {
			if ( isAlpha ) {
				this.isAlpha = false;
				this.alpha = 0.7;
			}
			else {
				this.isAlpha = true;
				this.alpha = 1.0;
			}
		}
		
		
		private function createdShape( target:Shape, color:uint, offset:int, _w:int, _h:int ):void {
			target.graphics.clear();
			target.graphics.beginFill( color, 1.0 );
			target.graphics.drawRect( 0, offset, _w, _h );
			target.graphics.endFill();
		}
		
		/**
		 * ポインティングデバイス直下のインスタンスの情報を表示します
		 * @param	_object インスタンスの型
		 * @param	_name インスタンスの名前
		 * @param	_xpos インスタンスの水平位置
		 * @param	_ypos インスタンスの垂直位置
		 * @param	_width インスタンスの幅
		 * @param	_height インスタンスの高さ
		 */
		public function setProperties( _object:String, _name:String, _xpos:String, _ypos:String, _width:String, _height:String ):void {
			this._LeftPanel.setText( _object );
			this._RightPanel.setText( _name, _xpos, _ypos, _width, _height );
		}
		
		/**
		 * リサイズイベント発行時にこのメソッドが呼び出されます
		 * @param	_w Stage の幅
		 * @param	_h Stage の高さ
		 */
		public function update( _w:Number, _h:Number ):void {
			this.createdShape( this._topLine, 0xBBB9BA, 0, _w, 1 );
			this.createdShape( this._middleLine, 0xF3F3F3, 1, _w, 2 );
			this.createdShape( this._bottomLine, 0x505050, 3, _w, 1 );
			
			this._RightPanel.update( this._stage.stageWidth );
		}
		
	}
	
}


import flash.display.Shape;
import flash.display.Sprite;
import org.shift_style.text.ExTextField;
import flash.display.GradientType;
import flash.geom.Matrix;

class LeftPanel extends Sprite {
	private var _txtObject:ExTextField;
	
	public function LeftPanel() {
		this.graphics.beginFill( 0xd6dde5, 1.0 );
		this.graphics.drawRect( 0, 4, 199, 125 );
		this.graphics.endFill();
		
		var line:Shape = new Shape();
		line.graphics.beginFill( 0xa3a3a3 );
		line.graphics.drawRect( 199, 4, 1, 125 );
		line.graphics.endFill();
		
		this.addChild( line );
		
		var matrix:Matrix = new Matrix();
		matrix.createGradientBox( 199, 30, Math.PI/2);
		var bg:Shape = new Shape();
		bg.graphics.beginGradientFill( GradientType.LINEAR, [ 0x5C93D5, 0x1553AA ], [ 1 ,1 ], [ 0, 255 ], matrix );
		bg.graphics.drawRect( 0, 4, 199, 30 );
		bg.graphics.endFill();
		
		this.addChild( bg );
		
		this._txtObject = new ExTextField();
		this._txtObject.setProperties( { autoSize: "left" } );
		this._txtObject.setTextFormats( { size: 12, font: "_ゴシック", color: 0xFFFFFF } );
		this._txtObject.x = 20;
		this._txtObject.y = 8;
		
		this.addChild( this._txtObject );
	}
	
	
	public function setText( _object:String ):void {
		this._txtObject.text = "[" + _object + "]";
	}
	
}


import flash.display.Shape;
import flash.display.Sprite;
import org.shift_style.text.ExTextField;

class RightPanel extends Sprite {
	private var _Line1:Shape;
	private var _Line2:Shape;
	private var _Line3:Shape;
	private var _Line4:Shape;
	private var _Line5:Shape;
	private var _Line6:Shape;
	
	private var _showName:ExTextField;
	private var _showXpos:ExTextField;
	private var _showYpos:ExTextField;
	private var _showWidth:ExTextField;
	private var _showHeight:ExTextField;
	
	private var _txtName:ExTextField;
	private var _txtXpos:ExTextField;
	private var _txtYpos:ExTextField;
	private var _txtWidth:ExTextField;
	private var _txtHeight:ExTextField;
	
	private var _xpos:int = 75;
	
	public function RightPanel( _w:Number ) {
		this._Line1 = new Shape();
		this._Line2 = new Shape();
		this._Line3 = new Shape();
		this._Line4 = new Shape();
		this._Line5 = new Shape();
		this._Line6 = new Shape();
		
		this.createdShape( this._Line1, 0xFFFFFF, _w, 0 );
		this.createdShape( this._Line2, 0xEEEEEE, _w, 25 );
		this.createdShape( this._Line3, 0xFFFFFF, _w, 50 );
		this.createdShape( this._Line4, 0xEEEEEE, _w, 75 );
		this.createdShape( this._Line5, 0xFFFFFF, _w, 100 );
		
		this.addChild( this._Line1 );
		this.addChild( this._Line2 );
		this.addChild( this._Line3 );
		this.addChild( this._Line4 );
		this.addChild( this._Line5 );
		
		this._Line6.graphics.beginFill( 0xa3a3a3 );
		this._Line6.graphics.drawRect( 70, 0, 1, 125 );
		this._Line6.graphics.endFill();
		this.addChild( this._Line6 );
		
		this._showName = new ExTextField();
		this._showName.setProperties( { autoSize: "left" } );
		this._showName.setTextFormats( { size: 12, font: "_ゴシック" } );
		this._showName.x = 5;
		this._showName.y = 3;
		this._showName.text = "name";
		
		this._showXpos = new ExTextField();
		this._showXpos.setProperties( { autoSize: "left" } );
		this._showXpos.setTextFormats( { size: 12, font: "_ゴシック" } );
		this._showXpos.x = 5;
		this._showXpos.y = 28;
		this._showXpos.text = "x";
		
		this._showYpos = new ExTextField();
		this._showYpos.setProperties( { autoSize: "left" } );
		this._showYpos.setTextFormats( { size: 12, font: "_ゴシック" } );
		this._showYpos.x = 5;
		this._showYpos.y = 53;
		this._showYpos.text = "y";
		
		this._showWidth = new ExTextField();
		this._showWidth.setProperties( { autoSize: "left" } );
		this._showWidth.setTextFormats( { size: 12, font: "_ゴシック" } );
		this._showWidth.x = 5;
		this._showWidth.y = 78;
		this._showWidth.text = "width";
		
		this._showHeight = new ExTextField();
		this._showHeight.setProperties( { autoSize: "left" } );
		this._showHeight.setTextFormats( { size: 12, font: "_ゴシック" } );
		this._showHeight.x = 5;
		this._showHeight.y = 103;
		this._showHeight.text = "height";
		
		this.addChild( this._showName );
		this.addChild( this._showXpos );
		this.addChild( this._showYpos );
		this.addChild( this._showWidth );
		this.addChild( this._showHeight );
		
		this._txtName = new ExTextField();
		this._txtName.setProperties( { autoSize: "left" } );
		this._txtName.setTextFormats( { size: 12, font: "_ゴシック" } );
		this._txtName.x = this._xpos;
		this._txtName.y = 3;
		
		this._txtXpos = new ExTextField();
		this._txtXpos.setProperties( { autoSize: "left" } );
		this._txtXpos.setTextFormats( { size: 12, font: "_ゴシック" } );
		this._txtXpos.x = this._xpos;
		this._txtXpos.y = 28;
		
		this._txtYpos = new ExTextField();
		this._txtYpos.setProperties( { autoSize: "left" } );
		this._txtYpos.setTextFormats( { size: 12, font: "_ゴシック" } );
		this._txtYpos.x = this._xpos;
		this._txtYpos.y = 53;
		
		this._txtWidth = new ExTextField();
		this._txtWidth.setProperties( { autoSize: "left" } );
		this._txtWidth.setTextFormats( { size: 12, font: "_ゴシック" } );
		this._txtWidth.x = this._xpos;
		this._txtWidth.y = 78;
		
		this._txtHeight = new ExTextField();
		this._txtHeight.setProperties( { autoSize: "left" } );
		this._txtHeight.setTextFormats( { size: 12, font: "_ゴシック" } );
		this._txtHeight.x = this._xpos;
		this._txtHeight.y = 103;
		
		this.addChild( this._txtName );
		this.addChild( this._txtXpos );
		this.addChild( this._txtYpos );
		this.addChild( this._txtWidth );
		this.addChild( this._txtHeight );
	}
	
	public function setText( _name:String, _xpos:String, _ypos:String, _width:String, _height:String ):void {
		this._txtName.text = " " + _name;
		this._txtXpos.text = " " + _xpos;
		this._txtYpos.text = " " + _ypos;
		this._txtWidth.text = " " + _width;
		this._txtHeight.text = " " + _height;
	}
	
	private function createdShape( target:Shape, color:uint, _w:int, offset:int ):void {
		target.graphics.clear();
		target.graphics.beginFill( color, 1.0 );
		target.graphics.drawRect( 0, offset, _w, 25 );
		target.graphics.endFill();
	}
	
	public function update( _w:Number ):void {
		this.createdShape( this._Line1, 0xFFFFFF, _w, 0 );
		this.createdShape( this._Line2, 0xEEEEEE, _w, 25 );
		this.createdShape( this._Line3, 0xFFFFFF, _w, 50 );
		this.createdShape( this._Line4, 0xEEEEEE, _w, 75 );
		this.createdShape( this._Line5, 0xFFFFFF, _w, 100 );
	}
	
	
}

