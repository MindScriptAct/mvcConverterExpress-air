package com.bit101.graphic {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.net.URLRequest;

public class WebImage {

	private var parent:DisplayObjectContainer;

	private var myLoader:Loader;
	private var fileUrl:String;

	public function WebImage(parent:DisplayObjectContainer, x:int, y:int, url:String) {
		this.parent = parent;

		myLoader = new Loader();
		//myLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
		myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);

		load(url);

		myLoader.x = x;
		myLoader.y = y;
	}

	public function onProgressStatus(event:ProgressEvent):void {
		// this is where progress will be monitored
		//trace(event.bytesLoaded, event.bytesTotal);
	}

	public function onLoaderComplete(event:Event):void {
		// the image is now loaded, so let's add it to the display tree!
		parent.addChild(myLoader);

	}

	public function load(url:String):void {
		if (fileUrl != url) {
			fileUrl = url;
			if (parent.contains(myLoader)) {
				parent.removeChild(myLoader);
			}
			myLoader.load(new URLRequest(url));
		}
	}
}
}
