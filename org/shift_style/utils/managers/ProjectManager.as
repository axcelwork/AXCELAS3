﻿package org.shift_style.utils.managers {	import flash.display.Stage;	import flash.system.Capabilities;		/**	 * プロジェクトに使用するパラメータを格納する Singleton クラスです.	 * 	 * @author axcel-work	 * @version 0.1	 * @since 2010/07/01	 * @usage	 * 	 */	public class ProjectManager {		public static var _instance:ProjectManager;				/**		 * 新しい ProjectManager インスタンスを作成します。		 */		public static function get instance():ProjectManager {			if ( _instance === null ) { _instance = new ProjectManager; }			return _instance;		}				private var _stage:Stage;		/**		 * [getter/setter] static な Stage クラスを設定します		 */		public function set stage( value:Stage ):void { this._stage = value; }		public function get stage():Stage { return this._stage; }						private var _base:Object;		/**		 * [getter/setter] Tween系の BaseParameter の値を格納します		 */		public function set baseParam( value:Object ):void { this._base = value; }		public function get baseParam():Object { return this._base; }						private var _type:String;		/**		 * [getter/setter] Tween系の EasingType を格納します		 */		public function set easeType( value:String ):void { this._type = value; }		public function get easeType():String { return this._type; }						private var _time:Number;		/**		 * [getter/setter] Tween系の EasingTime を格納します		 */		public function set easeTime( value:Number ):void { this._time = value; }		public function get easeTime():Number { return this._time; }						private var _delay:Number;		/**		 * [getter/setter] Tween系の Delay の値を格納します		 */		public function set easeDelay( value:Number ):void { this._delay = value; }		public function get easeDelay():Number { return this._delay; }						private var _xml:XML;		/**		 * [getter/setter] XML データを格納します		 */		public function set XMData( value:XML ):void { this._xml = value; }		public function get XMData():XML { return this._xml; }						/**		 * [getter] OS の種類を格納します		 */		public function get OSVersion():String { return Capabilities.os.substring( 0, 3 ); }			}	}