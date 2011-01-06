package org.shift_style.managers {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * EnterFrameEventの処理を最適化するクラスです.
	 * 本来各 DisplayObject が行う EnterFrame の処理をこのクラスが一括で行うことにより、パフォーマンスが飛躍的に向上します.
	 * 注:このクラスを用いた場合 useCapture, priority, weakReference の各項目を扱うことは出来ません.
	 * @author KAWAKITA Hirofumi.
	 * @version 0.1
	 */
	public class EnterFrameManager {
		private static var _MANAGER:Manager;
		private static var _ONCE_DICTIONARY:Dictionary;
		private static var _EVERY_DICTIONARY:Dictionary;
		private var _manager:Manager;

		/**
		 * 新しい　EnterFrameManager　インスタンスを作成します.
		 */
		public function EnterFrameManager() {
			this._manager = new Manager();
		}

		/**
		 * 指定したフレーム数後に一度だけコールバックを返します.
		 * @param	listener             コールバック Function.
		 * @param	delay                フレーム数.
		 * @param	monitorDisplayObject
		 * ADDED_TO_STAGE 及び REMOVED_FROM_STAGE を監視する対象を指定出来ます.
		 * 監視すると,removeChild時に自動的に一時停止されaddChild時に再開します.
		 * @param	delegateEventObject  コールバックに Event オブジェクトを渡すか.
		 */
		public static function once( listener:Function, delay:uint = 1, monitorDisplayObject:DisplayObject = null, delegateEventObject:Boolean = false ):void {
			if ( !_MANAGER ) {
				_MANAGER = new Manager();
			}
            
			if ( !_ONCE_DICTIONARY) {
				_ONCE_DICTIONARY = new Dictionary();
			}
            
			clearOnce(listener);
            
			_ONCE_DICTIONARY[listener] = _add({
                callback : function(e:Event):void {
				try {
					if( e.type == Event.ENTER_FRAME ) {
						if ( --delay <= 0 ) {
							listener.apply(null, ((delegateEventObject) ? e: null));
							clearOnce(listener);
						}
					}else if ( e.type == Event.ADDED_TO_STAGE ) {
						_MANAGER.atAddListener(_ONCE_DICTIONARY[listener].callback);
					}else if ( e.type == Event.REMOVED_FROM_STAGE ) {
						_MANAGER.atRemoveListener(_ONCE_DICTIONARY[listener].callback);
					}
				}catch (e:Error) {
					clearOnce(listener);
				}
			}, target : monitorDisplayObject
            });
		}

		/**
		 * onceで指定した処理をキャンセルします.
		 * @param	listener コールバックFunction.
		 */
		public static function clearOnce( listener:Function ):void {
			if ( !_MANAGER || !_ONCE_DICTIONARY || !_ONCE_DICTIONARY[listener] ) return;
			_clear(_ONCE_DICTIONARY[listener]);
			delete _ONCE_DICTIONARY[listener];
		}

		/**
		 * 指定された関数を false が返却されるまで、毎フレーム実行します。
		 * @param	listener コールバック.
		 * @param	monitorDisplayObject
		 * ADDED_TO_STAGE 及び REMOVED_FROM_STAGE を監視する対象を指定出来ます.
		 * 監視すると,removeChild時に自動的に一時停止されaddChild時に再開します.
		 */
		public static function every( listener:Function, monitorDisplayObject:DisplayObject = null ):void {
			if ( !_MANAGER ) _MANAGER = new Manager();
			if ( !_EVERY_DICTIONARY ) _EVERY_DICTIONARY = new Dictionary();
			clearEvery(listener);
			_EVERY_DICTIONARY[listener] = _add({
                callback : function(e:Event):void {
				try {
					if( e.type == Event.ENTER_FRAME ) {
						if ( !listener() ) clearEvery(listener);
					}else if ( e.type == Event.ADDED_TO_STAGE ) {
						_MANAGER.atAddListener(_EVERY_DICTIONARY[listener].callback);
					}else if ( e.type == Event.REMOVED_FROM_STAGE ) {
						_MANAGER.atRemoveListener(_EVERY_DICTIONARY[listener].callback);
					}
				}catch(e:Error) {
					clearEvery(listener);
				}
			}, target : monitorDisplayObject
            });
		}

		/**
		 * everyで指定した処理をキャンセルします.
		 * @param	listener コールバック.
		 */
		public static function clearEvery( listener:Function ):void {
			if ( !_MANAGER || !_EVERY_DICTIONARY || !_EVERY_DICTIONARY[listener] ) return;
			_clear(_EVERY_DICTIONARY[listener]);
			delete _EVERY_DICTIONARY[listener];
		}

		private static function _add( obj:* ):* {
			if ( obj.target ) {
				obj.target.addEventListener(Event.ADDED_TO_STAGE, obj.callback);
				obj.target.addEventListener(Event.REMOVED_FROM_STAGE, obj.callback);
				if ( obj.target.stage ) _MANAGER.atAddListener(obj.callback);
			} else {
				_MANAGER.atAddListener(obj.callback);
			}
			return obj;
		}

		/**
		 * クリアメソッド.
		 * @param	obj
		 */
		private static function _clear( obj:* ):* {
			if ( obj.target ) {
				obj.target.removeEventListener(Event.ADDED_TO_STAGE, obj.callback);
				obj.target.removeEventListener(Event.REMOVED_FROM_STAGE, obj.callback);
			}
			_MANAGER.atRemoveListener(obj.callback);
		}
		
		/** 現在登録されているリスナ数. */
		public function get numListeners():Number {
			return this._manager.numListeners;
		}

		/** EnterFrameが実行されているか. */
		public function get running():Boolean {
			return this._manager.running;
		}

		/**
		 * EnterFrameEventのリスナを追加します.
		 * 追加したリスナは,このクラスの管理下に置かれるため,解除する際には
		 * このクラスの removeEventListener を実行してください.
		 * @param	listener コールバックFunction.
		 */
		public function addEventListener( listener:Function ):void {
			this._manager.atAddListener(listener);
		}

		/**
		 * EnterFrameEventのリスナを削除します.
		 * @param	listener コールバックFunction.
		 */
		public function removeEventListener( listener:Function ):void {
			this._manager.atRemoveListener(listener);
		}

		/**
		 * EnterFrame の処理を停止します.
		 */
		public function pause():void {
			this._manager.atPause();
		}

		/**
		 * pause によって停止した処理を再開します.
		 */
		public function resume():void {
			this._manager.atResume();
		}
	}
}

import flash.display.Shape;
import flash.events.Event;
import flash.utils.Dictionary;

/**
 * このクラスでEnterFrameEventが管理します.
 */
class Manager extends Shape {
	private var _listenerDictionary:Dictionary;
	private var _lintenerNum:uint;
	private var _isRunning:Boolean;

	/**
	 * コンストラクタ.
	 */
	public function Manager():void {
		this._listenerDictionary = new Dictionary();
		this._lintenerNum = 0;
		this._isRunning = false;
		this.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
	}

	/** 
	 * 現在登録されている Listener 数を取得します.
	 */
	public function get numListeners():Number {
		return this._lintenerNum;
	}

	/**
	 * EntaerFrame が実行されているか取得します
	 */
	public function get running():Boolean {
		return this._isRunning;
	}

	/**
	 * Listener を追加します.
	 * @param	listener
	 */
	public function atAddListener( listener:Function ):void {
		if ( this._listenerDictionary[listener] ) return;
		this._listenerDictionary[listener] = listener;
		this._lintenerNum++;
	}

	/**
	 * Listener を削除します.
	 * @param	listener
	 */
	public function atRemoveListener( listener:Function ):void {
		if ( !this._listenerDictionary[listener] ) {
			return;
		}
        
		delete this._listenerDictionary[listener];
        
		if ( --this._lintenerNum <= 0 ) {
			atPause();
		}
	}

	/**
	 * EnterFrame の処理を停止します.
	 */
	public function atPause():void {
		if ( !this._isRunning ) {
			return;
		}
        
		this.removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
        
		this._isRunning = false;
	}

	/**
	 * atPause によって停止した処理を再開します.
	 */
	public function atResume():void {
		if ( this._isRunning || this._lintenerNum <= 0 ) {
			return;
		}
        
		this.addEventListener(Event.ENTER_FRAME, _onEnterFrame);
        
		this._isRunning = true;
	}

	/**
	 * EnterFrame実行処理.
	 * @param	e
	 */
	private function _onEnterFrame(e:Event):void {
		for each( var fnc:Function in this._listenerDictionary ) {
			fnc(e);
		}
	}
}