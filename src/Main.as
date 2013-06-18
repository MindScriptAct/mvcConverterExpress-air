package {
import com.bit101.components.HScrollBar;
import com.bit101.components.PushButton;
import com.bit101.components.ScrollBar;
import com.bit101.components.Text;
import com.bit101.components.TextArea;
import com.bit101.components.VScrollBar;

import constants.BlockTypes;

import constants.Literals;

import core.FileParser;
import core.FileTokenizer;

import data.FileVO;

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
	private var mainSrcDir:File;

	private var textLabel:Text;
	private var debugLabel:TextArea;

	private var resultContainer:Sprite;
	private var lines:Vector.<FileLine> = new <FileLine>[];

	private var filescroller:VScrollBar;
	private var handleFileIndex:int = int.MAX_VALUE;

	[SWF(width="1800", height="600", frameRate="30")]
	public function Main():void {

		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;

		textLabel = new Text(this, 2, 2, "test");
		textLabel.width = 800;
		textLabel.height = 20;

		var pushButton:PushButton = new PushButton(this, 805, 2, "browse");
		pushButton.addEventListener(MouseEvent.CLICK, handleBrowse);

		var analizeAllButton:PushButton = new PushButton(this, 600, 22, "Analise all");
		analizeAllButton.addEventListener(MouseEvent.CLICK, analizeAllFiles)


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
		resultContainer.x = 2;
		resultContainer.y = 50;

		Literals.initLiteral();
		BlockTypes.initBlockTypes();

		for (var i:int = 0; i < pageSize; i++) {
			var line:FileLine = new FileLine();
			line.y = lines.length * 20;
			resultContainer.addChild(line);
			line.analizeButton.addEventListener(MouseEvent.CLICK, handleAnalizeFile);
			lines.push(line);
		}

		filescroller = new VScrollBar(this, 810, 50, handleFileSchroll);
		filescroller.height = 700;

		this.stage.addEventListener(Event.ENTER_FRAME, handleFrameTick)

		CONFIG::debug {
			file_select();
		}
	}

	private function handleFrameTick(event:Event):void {
		if (handleFileIndex < fileCount) {
			var fileVo:FileVO = currentFiles[handleFileIndex];
			analizeFile(fileVo.file);
			handleFileIndex++;
		}
	}

	private function analizeAllFiles(event:MouseEvent):void {
		handleFileIndex = 0;
	}

	private function handleFileSchroll(event:Event):void {
		currentFileId = (event.target as VScrollBar).value;

		renderFilePage();
	}


	private function handleBrowse(evt:MouseEvent):void {
		handleFileIndex = int.MAX_VALUE;

		mainSrcDir = new File();
		mainSrcDir.addEventListener(Event.SELECT, file_select);
		mainSrcDir.browseForDirectory("Please select a directory...");

	}

	private function file_select(evt:Event = null):void {

		CONFIG::debug {
			if (mainSrcDir == null) {
//				file = File.applicationStorageDirectory.resolvePath("C:/aTestSrc");
//				mainSrcDir = File.applicationStorageDirectory.resolvePath("C:/unpureDemo/src");
				mainSrcDir = File.applicationStorageDirectory.resolvePath("C:/!pirateSpace/production/src/main/flash");
			}
		}
		if (mainSrcDir.exists) {

			textLabel.text = mainSrcDir.nativePath;

			FileLine.homePath = mainSrcDir.nativePath;

			handleMainDir(mainSrcDir);
		}

	}

	private function handleMainDir(mainDir:File):void {
		currentFiles = new <FileVO>[];

		parseDirFiles(mainDir, "");

		fileCount = currentFiles.length;

		if (fileCount - pageSize > 0) {
			filescroller.setSliderParams(0, fileCount - pageSize, 0);
			filescroller.pageSize = pageSize;
			filescroller.setThumbPercent(0.1)
		}
		filescroller.visible = (fileCount - pageSize > 0);

		renderFilePage();
	}

	private function parseDirFiles(mainDir:File, tab:String):void {
		var dirFiles:Array = mainDir.getDirectoryListing();

		for (var i:int = 0; i < dirFiles.length; i++) {
			var file:File = dirFiles[i];

			currentFiles.push(new FileVO(file, tab));

			if (file.isDirectory) {
				parseDirFiles(file, tab + "|   ");
			} else {
				// to auto analize if its light.
				// analizeFile(file);
			}
		}
	}

	private var currentFiles:Vector.<FileVO>;
	private var currentFileId:int = 0;
	private var fileCount:int = 0;
	private var pageSize:int = 35;

	private function renderFilePage():void {
		if (currentFiles) {
			for (var i:int = 0; i < pageSize; i++) {
				if (i + currentFileId < currentFiles.length) {

					var fileVo:FileVO = currentFiles[i + currentFileId];

					lines[i].setData(fileVo.file, fileVo.tab);
				} else {
					break;
				}
			}
		}
		// TODO : clear the rest
		for (i; i < pageSize; i++) {
			lines[i].setData(null, "");
		}
	}

	private function handleAnalizeFile(event:MouseEvent):void {
		var file:File = event.target.parent.file;
		analizeFile(file);
	}

	private function analizeFile(targetFile:File):void {
		if (targetFile) {

			if (!targetFile.isDirectory) {
				if (targetFile.extension == "as" || targetFile.extension == "mxml") {

					debugLabel.text = "";

					var fileTokenizer:FileTokenizer = new FileTokenizer(debugLabel);
					var tokens:Vector.<TokenVO> = fileTokenizer.tokenizeFile(targetFile);
					var fileAnalivel:FileParser = new FileParser(debugLabel);

					var output:String = fileAnalivel.analizeTokens(tokens);

					// do save..
					if (1) {

						var writeStream:FileStream = new FileStream();
						writeStream.open(targetFile, FileMode.WRITE);

						writeStream.writeUTFBytes(output);
						writeStream.close();

					}


				} else {
					debugLabel.text = "Only as and mxml files suported.";
				}
			} else {
				debugLabel.text = "Dictionary?.";
			}
		} else {
			debugLabel.text = "empty file?.";
		}
	}

}
}