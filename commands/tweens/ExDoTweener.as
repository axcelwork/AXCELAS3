package org.shift_style.commands.tweens {
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
	import jp.progression.scenes.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	
	import caurina.transitions.properties.FilterShortcuts;
	
	/**
	 * DoTweener を書き連ねていくのが面倒という自分に対して制作したProgression用クラスです.
	 * 
	 * <p><strong>Exsample</strong></p>
	 * <listing>new ExDoTweener( [ instance1, instance2, instance3, ... ], { x: 100, transition: "easeOutSine", time: 0.85 } )</listing>
	 * 
	 * <p>またプロパティを個別に設定することも可能です。</p>
	 * <p><strong>Exsample</strong></p>
	 * <listing>new ExDoTweener( [ instance1, instance2, instance3, ... ], { x: [ 100, 200 ], transition: "easeOutSine", time: 0.85 } )</listing>
	 * 
	 * <p>親の CommandExcurator をSerialList, ParallelList かを判断します。 </p>
	 * 
	 * @author axcel-work
	 * @version 0.1
	 * @since 2010/06/16
	 * @usage
	 * 
	 */
	public class ExDoTweener extends Command {
		private var _target:Array;
		private var _parameters:Object;
		
		/**
		 * 新しい ExDoTweener インスタンスを作成します。
		 */
		public function ExDoTweener( target:Array, parameters:Object, initObject:Object = null ) {
			// 親クラスを初期化します。
			super( _execute, _interrupt, initObject );
			
			this._target = target;
			this._parameters = parameters;
			
			FilterShortcuts.init();
		}
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _execute():void {
			if ( this.parent.className ==  "SerialList" ) {
				var sList:SerialList = new SerialList();
			}
			else if ( this.parent.className ==  "ParallelList" ) {
				var pList:ParallelList = new ParallelList();
			}
			
			// Add Command
			for (var i:int = 0; i < this._target.length; i++) {
				var stackParameters:Object = new Object();
				
				for (var name:String in this._parameters ) {
					
					if ( this._parameters[ name ] is Array ) {
						stackParameters[ name ] = this._parameters[ name ][ i ];
					}
					else {
						stackParameters[ name ] = this._parameters[ name ];
					}
					
				}
				
				if ( this.parent.className ==  "SerialList" ) {
					sList.addCommand( new DoTweener( this._target[ i ], stackParameters ) );
				}
				else if ( this.parent.className ==  "ParallelList" ) {
					pList.addCommand( new DoTweener( this._target[ i ], stackParameters ) );
				}
			}
			
			
			
			// Command Excutor
			if ( this.parent.className ==  "SerialList" ) {
				sList.execute();
				sList.addEventListener( ExecuteEvent.EXECUTE_COMPLETE, commandCompeleteHandler );
			}
			else if ( this.parent.className ==  "ParallelList" ) {
				pList.execute();
				pList.addEventListener( ExecuteEvent.EXECUTE_COMPLETE, commandCompeleteHandler );
			}
			
		}
		
		private function commandCompeleteHandler(e:ExecuteEvent):void {
			executeComplete();
		}
		
		/**
		 * 中断されるコマンドの実装です。
		 */
		private function _interrupt():void {
		}
		
		
		/**
		 * インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。
		 */
		//override public function clone():Command {
			//return new AddChildren( this );
		//}
		
	}

}