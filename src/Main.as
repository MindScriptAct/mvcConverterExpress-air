package {
import com.bit101.components.ComboBox;
import com.bit101.components.Label;
import com.bit101.components.PushButton;
import com.bit101.components.PushButton;
import com.bit101.components.PushButton;
import com.bit101.components.Text;
import com.bit101.components.TextArea;
import com.bit101.components.VScrollBar;

import constants.BlockTypes;
import constants.FileStatus;
import constants.HelpTexts;
import constants.Literals;
import constants.ToolNames;

import core.FileParser;
import core.FileScaner;
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

import ruleSets.RuleSet;
import ruleSets.RuleSetMediatorExpresify;
import ruleSets.RuleSetMvcExpress;
import ruleSets.RuleSetMvcExpress1to2;
import ruleSets.RuleSetMvcExpressLive1to2;
import ruleSets.RuleSetProxyExpresify;
import ruleSets.RuleSetUnpureMvc1Depricated;
import ruleSets.RuleSetUnpureMvc2;

import view.FileLine;
import view.StatisticPanel;

/**
 * ...
 * @author mindscriptact
 */
[SWF(width='1800', height='800', backgroundColor='#ffffff', frameRate='120')]
public class Main extends Sprite {


	private static const BLANK_RULE_SET:RuleSet = new RuleSet();

	private var mainSrcDir:File;

	private var textLabel:Text;
	private var progressLabel:Label;
	private var debugLabel:TextArea;

	private var resultContainer:Sprite;
	private var lines:Vector.<FileLine> = new <FileLine>[];

	private var filescroller:VScrollBar;
	private var handleFileIndex:int = int.MAX_VALUE;
	private var handledItemCount:int;


	private var currentRuleSet:RuleSet;

	private var fileScaner:FileScaner = new FileScaner();

	private var statisticPanel:StatisticPanel;
	private var searchText:Text;

	/////////

	private var currentFiles:Vector.<FileVO>;
	private var currentFilesStatus:Vector.<int>;
	private var currentFileId:int = 0;
	private var fileCount:int = 0;
	private var pageSize:int = 37;
	private var autoscroll:int = 0;

	private var toolBox:ComboBox;

	private var homePath:String

	[SWF(width="1800", height="600", frameRate="30")]
	public function Main():void {

		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;

		textLabel = new Text(this, 2, 2, "");
		textLabel.width = 800;


		new PushButton(this, 705, 2, "browse", handleBrowse);

		var helpButton:PushButton = new PushButton(this, 870, 5, "?", handleHelp);
		helpButton.width = 20;
		helpButton.height = 15;

		new PushButton(this, 320, 25, "Convert all", analizeAllFiles);
		var stopButton:PushButton = new PushButton(this, 435, 27, "stop", stopAnilize);
		stopButton.width = 50;
		stopButton.height = 15;


		debugLabel = new TextArea(this, 900, 0, "");
		debugLabel.width = 900;
		debugLabel.height = 800;


		progressLabel = new Label(this, 730, 25, "...");
		progressLabel.width = 150;
		progressLabel.height = 20;

		statisticPanel = new StatisticPanel();
		this.addChild(statisticPanel);
		statisticPanel.x = 830;
		statisticPanel.y = 100;


		searchText = new Text(this, 530, 22, "");
		searchText.width = 100;
		searchText.height = 20;
		var filterButton:PushButton = new PushButton(this, 630, 22, "filter", handleFiltering);
		filterButton.width = 50;


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
			line.viewButton.addEventListener(MouseEvent.CLICK, handleViewFile);
			lines.push(line);
		}

		filescroller = new VScrollBar(this, 810, 50, handleFileSchroll);
		filescroller.height = 740;

		this.stage.addEventListener(Event.ENTER_FRAME, handleFrameTick)


//		new RadioButton(this, 30, 30, "scan(writes to files)", true, handleRulesetScan);
//		new RadioButton(this, 150, 30, "pureMvc>unpureMvc", false, handleRulesetUnpureMvcExpress);
//		new RadioButton(this, 270, 30, "unpureMvc>mvcExpress", false, handleRulesetMvcExpress);
//		new RadioButton(this, 400, 30, "clean proxy", false, handleRulesetProxy);
//		new RadioButton(this, 500, 30, "clean mediator", false, handleRulesetMediator);

		toolBox = new ComboBox(this, 5, 25, ToolNames.SCAN, [ToolNames.SCAN]);
		toolBox.addEventListener(Event.SELECT, handleSelect);
		toolBox.width = 300;

		toolBox.selectedIndex = 0;
		//handleSelect();
		currentRuleSet = new RuleSet();


		CONFIG::debug {
			file_select();
		}

		debugLabel.text += HelpTexts.HOW_TO_GUIDE;

	}

	private function handleHelp(event:Event = null):void {
		debugLabel.text += HelpTexts.HOW_TO_GUIDE;
	}

	private function handleSelect(event:Event = null):void {
		if (toolBox.items.length) {
			var toolName:String = toolBox.items[toolBox.selectedIndex];
			switch (toolName) {
				case ToolNames.SCAN:
					currentRuleSet = new RuleSet();
					break;
				case ToolNames.MVCE_1_TO_2:
					currentRuleSet = new RuleSetMvcExpress1to2();
					break;
				case ToolNames.MVCE_LIVE_1_TO_2:
					currentRuleSet = new RuleSetMvcExpressLive1to2();
					break;
				case ToolNames.PUREMVC_TO_MVC_EXPRESS_V2:
					currentRuleSet = new RuleSetUnpureMvc2();
					break;
				case ToolNames.PUREMVC_TO_MVC_EXPRESS_V1_DEPRECATED:
					currentRuleSet = new RuleSetUnpureMvc1Depricated();
					break;

			}
		}
	}


	private function handleFiltering(event:Event):void {
		var searchString:String = String(searchText.text);
		if (searchString) {
			for (var i:int = 0; i < currentFiles.length; i++) {
				if (currentFiles[i].file.name.indexOf(searchString) == -1) {
					currentFiles.splice(i, 1);
					currentFilesStatus.splice(i, 1);
					i--;
				}
			}
		}

		renderFileScroller();
	}

	private function handleRulesetScan(event:Event):void {
		currentRuleSet = new RuleSet();
	}

	private function handleRulesetUnpureMvcExpress(event:Event):void {
		currentRuleSet = new RuleSetUnpureMvc1Depricated();
	}

	private function handleRulesetMvcExpress(event:Event):void {
		currentRuleSet = new RuleSetMvcExpress();
	}

	private function handleRulesetProxy(event:Event):void {
		currentRuleSet = new RuleSetProxyExpresify();
	}

	private function handleRulesetMediator(event:Event):void {
		currentRuleSet = new RuleSetMediatorExpresify();
	}

	private function handleFrameTick(event:Event):void {
		if (handleFileIndex < fileCount) {
			var fileVo:FileVO = currentFiles[handleFileIndex];
			analizeFile(handleFileIndex);
			if (handleFileIndex >= currentFileId && handleFileIndex < currentFileId + pageSize) {
				renderFilePage();
			}
			handleFileIndex++;


			if (handleFileIndex < fileCount) {
				progressLabel.text = "working... " + handleFileIndex + "/" + fileCount;
			} else {
				progressLabel.text = "done.  " + fileCount;
			}
			if (autoscroll + pageSize < handleFileIndex) {
				autoscrollTo(autoscroll + pageSize);
			}
		}
	}

	private function analizeAllFiles(event:MouseEvent):void {
		debugLabel.text += "\n" + " ... processing all files with : " + toolBox.items[toolBox.selectedIndex];

		handleFileIndex = 0;
		autoscrollTo(0);
	}

	private function autoscrollTo(scrollTo:int):void {
		autoscroll = scrollTo;
		currentFileId = autoscroll;
		filescroller.value = autoscroll;
		renderFilePage();
	}

	private function stopAnilize(event:MouseEvent):void {
		handleFileIndex = int.MAX_VALUE;
	}

	private function handleFileSchroll(event:Event):void {
		currentFileId = (event.target as VScrollBar).value;

		renderFilePage();
	}


	private function handleBrowse(evt:MouseEvent):void {
		handleFileIndex = int.MAX_VALUE;

		try {
			mainSrcDir = new File();
			if (textLabel.text) {
				mainSrcDir.nativePath = textLabel.text;
			}
			mainSrcDir.addEventListener(Event.SELECT, file_select);
			mainSrcDir.browseForDirectory("Please select a directory...");
		} catch (error:Error) {
			mainSrcDir = new File();
			mainSrcDir.addEventListener(Event.SELECT, file_select);
			mainSrcDir.browseForDirectory("Please select a directory...");
		}

	}

	private function file_select(evt:Event = null):void {

		CONFIG::debug {
			if (mainSrcDir == null) {
//				file = File.applicationStorageDirectory.resolvePath("C:/aTestSrc");

//				mainSrcDir = File.applicationStorageDirectory.resolvePath("C:/unpureDemo/src");
				mainSrcDir = File.applicationStorageDirectory.resolvePath("C:/!workSpace/production/src/main/flash");
				//mainSrcDir = File.applicationStorageDirectory.resolvePath("C:/mvcExpress-ticTacToe/src");
				//mainSrcDir = File.applicationStorageDirectory.resolvePath("C:/mvcExpress-liveVizualizer/src");
//				mainSrcDir = File.applicationStorageDirectory.resolvePath("C:/Users/rbanevicius/Dropbox/!intelliSpace/unpureDemo/src");
//				mainSrcDir = File.applicationStorageDirectory.resolvePath("C:/!pirateSpace/production/src/main/flash/net/bigpoint/deprecated/gui/view/components/common/skin");
			}
		}
		if (mainSrcDir.exists) {

			textLabel.text = mainSrcDir.nativePath;

			FileLine.homePath = mainSrcDir.nativePath;

			handledItemCount = 0;

			handleMainDir(mainSrcDir);

			progressLabel.text = "file count:" + currentFiles.length;
			statisticPanel.setAmount(currentFiles.length, FileStatus.UNKNOWN);
		}

	}

	private function handleMainDir(mainDir:File):void {
		homePath = mainDir.nativePath;
		debugLabel.text = "Dir selected : " + mainDir.nativePath;

		setDefaultTools();

		currentFiles = new <FileVO>[];
		currentFilesStatus = new <int>[];

		parseDirFiles(mainDir, "");

		renderFileScroller();

	}

	private function setDefaultTools():void {
		toolBox.removeAll();
		toolBox.addItem(ToolNames.SCAN);
		toolBox.addItem(ToolNames.MVCE_1_TO_2);
//		toolBox.addItem(ToolNames.MVCE_LIVE_1_TO_2);
		toolBox.addItem(ToolNames.PUREMVC_TO_MVC_EXPRESS_V2);
		toolBox.addItem(ToolNames.PUREMVC_TO_MVC_EXPRESS_V1_DEPRECATED);
	}

	private function renderFileScroller():void {

		currentFileId = 0;
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
			currentFilesStatus.push(FileStatus.UNKNOWN);

			if (file.isDirectory) {
				if (file.name != ".git" && file.name != ".svn") {
					parseDirFiles(file, tab + "|   ");
				}
			} else {
				// to auto analize if its light.
				// analizeFile(file);
			}
		}
	}


	private function renderFilePage():void {
		if (currentFiles) {
			for (var i:int = 0; i < pageSize; i++) {
				if (i + currentFileId < currentFiles.length) {

					var fileVo:FileVO = currentFiles[i + currentFileId];

					lines[i].setData(i + currentFileId, fileVo.file, fileVo.tab, currentFilesStatus[i + currentFileId]);
				} else {
					break;
				}
			}
		}
		// TODO : clear the rest
		for (i; i < pageSize; i++) {
			lines[i].setData(i, null, "", FileStatus.BLANK);
		}
	}

	private function handleViewFile(event:MouseEvent):void {
		var file:File = event.target.parent.file;
		if (file) {

			var localFileStream:FileStream = new FileStream();
			try {
				localFileStream.open(file, FileMode.READ);
				debugLabel.text = localFileStream.readUTFBytes(file.size).split("\r").join("");
			} catch (error:Error) {
				trace("WARINING : failed to read the file: ", file.nativePath, error);
				debugLabel.text = "WARINING : failed to read the file:   " + file.nativePath + "  " + error;
			}
		}
	}

	private function handleAnalizeFile(event:MouseEvent):void {
		analizeFile(event.target.parent.id);
		renderFilePage();
	}

	private function analizeFile(id:int):void {
		// check file status.
		if (currentRuleSet != BLANK_RULE_SET && currentFilesStatus[id] == 0) {
			doAnalizeFile(id, BLANK_RULE_SET);
		}
		if (currentRuleSet) {
			doAnalizeFile(id, currentRuleSet);
		}
	}

	private function doAnalizeFile(id:int, analizeRuleSet:RuleSet):void {
		var targetFile:File = currentFiles[id].file;
		var oldStatus:int = currentFilesStatus[id];
		// check if correct status.
		if (analizeRuleSet == BLANK_RULE_SET || currentFilesStatus[id] == analizeRuleSet.affectedFileStatus) {

			statisticPanel.reduce(currentFilesStatus[id]);

			var newStatus:int = FileStatus.UNKNOWN;
			if (targetFile) {

				var debugtext:String = targetFile.nativePath.split(homePath)[1] + " : "

				if (!targetFile.isDirectory) {
					if (targetFile.extension == "as" || targetFile.extension == "mxml") {

						var originalFileContent:String = getFileContent(targetFile);

						var fileTokenizer:FileTokenizer = new FileTokenizer(debugLabel);

						if (originalFileContent) {

							var tokens:Vector.<TokenVO> = fileTokenizer.tokenizeText(originalFileContent);

							if (tokens && tokens.length) {

								var fileParser:FileParser = new FileParser(debugLabel);

								var output:String = fileParser.analizeTokens(tokens, analizeRuleSet);

								// do save?
								if (analizeRuleSet == BLANK_RULE_SET) {
									if (originalFileContent != output) {
										newStatus = FileStatus.ERROR;
									}
								} else if (originalFileContent != output) {
									var writeStream:FileStream = new FileStream();
									try {
										writeStream.open(targetFile, FileMode.WRITE);

										writeStream.writeUTFBytes(output);
										writeStream.close();
									} catch (error:Error) {
										trace("Warning: failed to write changes: ", targetFile.nativePath, error);
									}
								}
							}
						}
						newStatus = fileScaner.scan(targetFile);
						debugtext += "analized.   File status changed from " + FileStatus.STATUS_NAMES[oldStatus] + " to " + FileStatus.STATUS_NAMES[newStatus];
					} else {
						debugtext += "Only as and mxml files suported.";
						newStatus = FileStatus.UNSUPORTED;
					}
				} else {
					debugtext += "Dictionary.";
					newStatus = FileStatus.BLANK;
				}
			} else {
				debugtext += "empty file?.";
			}
			currentFilesStatus[id] = newStatus
			statisticPanel.inclease(newStatus);

			debugLabel.text += "\n" + debugtext;

		}
	}

	private function getFileContent(file:File):String {
		var retVal:String;

		var localFileStream:FileStream = new FileStream();
		try {
			localFileStream.open(file, FileMode.READ);
			retVal = localFileStream.readUTFBytes(file.size);
		} catch (error:Error) {
			trace("WARINING : failed to read the file: ", file.nativePath, error);
		}
		localFileStream.close();

		return retVal;
	}

}
}