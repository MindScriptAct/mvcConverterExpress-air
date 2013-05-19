package {
import com.bit101.components.PushButton;
import com.bit101.components.Text;
import com.bit101.components.TextArea;

import constants.BlockTypes;

import constants.Literals;

import core.FileAnilizer;
import core.FileTokenizer;

import data.TokenVO;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import view.FileLine;

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

		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;

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

		Literals.initLiteral();
		BlockTypes.initBlockTypes();

		CONFIG::debug {
			file_select();
		}

	}


	private function handleBrowse(evt:MouseEvent):void {
		file = new File();
		file.addEventListener(Event.SELECT, file_select);
		file.browseForDirectory("Please select a directory...");
	}

	private function file_select(evt:Event = null):void {

		CONFIG::debug {
			if (file == null) {
				file = File.applicationStorageDirectory.resolvePath("C:/aTestSrc");
			}
		}
		if (file.exists) {

			textLabel.text = file.nativePath;

			FileLine.homePath = file.nativePath;

			//debugLabel.text = "";

			while (lines.length) {
				resultContainer.removeChild(lines.pop());
			}

			traceDir(file, "");
		}

	}

	private function traceDir(traceFile:File, tab:String):void {
		var files:Array = traceFile.getDirectoryListing();

		for (var i:int = 0; i < files.length; i++) {
			var file:File = files[i]

			var line:FileLine = new FileLine(file, tab);
			line.y = lines.length * 20;
			resultContainer.addChild(line);
			line.analizeButton.addEventListener(MouseEvent.CLICK, analizeFile);

			lines.push(line);

			if (file.isDirectory) {
				traceDir(file, tab + "| ");
			} else {
				//analizeFile(file);
			}
		}
	}

	private function analizeFile(event:MouseEvent):void {

		var file:File = event.target.parent.file;

		if (!file.isDirectory) {
			if (file.extension == "as" || file.extension == "mxml") {

				debugLabel.text = "";

				var fileTokenizer:FileTokenizer = new FileTokenizer(debugLabel);

				var tokens:Vector.<TokenVO> = fileTokenizer.tokenizeFile(file);

				var fileAnalivel:FileAnilizer = new FileAnilizer(debugLabel);

				fileAnalivel.analizeTokens(tokens);

			} else {
				debugLabel.text = "Only as and mxml files suported.";
			}
		} else {
			debugLabel.text = "Dictionary?.";
		}
	}

}
}