package {
import com.bit101.components.PushButton;
import com.bit101.components.Text;
import com.bit101.components.TextArea;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

/**
 * ...
 * @author mindscriptact
 */
public class Main extends Sprite {
	private var file:File;

	private var textLabel:Text;
	private var debugLabel:TextArea;

	private var resultContainer:Sprite;
	private var lines:Vector.<FileLine> = new <FileLine>[];

	[SWF(width="1800", height="600", frameRate="30")]
	public function Main():void {


		textLabel = new Text(this, 10, 50, "test");
		textLabel.width = 900;
		textLabel.height = 20;

		var pushButton:PushButton = new PushButton(this, 800, 80, "browse");
		pushButton.addEventListener(MouseEvent.CLICK, handleBrowse);


		debugLabel = new TextArea(this, 1000, 10, "");
		debugLabel.width = 800;
		debugLabel.height = 680;
//
//		var test:Window = new Window(this, 10, 120, "Dir content.");
//		test.addChild(debugLabel);
//		test.width = 1000;
//		test.height = 600;

		resultContainer = new Sprite();
		this.addChild(resultContainer);
		resultContainer.x = 10;
		resultContainer.y = 120;

	}


	private function handleBrowse(evt:MouseEvent):void {
		file = new File();
		file.addEventListener(Event.SELECT, file_select);
		file.browseForDirectory("Please select a directory...");
	}

	private function file_select(evt:Event):void {

		textLabel.text = file.nativePath;

		FileLine.homePath = file.nativePath;

		//debugLabel.text = "";

		while (lines.length) {
			resultContainer.removeChild(lines.pop());
		}

		traceDir(file, "");

	}

	private function traceDir(traceFile:File, tab:String):void {
		var files:Array = traceFile.getDirectoryListing();

		for (var i:int = 0; i < files.length; i++) {
			var file:File = files[i]

			var line:FileLine = new FileLine(file, tab);
			line.y = lines.length * 20;
			resultContainer.addChild(line);

			lines.push(line);

			if (file.isDirectory) {
				traceDir(file, tab + "| ");
			} else {
				analizeFile(file);
			}
		}
	}

	private function analizeFile(file:File):void {
		var localFileStream:FileStream = new FileStream();
		localFileStream.open(file, FileMode.UPDATE);


		var test:Object = localFileStream.readUTFBytes(file.size);

		localFileStream.close();
	}

}

}