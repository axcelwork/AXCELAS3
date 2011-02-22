package org.shift_style.commands.tweens {
	import caurina.transitions.properties.FilterShortcuts;

	import jp.progression.commands.*;
	import jp.progression.commands.lists.*;
	import jp.progression.events.*;

	/**
	 * DoGTween を書き連ねていくのが面倒という自分に対して制作したProgression用クラスです.
	 * 
	 * <p><strong>Exsample</strong></p>
	 * <listing>new ExDoGTween( [ instance1, instance2, instance3, ... ], time, { x: 100 }, {ease: Sine.easeOut} )</listing>
	 * 
	 * <p>またプロパティを個別に設定することも可能です。</p>
	 * <p><strong>Exsample</strong></p>
	 * <listing>new ExDoTweener( [ instance1, instance2, instance3, ... ], time, { x: [ 100, 200 ], alpha: 0}, {ease: Sine.easeOut} )</listing>
	 * 
	 * <p>親の CommandExcurator をSerialList, ParallelList かを判断します。 </p>
	 * 
	 * @author axcel-work
	 * @version 0.1
	 * @since 2011/02/18
	 * @usage
	 * 
	 */
	public class ExDoGTween extends Command {
		private var _target:Array;
		private var _parameters:Object;
		private var _time:Number;
		private var _props:*;
		
		/**
		 * 新しい ExDoTweener インスタンスを作成します。
		 */
		public function ExDoGTween( target:Array, time:Number, parameters:Object, props:*, initObject:Object = null ) {
			// 親クラスを初期化します。
			super( _execute, _interrupt, initObject );
			
			this._target = target;
			this._parameters = parameters;
			this._time = time;
			this._props = props;
			
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
				
				var stackProps:Object = new Object();
				
				for (var pName:String in this._props ) {
					
					if ( this._parameters[ pName ] is Array ) {
						stackProps[ pName ] = this._props[ pName ][ i ];
					}
					else {
						stackProps[ pName ] = this._props[ pName ];
					}
					
				}
				
				if ( this.parent.className ==  "SerialList" ) {
					sList.addCommand( new DoGTween( this._target[ i ], this._time, stackParameters, stackProps ) );
				}
				else if ( this.parent.className ==  "ParallelList" ) {
					pList.addCommand( new DoGTween( this._target[ i ], this._time, stackParameters, stackProps ) );
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
		
	}

}