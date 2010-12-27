package org.shift_style.commands.display {
	import jp.progression.commands.*;
	import jp.progression.commands.lists.*;

	/**
	 * Propを書き連ねていくのが面倒という自分に対して制作したProgression用クラスです.
	 * 
	 * <p><strong>Exsample</strong></p>
	 * <listing>new ExProp( [ instance1, instance2, instance3, ... ], { alpha: 0 } )</listing>
	 * 
	 * <p>またプロパティを個別に設定したい場合は配列で設定できます。</p>
	 * <p><strong>Exsample</strong></p>
	 * <listing>new ExProp( [ instance1, instance2, instance3, ... ], { alpha: [ 0, 0.5, 1 ] } )</listing>
	 * 
	 * 
	 * @author axcel-work
	 * @version 0.1
	 * @since 2010/06/16
	 * @usage
	 */
	public class ExProp extends Command {
		private var _target:Array;
		private var _parameters:Object;
		
		/**
		 * 新しい ExProp インスタンスを作成します。
		 */
		public function ExProp( target:Array, parameters:Object, initObject:Object = null ) {
			// 親クラスを初期化します。
			super( _execute, _interrupt, initObject );
			
			this._target = target;
			this._parameters = parameters;
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
					sList.addCommand( new Prop( this._target[ i ], stackParameters ) );
				}
				else if ( this.parent.className ==  "ParallelList" ) {
					pList.addCommand( new Prop( this._target[ i ], stackParameters ) );
				}
			}
			
			
			
			// Command Excutor
			if ( this.parent.className ==  "SerialList" ) {
				sList.execute();
			}
			else if ( this.parent.className ==  "ParallelList" ) {
				pList.execute();
			}
			
			executeComplete();
		}
		
		/**
		 * 中断されるコマンドの実装です。
		 */
		private function _interrupt():void {}
		
		/**
		 * インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。
		 */
		//override public function clone():Command {
			//return new AddChildren( this );
		//}
		
	}

}