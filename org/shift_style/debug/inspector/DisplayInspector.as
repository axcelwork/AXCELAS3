package org.shift_style.debug.inspector {
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ContextMenuEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import org.shift_style.text.ExTextField;
	import org.shift_style.debug.inspector.DisplayInspectorPanel;
	
	/**
	 * インスタンスにポインティングデバイスをあてるとインスタンス名を表示させます.
	 * <p><strong>Exsample</strong></p>
	 * <listing>DisplayInspector.atInit( this, stage );</listing>
	 *
	 * <p>atInit() メソッドを実行するとコンテキストメニューに Display Inspector が追加されるのでそこから呼び出す。閉じるときは同じメニューをもう一度クリックする。</p>
	 * 
	 * @author axcel-work
	 * @version 0.1
	 * @since 2010/07/02
	 * @usage
	 * 
	 */
	public class DisplayInspector {
		private static var frame:Sprite;
		private static var txt:ExTextField;
		private static var bg:Sprite;
		private static var uiPanel:DisplayInspectorPanel;
		
		private static var STStage:Stage;
		private static var _name:String;
		private static var _stack:String = "";
		private static var isShow:Boolean = false;
		private static var isInit:Boolean = false;
		
		
		// Cnfig
		private static var isSize:Boolean = false;
		private static var isPosition:Boolean = false;
		
		private static var confingPanel:DisplayInspectorPanel;
		
		/**
		 * コンテキストメニューにこの InstanceName メニューを登録します。
		 * @param	target CntextMenu 登録先のインスタンス
		 * @param	_stage Stage インスタンス
		 */
		public static function atInit( target:Object, _stage:Stage ):void {
			var _show:ContextMenuItem = new ContextMenuItem( "Display Inspector" );
			_show.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, contextShowSelectHandler  );
			
			var cotext:ContextMenu = new ContextMenu();
			cotext.customItems = [ _show ];
			
			target.contextMenu = cotext;
			STStage = _stage;
			confingPanel = new DisplayInspectorPanel( STStage );
			
			STStage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
			STStage.addEventListener( Event.RESIZE, resizeHandler );
		}
		
		
		/**
		 * 
		 * @param	e
		 */
		private static function contextShowSelectHandler(e:ContextMenuEvent):void {
			if ( isShow ) {
				isShow = false;
				isInit = false;
				deletedFrame();
				STStage.removeChild( confingPanel );
			}
			else {
				isShow = true;
				STStage.addChild( confingPanel );
				confingPanel.y = STStage.stageHeight - confingPanel.height;
			}
		}
		
		
		/**
		 * 
		 * @param	e
		 */
		private static function mouseMoveHandler(e:MouseEvent):void {
			if ( isShow ) {
				// 現在ポインティング以下にあるインスタンス名を比較して同じ場合は起動させない
				if ( !isInit ) {
					createdFrame( e.target );
					_name = e.target.toString().match(/^\[.+ (.+)\]$/)[1];
					isInit = true;
				}
				else {
					if ( e.target.toString().match(/^\[.+ (.+)\]$/) != null ) {
						if ( _name != e.target.toString().match(/^\[.+ (.+)\]$/)[1] ) {
							deletedFrame();
							createdFrame( e.target );
						}
					}
				}
			}
			
		}
		
		
		/**
		 * 
		 * @param	e
		 */
		private static function createdFrame( target:Object ):void {
			frame = new Sprite();
			frame.graphics.lineStyle( 1, Math.random() * 0x10000000, 1.0 );
			frame.graphics.drawRect( 0, 0, target.width, target.height );
			frame.graphics.endFill();
			
			if ( target.parent != null ) {
				
				if ( target.parent.toString() == "[object Stage]" ) {
					frame.x = target.x;
					frame.y = target.y;
				}
				else {
					frame.x = target.localToGlobal( new Point( target.x, target.y ) ).x - target.x;
					frame.y = target.localToGlobal( new Point( target.x, target.y ) ).y - target.y;
				}
			}
			
			frame.mouseEnabled = false;
			frame.mouseChildren = false;
			frame.name = "prevFrame";
			
			txt = new ExTextField();
			txt.setProperties( { autoSize: "left" } );
			txt.setTextFormats( { font: "_ゴシック" } );
			txt.text = target.constructor.toString().match(/^\[.+ (.+)\]$/)[1];
			
			bg = new Sprite();
			bg.graphics.lineStyle( 1, 0x666666, 1.0 );
			bg.graphics.beginFill( 0xfdfdfd, 1.0 );
			bg.graphics.drawRect( 0, 0, txt.width, txt.height );
			bg.graphics.endFill();
			
			txt.x = bg.width / 2 - txt.width / 2;
			txt.y = bg.height / 2 - txt.height / 2;
			
			frame.addChild( bg );
			bg.addChild( txt );
			STStage.addChild( frame );
			
			confingPanel.setProperties( target.constructor.toString().match(/^\[.+ (.+)\]$/)[1], target.name, target.x, target.y, target.width, target.height );
			
		}
		
		
		/**
		 * 
		 */
		static private function deletedFrame():void {
			STStage.removeChild( STStage.getChildByName( "prevFrame" )  );
		}
		
		
		
		static private function resizeHandler(e:Event):void {
			confingPanel.y = STStage.stageHeight - confingPanel.height;
			
			confingPanel.update( STStage.stageWidth, STStage.stageHeight );
		}
		
		
	}
	
}