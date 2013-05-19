package core {
import com.bit101.components.TextArea;

import constants.Literals;
import constants.TokenKind;
import constants.TokenTypes;

import data.TokenVO;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class FileTokenizer {

	private var debugLabel:TextArea;


	private var fileText:String;

	private var index:int;
	private var length:int;

	private var char:String;
	private var charCode:int;
	private var nextChar:String;
	private var nextCharCode:int;
	private var prevChar:String;

	private var tokenKind:int;
	private var tokenType:String;
	private var tokenData:String;
	private var tokenKeyWord:String;

	private var tokens:Vector.<TokenVO>;

	public function FileTokenizer(debugLabel:TextArea) {
		this.debugLabel = debugLabel;
	}


	public function tokenizeFile(file:File):Vector.<TokenVO> {
		var localFileStream:FileStream = new FileStream();
		localFileStream.open(file, FileMode.UPDATE);

		tokens = new <TokenVO>[];

		var fileText:String = localFileStream.readUTFBytes(file.size);

		debugLabel.text += "//==================\n// tokenize\n//==================\n";

		analizeText(fileText);

		localFileStream.close();

		return tokens;
	}


	private function analizeText(fileText:String):void {

		this.fileText = fileText;
		index = 0;
		length = fileText.length;
		nextChar = "";
		prevChar = "";


		while (index < length) {

			readChar();

			tokenKind = TokenKind.UNDEFINED;
			tokenType = TokenTypes.UNDEFINED;
			tokenData = char;
			tokenKeyWord = "";

			if (char == "/") {
				if (nextChar == "/") {
					tokenType = TokenTypes.LINE_COMMENT;
					while (notEnd && (nextChar != "\n" && nextChar != "\r")) {
						readWriteChar();
					}
				} else if (nextChar == "*") {
					tokenType = TokenTypes.BLOCK_COMMENT;

					while (notEnd && (char != "*" || nextChar != "/")) {
						readWriteChar();
					}
					readWriteChar();
				}
			} else if (whiteSpace) {
				tokenType = TokenTypes.WHITE_SPACE;
				while (notEnd && whiteSpaceNext) {
					readWriteChar();
				}
			} else if (char == '"') {
				tokenType = TokenTypes.STRING;
				while (notEnd && nextChar != '"') {
					readWriteChar();
				}
				readWriteChar();
			} else if (char == "'") {
				tokenType = TokenTypes.STRING;
				while (notEnd && nextChar != "'") {
					readWriteChar();
				}
				readWriteChar();
			} else if (isNumber) {
				tokenType = TokenTypes.NUMBER;
				while (notEnd && isNextNumberOrDot) {
					readWriteChar();
				}
			} else if (isLiteral) {
				tokenType = TokenTypes.LITERAL;
				while (notEnd && isNextNumberOrLiteral) {
					readWriteChar();
				}
				if (Literals.BLOCK_STARTER_LITERALS[tokenData] == true) {
					tokenKind = TokenKind.BLOCK_STARTER;
				}
				if (Literals.ALL_LITERALS[tokenData] != null) {
					tokenKeyWord = Literals.ALL_LITERALS[tokenData]
				}
			} else if (char == "(") {
				tokenType = TokenTypes.OPEN;
//				tokenKind = TokenKind.GROUP_OPEN;
			} else if (char == ")") {
				tokenType = TokenTypes.CLOSE;
//				tokenKind = TokenKind.GROUP_CLOSE;
			} else if (char == "{") {
				tokenType = TokenTypes.OPEN_BLOCK;
				tokenKind = TokenKind.GROUP_OPEN;
			} else if (char == "}") {
				tokenType = TokenTypes.CLOSE_BLOCK;
				tokenKind = TokenKind.GROUP_CLOSE;
			} else if (char == "[") {
				tokenType = TokenTypes.OPEN_ARRAY;
//				tokenKind = TokenKind.GROUP_OPEN;
			} else if (char == "]") {
				tokenType = TokenTypes.CLOSE_ARRAY;
//				tokenKind = TokenKind.GROUP_CLOSE;
			} else if (char == "<") {
				if (nextChar == "=") {
					tokenType = TokenTypes.LESSEQUALS;
				} else {
					tokenType = TokenTypes.LESS;
//					tokenKind = TokenKind.GROUP_OPEN;
				}
			} else if (char == ">") {
				if (nextChar == "=") {
					tokenType = TokenTypes.MOREEQUALS;
				} else {
					tokenType = TokenTypes.MORE;
//					tokenKind = TokenKind.GROUP_CLOSE;
				}

			} else if (char == "=") {
				if (nextChar == "=") {
					tokenType = TokenTypes.EQUALS;
				} else {
					tokenType = TokenTypes.ASSIGN;
				}
			} else if (char == ".") {
				tokenType = TokenTypes.DOT;
			} else if (char == ",") {
				tokenType = TokenTypes.COMMA;
			} else if (char == "+" || char == "-" || char == "/" || char == "*" || char == "&") {
				tokenType = TokenTypes.OPERATOR;
			} else if (char == "|") {
				tokenType = TokenTypes.OR;
			} else if (char == "&") {
				tokenType = TokenTypes.AND;
			} else if (char == ";") {
				tokenType = TokenTypes.END;
			}

			if (tokenData != "") {
				tokens.push(new TokenVO(tokenKind, tokenType, tokenData, tokenKeyWord));
			}
		}

		for (var i:int = 0; i < tokens.length; i++) {
			debugLabel.text += tokens[i].type + ":" + tokens[i].value + ((tokens[i].keyWord) ? "\t\t\t" + tokens[i].keyWord : "") + "\n";
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
