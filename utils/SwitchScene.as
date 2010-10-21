package org.shift_style.utils {
	import jp.progression.casts.*;
	import jp.progression.commands.display.*;
	import jp.progression.commands.lists.*;
	import jp.progression.commands.managers.*;
	import jp.progression.commands.media.*;
	import jp.progression.commands.net.*;
	import jp.progression.commands.tweens.*;
	import jp.progression.commands.*;
	import jp.progression.data.*;
	import jp.progression.events.*;
	import jp.progression.executors.*;
	import jp.progression.scenes.*;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	/**
	 * Progressionのシーン移動が簡単に行えるクラスです.
	 * 
	 * <p>IndexScene の atSceneLoad または atSceneInit でインスタンスを作成するだけで、すぐ使えます。
	 * 動作としては単純に new Goto() しているだけなので<strong>構築次第ではバグります</strong>のでご使用の際は自己責任でお願いします。</p>
	 * 
	 * <p><strong>Exsample</strong></p>
	 * <listing>new SwitchScene( this.manager.stage );</listing>
	 * 
	 * <p><strong>操作の仕方</strong></p>
	 * <pre>
	 * Enterキーン : シーン一覧を呼び出します。
	 * 
	 * シーン一覧呼び出し後
	 * Leftキー : 左にカーソルを移動させます。
	 * Rightキー : 右にカーソルを移動させます。
	 * Enterキー : 選択しているシーンに移動します。
	 * Escapeキー : シーン一覧を閉じます。
	 * </pre>
	 * 
	 * @author axcel-work
	 * @version 1.0
	 * @since 2010/06/11
	 * @usage
	 */
	public class SwitchScene extends CastSprite {
		/**
		 * 表示したい Stage インスタンスを設定します。
		 */
		public var contenner:Stage;
		
		private var _indexScene:SceneObject;
		
		private var _bg:Sprite;
		private var _wrapSprite:Sprite;
		private var _sceneId:SceneId = new SceneId( "/index" );
		private var _nowCnt:int = 0;
		
		private var _callKey:uint = 40;
		private var _selectKey:uint = 13;
		private var _escapeKey:uint = 27;
		private var _leftKey:uint = 37;
		private var _rightKey:uint = 39;
		private var _configKey:uint = 40;
		
		/**
		 * 新しい SwitchScene インスタンスを作成します。
		 */
		public function SwitchScene( contenner:Stage, initObject:Object = null ) {
			// 親クラスを初期化します。
			super( initObject );
			
			this.contenner = contenner;
			
			this._indexScene = SceneObject( getSceneBySceneId( new SceneId( "/index" ) ) );
			this.contenner.addEventListener( KeyboardEvent.KEY_DOWN, keyEnterHandler );
		}
		
		
		/**
		 * ユーザーが Stage からキーボード操作をしたときに送出されます。
		 * このイベントでは Enter キーを判別して、各インスタンスを作成後 atInit メソッドをキックします。
		 */
		private function keyEnterHandler(e:KeyboardEvent):void {
			if ( e.keyCode == this._callKey ) {
				this.contenner.removeEventListener( KeyboardEvent.KEY_DOWN, keyEnterHandler );
				
				// Created BackGround
				this._bg = new Sprite();
				this._bg.graphics.beginFill( 0x000000, 0.0 );
				this._bg.graphics.drawRect( 0, 0, this.contenner.stageWidth, this.contenner.stageHeight );
				this._bg.graphics.endFill();
				this._bg.mouseEnabled = true;
				
				// Cerated Scenes
				this._wrapSprite = new Sprite();
				
				for (var i:int = 0; i < this._indexScene.root.scenes.length + 1; i++) {
					var _box:SceneBox = new SceneBox( i );
					_box.x = 140 * i + 30;
					_box.y = 30;
					_box.name = "box" + i;
					
					this._wrapSprite.addChild( _box );
				}
				
				this._wrapSprite.graphics.beginFill( 0x000000, 0.5 );
				this._wrapSprite.graphics.drawRoundRect( 0, 0, this._wrapSprite.width + 60, 180, 30 );
				this._wrapSprite.graphics.endFill();
				
				if ( this.contenner.stageWidth < this._wrapSprite.width ) {
					var _scale:Number = this.contenner.stageWidth / this._wrapSprite.width;
					
					this._wrapSprite.scaleX = _scale - 0.05;
					this._wrapSprite.scaleY = _scale - 0.05;
					
					for (var j:int = 0; j < this._indexScene.root.scenes.length + 1; j++) {
						SceneBox( this._wrapSprite.getChildByName( "box" + j ) ).scaleText( _scale - 0.05 );
					}
					
				}
				
				this.atInit();
			}
		}
		
		
		/**
		 * keyEnterHandler から各インスタンスを作成後送出されます。
		 * このイベントでは 作成したインスタンスの位置設定、addChild、イージングを行い、 keyDownHandler イベントを設定します。
		 */
		private function atInit():void {
			new SerialList( null,
				new Prop( this._bg, { alpha: 0 } ),
				new Prop( this._wrapSprite, {
					x: this.contenner.stageWidth / 2 - this._wrapSprite.width / 2, 
					y: this.contenner.stageHeight / 2 - this._wrapSprite.height / 2
				} ),
				
				new AddChild( this.contenner, this._bg ),
				new AddChild( this.contenner, this._wrapSprite ),
				[
					new DoTweener( this._bg, { alpha: 1, transition: "easeOutExpo", time: 0.55 } ),
					new DoTweener( this._wrapSprite, { alpha: 1, transition: "easeOutExpo", time: 0.55 } )
				]
			).execute();
			
			
			SceneBox( this._wrapSprite.getChildByName( "box" + this._nowCnt ) ).select();
			this.contenner.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
		}
		
		
		/**
		 * ユーザーが Stage からキーボード操作をしたときに送出されます。
		 * このイベントでは Enter, Left, Right, Escape キーを判別して、それぞれ atGoto, LeftMove, RightMove, close メソッドをキックします。
		 */
		private function keyDownHandler(e:KeyboardEvent):void {
			if ( e.keyCode == this._selectKey ) {
				this.atGoto();
			}
			else if ( e.keyCode == this._rightKey ) {
				if ( this._nowCnt != this._indexScene.root.scenes.length ) {
					this.RightMove();
				}
			}
			else if ( e.keyCode == this._leftKey ) {
				if ( this._nowCnt != 0 ) {
					this.LeftMove();
				}
			}
			else if ( e.keyCode == this._escapeKey ) {
				this.close();
			}
			else if ( e.keyCode == this._configKey ) {
				this.config();
			}
			
		}
		
		/**
		 * ユーザーが Enter からキーボード操作をしたときに送出されます。
		 * このイベントでは 設定された SceneId のシーンに移動します。
		 */
		private function atGoto():void {
			new SerialList( null, 
				new Goto( this._sceneId ),
				this.close()
			).execute();
		}
		
		/**
		 * ユーザーが Stage からキーボード操作をしたときに送出されます。
		 * このイベントでは Enter, Left, Right キーを判別して、それぞれ close, LeftMove, RightMove メソッドをキックします。
		 */
		private function LeftMove():void {
			SceneBox( this._wrapSprite.getChildByName( "box" + this._nowCnt ) ).unselect();
			this._nowCnt--;
			SceneBox( this._wrapSprite.getChildByName( "box" + this._nowCnt ) ).select();
			
			this._sceneId = SceneBox( this._wrapSprite.getChildByName( "box" + this._nowCnt ) )._sceneID;
		}
		
		
		/**
		 * keyDownHandler から Left キーを押したあと送出されます。
		 */
		private function RightMove():void {
			SceneBox( this._wrapSprite.getChildByName( "box" + this._nowCnt ) ).unselect();
			this._nowCnt++;
			SceneBox( this._wrapSprite.getChildByName( "box" + this._nowCnt ) ).select();
			
			this._sceneId = SceneBox( this._wrapSprite.getChildByName( "box" + this._nowCnt ) )._sceneID;
		}
		
		
		/**
		 * keyDownHandler から Escape キーを押したあと送出されます。
		 */
		private function close():void {
			this.contenner.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
			this.contenner.addEventListener( KeyboardEvent.KEY_DOWN, keyEnterHandler );
			
			this._nowCnt = 0;
			this._sceneId = new SceneId( "/index" );
			
			new SerialList( null,
				[
					new DoTweener( this._bg, { alpha: 0, transition: "easeOutExpo", time: 0.55 } ),
					new DoTweener( this._wrapSprite, { alpha: 0, transition: "easeOutExpo", time: 0.55 } )
				],
				new RemoveChild( this.contenner, this._bg ),
				new RemoveChild( this.contenner, this._wrapSprite )
			).execute();
		}
		
		
		
		
		private function config():void {
			trace( "config" );
			
			
		}
		
		
		
	}
}


import jp.progression.scenes.*;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;

import org.shift_style.text.ExTextField;


class SceneBox extends Sprite {
	public var _sceneID:SceneId;
	
	private var _indexScene:SceneObject;
	
	private var _text:ExTextField;
	
	/**
	 * 新しい SceneBox インスタンスを作成します.
	 * 
	 * <p>このインスタンスは親クラス SwitchScene から呼び出されます。ユーザ自身が呼び出すことはできません。</p>
	 * 
	 * @param	_num
	 */
	public function SceneBox( _num:int) {
		this._indexScene = SceneObject( getSceneBySceneId( new SceneId( "/index" ) ) );
		
		this.graphics.beginFill( 0x000000, 0.0 );
		this.graphics.drawRoundRect( 0, 0, 120, 120, 30 );
		this.graphics.endFill();
		
		
		// Created Icon
		var _icon:Sprite = new Sprite();
		_icon.graphics.beginFill( 0xFEFEFE, 1.0 );
		_icon.graphics.drawRect( 0, 0, 90, 90 );
		_icon.graphics.endFill();
		_icon.x = _icon.y = 15;
		this.addChild( _icon );
		
		var _iText:ExTextField = new ExTextField();
		_iText.setProperties( { autoSize: "left" } );
		_iText.setTextFormats( { color: 0x333333, size: 35, font: "_sans", bold: true } );
		_iText.text = "0" + _num.toString();
		_iText.x = _icon.width - _iText.width - 4;
		_iText.y = _icon.height - _iText.height + 4;
		_icon.addChild( _iText );
		
		
		// Created TextField
		this._text = new ExTextField();
		this._text.setProperties( { autoSize: "left" } );
		this._text.setTextFormats( { color: 0xFFFFFF, size: 14, font: "_sans" } );
		this._text.y = 125;
		this._text.visible = false;
		this.addChild( _text );
		
		var dp1:DropShadowFilter = new DropShadowFilter();
		dp1.alpha = 0;
		_iText.filters = [dp1];
		
		
		// Created DropShadow
		var dp:DropShadowFilter = new DropShadowFilter();
		dp.blurX = dp.blurY = 0;
		dp.distance = 2;
		this._text.filters = [ dp ];
		
		// SceneID と TextField.text の設定
		if ( _num == 0 ) {
			this._sceneID = new SceneId( "/index" );
			this._text.text = this._indexScene.root.name;
		}
		else {
			this._sceneID = this._indexScene.root.scenes[ _num - 1 ].sceneId;
			this._text.text = this._indexScene.root.scenes[ _num - 1 ].name;
		}
		
		// TextField のXの位置の設定
		this._text.x = this.width / 2 - this._text.width / 2;
	}
	
	
	public function select():void {
		this.graphics.clear();
		this.graphics.lineStyle( 2, 0xcccccc, 1.0 );
		this.graphics.beginFill( 0x000000, 0.7 );
		this.graphics.drawRoundRect( 0, 0, 120, 120, 20 );
		this.graphics.endFill();
		
		this._text.visible = true;
	}
	
	public function unselect():void {
		this.graphics.clear();
		this.graphics.beginFill( 0x000000, 0.0 );
		this.graphics.drawRoundRect( 0, 0, 120, 120, 20 );
		this.graphics.endFill();
		
		this._text.visible = false;
	}
	
	
	public function scaleText( _scale:Number ):void {
		this._text.scaleX = this._text.scaleY = 1 + _scale;
		this._text.x = this.width / 2 - this._text.width / 2;
	}
	
}