package org.shift_style.commands.display {
	import jp.progression.commands.*;
	import jp.progression.commands.display.*;
	import jp.progression.commands.lists.*;

	import flash.display.DisplayObjectContainer;

	/**
	 * AddChild を書き連ねていくのが面倒という自分に対して制作したProgression用クラスです.
	 * 
	 * <p><strong>Exsample</strong></p>
	 * <listing>new AddChildren( this.manager.stage , [ instance1, instance2, instance3, ... ] )</listing>
	 * 
	 * @author axcel-work
	 * @version 0.1
	 * @since 2010/06/16
	 * @usage
	 * 
	 */
	public class AddChildren extends Command {
		private var _list:SerialList = new SerialList();
		
		private var _contenner:DisplayObjectContainer;
		private var _array:Array;
		
		/**
		 * 新しい AddChildren インスタンスを作成します。
		 */
		public function AddChildren( containerRefOrId:DisplayObjectContainer, childRefOrId:Array, initObject:Object = null ) {
			// 親クラスを初期化します。
			super( _execute, _interrupt, initObject );
			
			this._contenner = containerRefOrId;
			this._array = childRefOrId;
		}
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _execute():void {
			for (var i:int = 0; i < this._array.length; i++) {
				this._list.addCommand( new AddChild( this._contenner, this._array[ i ] ) );
			}
			
			this._list.execute();
			
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