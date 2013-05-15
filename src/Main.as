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

				var localFileStream:FileStream = new FileStream();
				localFileStream.open(file, FileMode.UPDATE);


				var fileText:String = localFileStream.readUTFBytes(file.size);


				analizeText(fileText);


				localFileStream.close();
			} else {
				debugLabel.text = "Only as and mxml files suported.";
			}
		} else {
			debugLabel.text = "Dictionary?.";
		}
	}


	private var fileText:String;

	private var index:int;
	private var length:int;

	private var char:String;
	private var charCode:int;
	private var nextChar:String;
	private var nextCharCode:int;
	private var prevChar:String;

	private var tokenType:String;
	private var tokenData:String;

	private function analizeText(fileText:String):void {

		this.fileText = fileText;
		index = 0;
		length = fileText.length;
		nextChar = "";
		prevChar = "";

		var tokens:Vector.<Token> = new <Token>[];

		while (index <= length) {

			readChar();


			tokenType = Tokens.UNDEFINED;
			tokenData = char;

			if (char == "/") {
				if (nextChar == "/") {
					tokenType = Tokens.LINE_COMMENT;

				} else if (nextChar == "*") {
					tokenType = Tokens.BLOCK_COMMENT;

					while (notEnd && (char != "*" || nextChar != "/")) {
						readWriteChar();
					}
					readWriteChar();
				}
			} else if (whiteSpace) {
				tokenType = Tokens.WHITE_SPACE;
				while (notEnd && whiteSpaceNext) {
					readWriteChar();
				}
			} else if (char == '"') {
				tokenType = Tokens.STRING;
				while (notEnd && nextChar != '"') {
					readWriteChar();
				}
				readWriteChar();
			} else if (char == "'") {
				tokenType = Tokens.STRING;
				while (notEnd && nextChar != "'") {
					readWriteChar();
				}
				readWriteChar();
			} else if (isNumber) {
				tokenType = Tokens.NUMBER;
				while (notEnd && isNextNumberOrDot) {
					readWriteChar();
				}
			} else if (isLiteral) {
				tokenType = Tokens.LITERAL;
				while (notEnd && isNextNumberOrLiteral) {
					readWriteChar();
				}
			} else if (char == "(") {
				tokenType = Tokens.OPEN;
			} else if (char == ")") {
				tokenType = Tokens.CLOSE;
			} else if (char == "{") {
				tokenType = Tokens.OPEN_BLOCK;
			} else if (char == "}") {
				tokenType = Tokens.CLOSE_BLOCK;
			} else if (char == "[") {
				tokenType = Tokens.OPEN_ARRAY;
			} else if (char == "]") {
				tokenType = Tokens.CLOSE_ARRAY;
			} else if (char == "<") {
				if (nextChar == "=") {
					tokenType = Tokens.LESSEQUALS;
				} else {
					tokenType = Tokens.LESS;
				}
			} else if (char == ">") {
				if (nextChar == "=") {
					tokenType = Tokens.MOREEQUALS;
				} else {
					tokenType = Tokens.MORE;
				}

			} else if (char == "=") {
				if (nextChar == "=") {
					tokenType = Tokens.EQUALS;
				} else {
					tokenType = Tokens.ASSIGN;
				}
			} else if (char == ".") {
				tokenType = Tokens.DOT;
			} else if (char == ",") {
				tokenType = Tokens.COMMA;
			} else if (char == "+" || char == "-" || char == "/" || char == "*" || char == "&") {
				tokenType = Tokens.OPERATOR;
			} else if (char == "|") {
				tokenType = Tokens.OR;
			} else if (char == "&") {
				tokenType = Tokens.AND;
			} else if (char == ";") {
				tokenType = Tokens.END;
			}


			tokens.push(new Token(tokenType, tokenData));


		}

		for (var i:int = 0; i < tokens.length; i++) {
			debugLabel.text += tokens[i].tokenType + ":" + tokens[i].tokenData + "\n";
		}

	}

	[Inline]
	private function get isNextNumberOrLiteral():Boolean {
		return isNextLiteral || isNextNumber;
	}

	[Inline]
	private function get isNextLiteral():Boolean {
		return nextCharCode >= 97 && nextCharCode <= 122 ||  // a..z
				nextCharCode >= 65 && nextCharCode <= 90 ||  // A..Z
				nextCharCode == 95 ||                    // _
				nextCharCode == 36;                      // $
	}


	[Inline]
	private function get isLiteral():Boolean {
		return charCode >= 97 && charCode <= 122 ||  // a..z
				charCode >= 65 && charCode <= 90 ||  // A..Z
				charCode == 95 ||                    // _
				charCode == 36;                      // $
	}


	[Inline]
	private function get isNextNumberOrDot():Boolean {
		return nextCharCode >= 48 && nextCharCode <= 58 || nextChar == ".";
	}

	[Inline]
	private function get isNextNumber():Boolean {
		return nextCharCode >= 48 && nextCharCode <= 58;
	}

	[Inline]
	private function get isNumber():Boolean {
		return charCode >= 48 && charCode <= 58;
	}


	[Inline]
	private function readChar():void {
		prevChar = char;
		char = fileText.charAt(index);
		charCode = fileText.charCodeAt(index);
		if (index < length) {
			nextChar = fileText.charAt(index + 1);
			nextCharCode = fileText.charCodeAt(index + 1);
		}
		index++;
	}

	[Inline]
	private function readWriteChar():void {
		readChar();
		writeChar();
	}

	[Inline]
	private function writeChar():void {
		tokenData += char;
	}

	[Inline]
	private function get notEnd():Boolean {
		return index <= length;
	}

	[Inline]
	private function get whiteSpace():Boolean {
		return (char == " " || char == "\t" || char == "\n" || char == "\r");
	}

	[Inline]
	private function get whiteSpaceNext():Boolean {
		return (nextChar == " " || nextChar == "\t" || nextChar == "\n" || nextChar == "\r");
	}
}
}