package core {
import com.bit101.components.TextArea;

import constants.AppConstants;
import constants.BlockTypes;
import constants.Literals;
import constants.TokenKind;
import constants.TokenTypes;

import data.TokenVO;
import data.blocks.BlockBaseVO;
import data.blocks.BlockContainerVO;
import data.blocks.BlockGroupVO;
import data.blocks.BlockTokenVO;
import data.blocks.dedicated.ClassBlockVO;
import data.blocks.dedicated.FunctionBlockVO;
import data.blocks.dedicated.PathBlockVO;

import flash.utils.Dictionary;

import ruleSets.RuleSet;

public class FileParser {
	private var debugLabel:TextArea;

	private var tokens:Vector.<TokenVO>;
	private var index:int;
	private var tokenCount:int;

	private var tokenStack:Vector.<TokenVO>;

	private var currentClassExtend:String = "";

	private var ruleSet:RuleSet;

	public function FileParser(debugLabel:TextArea) {
		this.debugLabel = debugLabel;
	}


	public function analizeTokens(tokens:Vector.<TokenVO>, ruleSet:RuleSet):String {
		this.tokens = tokens;
		this.ruleSet = ruleSet;
		tokenCount = tokens.length;
		index = 0;
		currentClassExtend = "";

		var root:BlockContainerVO = new BlockContainerVO(BlockTypes.ROOT);
		analizeBlock(root);
		// if something is left after scanning... just add it to the end. ()
		if (index < tokenCount) {
			readTillTheFileEnd(root);
		}
		// postProcess
		if (1) {
			//
			this.tokens = new <TokenVO>[];
			root.fillTokens(this.tokens);

			postProcess(this.tokens);

		}

		if (AppConstants.DEBUG_MODE) {
			debugLabel.text += "//==================\n// analize\n//==================\n";
			if (AppConstants.DEBUG_PARSER) {
				debugLabel.text += root.debugBlock("");
			}
		}

		var output:String = root.readBlock();

		if (AppConstants.DEBUG_MODE) {
			debugLabel.text += "//==================\n// output\n//==================\n";
			if (AppConstants.DEBUG_OUTPUT) {
				debugLabel.text += output;
			}
		}
		return output;
	}


	private function analizeBlock(fillBlock:BlockContainerVO):void {

		tokenStack = new <TokenVO>[];
		//var depth:int = 0;

		var bracketStack:Vector.<TokenVO> = new <TokenVO>[];

		while (index < tokenCount) {
			var token:TokenVO = tokens[index];

			if (token.kind == TokenKind.BLOCK_STARTER) {
//				// preblock
//				tokenStack.push(token);
//				var nextPreBlock:BlockGroupVO = new BlockGroupVO();
//				nextPreBlock.subTokns = tokenStack;
//				index++;
//
//				tokenStack = new <TokenVO>[];
				//
//				var subType:int = BlockTypes.UNDEFINED;

				switch (token.value) {
					case Literals.PACKAGE:
						clearStack(fillBlock);
						var packageBlock:PathBlockVO = new PathBlockVO(BlockTypes.PACKAGE);
						readStrictToken(packageBlock, TokenTypes.LITERAL, Literals.PACKAGE);
						readPath(packageBlock);
						readBlock(packageBlock);
						fillBlock.subBlocks.push(packageBlock);
						break;
					case Literals.IMPORT:
						clearStack(fillBlock);
						var importBlock:PathBlockVO = new PathBlockVO(BlockTypes.IMPORT);
						readStrictToken(importBlock, TokenTypes.LITERAL, Literals.IMPORT);
						readPath(importBlock);
						fillBlock.subBlocks.push(importBlock);
						handleImportFound(importBlock);
						break;
					case Literals.CLASS:
						var classBlock:ClassBlockVO = new ClassBlockVO();
						extractModifiers(fillBlock, classBlock);
						readStrictToken(classBlock, TokenTypes.LITERAL, Literals.CLASS);
						readClassHeader(classBlock);
						readBlock(classBlock);
						fillBlock.subBlocks.push(classBlock);
						handleClassFound(classBlock);
						break;
					case Literals.VAR:
						var varBlock:BlockContainerVO = new BlockContainerVO(BlockTypes.VAR);
						extractModifiers(fillBlock, varBlock);
						readStrictToken(varBlock, TokenTypes.LITERAL, Literals.VAR);
						readVariable(varBlock);
						fillBlock.subBlocks.push(varBlock);
						break;
					case Literals.CONST:
						var constBlock:BlockContainerVO = new BlockContainerVO(BlockTypes.CONST);
						extractModifiers(fillBlock, constBlock);
						readStrictToken(constBlock, TokenTypes.LITERAL, Literals.CONST);
						readVariable(constBlock);
						fillBlock.subBlocks.push(constBlock);
						break;
					case Literals.FUNCTION:
						var functionBlock:FunctionBlockVO = new FunctionBlockVO();
						extractModifiers(fillBlock, functionBlock);
						readStrictToken(functionBlock, TokenTypes.LITERAL, Literals.FUNCTION);
						readFunctionHeader(functionBlock);
						readBlock(functionBlock);
						fillBlock.subBlocks.push(functionBlock);
						handleFunctionFound(functionBlock);
						break;
					default:
						throw  Error("Not handled block literal:" + token.value);
						break;
				}
			} else if (token.kind == TokenKind.GROUP_OPEN) {
				// stack...
				bracketStack.push(token);
				tokenStack.push(token);
				index++;
			} else if (token.kind == TokenKind.GROUP_CLOSE) {
				// if stack is empty... break out of scanning.
				if (bracketStack.length) {
					var lastBracket:TokenVO = bracketStack.pop();
					// check if bracket maches ? what to do if its not.. :-\
					tokenStack.push(token);
					index++;
				} else {
					// should be
					break;
				}
			} else {
				tokenStack.push(token);
				index++;
			}
		}
		clearStack(fillBlock);
	}


	[Inline]
	private function readVariable(varBlock:BlockContainerVO):void {
		// lame variable reader...
		// TODO : impprove
		var varTokens:Vector.<TokenVO> = new <TokenVO>[];
		while (index < tokenCount) {
			var token:TokenVO = tokens[index];

			if (token.type != TokenTypes.END && token.kind != TokenKind.MODIFIER) {
				varTokens.push(token)
				index++;
			} else {
				if (token.type == TokenTypes.END) {
					varTokens.push(token)
					index++;
				}
				varBlock.subBlocks.push(new BlockGroupVO(varTokens, BlockTypes.VAR_DEFINITION));
				break;
			}
		}
	}

	[Inline]
	private function readClassHeader(classBlock:ClassBlockVO):void {
		var classHeaderBlock:BlockGroupVO = new BlockGroupVO(null, BlockTypes.CLASS_HEADER);
		/////////////
		// added readTillToken(classHeaderBlock, TokenTypes.OPEN_BLOCK) and analized for extends.
		/////////////
		var extendClassToken:TokenVO = null;
		var implementsLiteralToken:TokenVO = null;
		var implementClassTokens:Array = [];
		var useNextLiteralAsExtendClass:Boolean = false;
		var useNextLiteralAsImplementInterface:Boolean = false;
		/////////////
		while (index < tokenCount) {
			var token:TokenVO = tokens[index];
			if (token.type != TokenTypes.OPEN_BLOCK) {
				classHeaderBlock.subTokens.push(token);
				//
				/////////////
				if (token.type == TokenTypes.LITERAL) {
					if (token.value == Literals.EXTENDS) {
						useNextLiteralAsExtendClass = true;
					} else {
						if (useNextLiteralAsExtendClass) {
							useNextLiteralAsExtendClass = false;
							extendClassToken = token;

							currentClassExtend = token.value;
						}
					}

					if (token.value == Literals.IMPLEMENTS) {
						useNextLiteralAsImplementInterface = true;
						implementsLiteralToken = token;
					} else {
						if (useNextLiteralAsImplementInterface) {
							implementClassTokens.push(token);
						}

					}
				}
				if (useNextLiteralAsImplementInterface) {
					if (token.type != TokenTypes.LITERAL &&
							token.type != TokenTypes.COMMA &&
							token.type != TokenTypes.COMMENT &&
							token.type != TokenTypes.WHITE_SPACE) {

						useNextLiteralAsImplementInterface = false;
					}
				}
				/////////////
				//
			} else {
				break;
			}
			index++;
		}

		classBlock.extendClassToken = extendClassToken;
		classBlock.implementsLiteralToken = implementsLiteralToken;
		classBlock.implementClassTokens = implementClassTokens;
		/////////////

		classBlock.subBlocks.push(classHeaderBlock);
	}


	[Inline]
	private function readFunctionHeader(functionBlock:FunctionBlockVO):void {
		var functionHeaderBlock:BlockGroupVO = new BlockGroupVO(null, BlockTypes.FUNCTION_HEADER);

		////////////////////////////
		//readTillToken(functionHeaderBlock, TokenTypes.OPEN_BLOCK);
		////////////////////////////
		var functionName:String;
		var useNextLiteralAsFunctionName:Boolean = true;
		////////////////////////////

		// TODO : write proper header reader. (it should not look for block start. it should just read all possible header things and stop.)

		while (index < tokenCount) {
			var token:TokenVO = tokens[index];
			if (token.type != TokenTypes.OPEN_BLOCK && token.type != TokenTypes.END) {
				functionHeaderBlock.subTokens.push(token);
				///////////
				if (token.type == TokenTypes.LITERAL) {
					if (useNextLiteralAsFunctionName) {
						useNextLiteralAsFunctionName = false;
						functionName = token.value;
					}
				}
				///////////
			} else {
				break;
			}
			index++;
		}
		////////////////////////////
		functionBlock.name = functionName;
		////////////////////////////
		functionBlock.subBlocks.push(functionHeaderBlock);
	}

	[Inline]
	private function readHeader(classBlock:BlockContainerVO):void {
		var classHeaderBlock:BlockGroupVO = new BlockGroupVO(null, BlockTypes.HEADER);
		readTillToken(classHeaderBlock, TokenTypes.OPEN_BLOCK);
		classBlock.subBlocks.push(classHeaderBlock);
	}

	private function readTillToken(classHeaderBlock:BlockGroupVO, finishTokenType:String):void {
		while (index < tokenCount) {
			var token:TokenVO = tokens[index];
			if (token.type != finishTokenType) {
				classHeaderBlock.subTokens.push(token);
			} else {
				break;
			}
			index++;
		}
	}

	[Inline]
	private function extractModifiers(parentBlock:BlockContainerVO, childBlock:BlockContainerVO):void {
		var parentTokens:Vector.<TokenVO> = new <TokenVO>[];
		var modifierTokens:Vector.<TokenVO> = new <TokenVO>[];
		while (tokenStack.length) {
			var lastToken:TokenVO = tokenStack.pop();
			if (isBlank(lastToken.type) || lastToken.kind == TokenKind.MODIFIER) {
				modifierTokens.unshift(lastToken);
			} else {
				tokenStack.push(lastToken);
				break;
			}
		}
		//
		clearStack(parentBlock);
		//
		if (modifierTokens.length) {
			childBlock.subBlocks.push(new BlockGroupVO(modifierTokens, BlockTypes.MODIFIERS));
		}
	}

	[Inline]
	private function readBlock(blockContainerVO:BlockContainerVO):void {
		//readStrictToken(blockContainerVO, TokenTypes.OPEN_BLOCK);
		var opened:Boolean = readNextToken(blockContainerVO, TokenTypes.OPEN_BLOCK, "{");
		if (opened) {
			var block:BlockContainerVO = new BlockContainerVO(BlockTypes.BLOCK)
			analizeBlock(block);
			blockContainerVO.subBlocks.push(block);
			readStrictToken(blockContainerVO, TokenTypes.CLOSE_BLOCK);
		}
	}

	[Inline]
	private function readNestedTillCloseBlock(blockContainerVO:BlockContainerVO):void {
		var depth:int = 0;
		var blackConten:Vector.<TokenVO> = new <TokenVO>[];
		while (index < tokenCount) {
			var token:TokenVO = tokens[index];
			if (token.type == TokenTypes.OPEN_BLOCK) {
				depth++;
			} else if (token.type == TokenTypes.CLOSE_BLOCK) {
				if (depth > 0) {
					depth--;
				} else {
					//done
					blockContainerVO.subBlocks.push(new BlockGroupVO(blackConten));
					return;
				}
			}
			blackConten.push(token);
			index++;
		}
	}

	[Inline]
	private function readStrictToken(blockContainerVO:BlockContainerVO, expectedType:String = null, expectedValue:String = null):void {
		if (index < tokens.length) {
			var token:TokenVO = tokens[index];
			if (expectedType) {
				if (token.type != expectedType) {
					throw  Error("Expected type " + expectedType + " but instead it is :" + token.type);
				}
			}
			if (expectedValue) {
				if (token.value != expectedValue) {
					throw  Error("Expected value " + expectedValue + " but instead it is :" + token.value);
				}
			}
			blockContainerVO.subBlocks.push(new BlockTokenVO(token));
			index++;
		}
	}

	[Inline]
	private function readNextToken(blockContainerVO:BlockContainerVO, expectedType:String = null, expectedValue:String = null):Boolean {
		var retVal:Boolean = false;
		if (index < tokens.length) {
			var token:TokenVO = tokens[index];
			while (isBlank(token.type)) {
				blockContainerVO.subBlocks.push(new BlockTokenVO(token));
				index++;
				token = tokens[index];
			}
			if (expectedType == null || token.type == expectedType) {
				if (expectedValue == null || token.value == expectedValue) {
					retVal = true;
					blockContainerVO.subBlocks.push(new BlockTokenVO(token));
					index++;
				}
			}
		}
		return retVal;
	}

	[Inline]
	private function readPath(blockContainerVO:PathBlockVO):void {
		// simle literals, dot, literals, dot literal,... block open
		var pathTokens:Vector.<TokenVO> = new <TokenVO>[];

		var isLiteralStep:Boolean = true;
		var isDone:Boolean = false;

		var path:String = "";

		while (!isDone) {

			addBlanksToArray(pathTokens);
			if (index < tokenCount) {

				var token:TokenVO = tokens[index];

				if (isLiteralStep) {

					if (token.type == TokenTypes.LITERAL) {
						isLiteralStep = false;
					} else if (token.type == TokenTypes.MULT) {
						// add *
						pathTokens.push(token);
						index++;
						path += token.value;
						isDone = true;
					} else {
						isDone = true;
					}
				} else {

					if (token.type == TokenTypes.DOT) {
						isLiteralStep = true;
					} else {
						isDone = true;
					}
				}

			} else {
				isDone = true;
			}

			if (isDone) {
				addBlanksToArray(pathTokens);
				if (pathTokens.length) {
					blockContainerVO.subBlocks.push(new BlockGroupVO(pathTokens, BlockTypes.PATH));
					blockContainerVO.path = path;
				}
			} else {
				path += token.value;
				pathTokens.push(token);
				index++;
			}
		}
	}

	[Inline]
	private function addBlanksToArray(groupTokens:Vector.<TokenVO>):void {
		while (index < tokenCount) {
			var token:TokenVO = tokens[index];
			if (isBlank(token.type)) {
				groupTokens.push(token);
				index++
			} else {
				break;
			}
		}
	}

	[Inline]
	private function isBlank(type:String):Boolean {
		return type == TokenTypes.WHITE_SPACE || type == TokenTypes.COMMENT;
	}

	[Inline]
	private function clearStack(blockContainerVO:BlockContainerVO):void {
		if (tokenStack.length) {
			blockContainerVO.subBlocks.push(new BlockGroupVO(tokenStack));
			tokenStack = new <TokenVO>[];
		}
	}

	[Inline]
	private function readTillTheFileEnd(blockContainerVO:BlockContainerVO):void {
		var leftOvers:BlockGroupVO = new BlockGroupVO();
		while (index < tokenCount) {
			leftOvers.subTokens.push(tokens[index]);
			index++;
		}
		blockContainerVO.subBlocks.push(leftOvers);
	}


	////////////////////
	////////////////////
	////////////////////


	private function handleImportFound(importBlock:PathBlockVO):void {

		var newPath:String = ruleSet.imports_replace[importBlock.path];
		if (newPath) {

//			trace("Path found : " + importBlock.path);

			var pathBlock:BlockGroupVO = importBlock.subBlocks[1] as BlockGroupVO;

			var newPathTokens:Vector.<TokenVO> = new <TokenVO>[];

			for (var i:int = 0; i < pathBlock.subTokens.length; i++) {
				var token:TokenVO = pathBlock.subTokens[i];
				if (isBlank(token.type)) {
					newPathTokens.push(token);
				}
			}

			newPathTokens.push(new TokenVO(TokenKind.CUSTOME, TokenTypes.REPLACE, newPath, null));

			pathBlock.subTokens = newPathTokens;
		} else if (ruleSet.imports_remove[importBlock.path]) {

			var importToken:BlockTokenVO = importBlock.subBlocks[0] as BlockTokenVO;
			importToken.token.value = "";
			importToken.token.kind = TokenKind.CUSTOME;
			importToken.token.type = TokenTypes.REPLACE;

			pathBlock = importBlock.subBlocks[1] as BlockGroupVO;
			newPathTokens = new <TokenVO>[];
			pathBlock.subTokens = newPathTokens;
		}
	}


	private function handleClassFound(classBlock:ClassBlockVO):void {

		if (classBlock.extendClassToken) {

			var className:String = classBlock.extendClassToken.value;

			var replaceValue:String = ruleSet.literal_replace[className];
			if (replaceValue) {
				classBlock.extendClassToken.value = replaceValue;
				classBlock.extendClassToken.kind = TokenKind.CUSTOME;
				classBlock.extendClassToken.type = TokenTypes.REPLACE
			}

			var replaceImports:Dictionary = ruleSet.class_import_replace[className];
			if (replaceImports) {
				if (classBlock.implementClassTokens) {
					for (var key:String in replaceImports) {
						for (var i:int = 0; i < classBlock.implementClassTokens.length; i++) {
							if (classBlock.implementClassTokens[i].value == key) {
								if (classBlock.implementClassTokens.length == 1) {
									classBlock.implementsLiteralToken.value = "";
									classBlock.implementsLiteralToken.kind = TokenKind.CUSTOME;
									classBlock.implementsLiteralToken.type = TokenTypes.REPLACE;
								} else if (i == 0) {
									// TODO : remove COMMA after.
								} else {
									// TODO : remove COMMA before.
								}
								classBlock.implementClassTokens[i].value = replaceImports[key];
								classBlock.implementClassTokens[i].kind = TokenKind.CUSTOME;
								classBlock.implementClassTokens[i].type = TokenTypes.REPLACE
							}
						}
					}
				}
			}
		}
	}

	private function handleFunctionFound(functionBlock:FunctionBlockVO):void {
		if (ruleSet.function_modifier_replace[currentClassExtend]) {
			var replaceData:Array = ruleSet.function_modifier_replace[currentClassExtend][functionBlock.name]
		}
		if (replaceData) {
			var replaceFrom:String = replaceData[0];
			var replaceTo:String = replaceData[1];

			var subBlockCount:int = functionBlock.subBlocks.length
			for (var i:int = 0; i < subBlockCount; i++) {
				var childBlock:BlockBaseVO = functionBlock.subBlocks[i]
				if (childBlock.type == BlockTypes.MODIFIERS) {
					var modifierBlock:BlockGroupVO = childBlock as BlockGroupVO;
					var modifierCount:int = modifierBlock.subTokens.length;
					for (var j:int = 0; j < modifierCount; j++) {
						var modifierToken:TokenVO = modifierBlock.subTokens[j];
						if (modifierToken.value == replaceFrom) {
							modifierToken.value = replaceTo;
							modifierToken.kind = TokenKind.CUSTOME;
							modifierToken.type = TokenTypes.REPLACE
						}
					}
				}
			}

		}
	}


	/////////////////////////////////
	/////////////////////////////////
	/////////////////////////////////


	private function postProcess(tokens:Vector.<TokenVO>):void {
		var tokenCount:int = tokens.length;
		for (var i:int = 0; i < tokenCount; i++) {
			var token:TokenVO = tokens[i];

			if (token.type == TokenTypes.LITERAL) {
				if (ruleSet.literal_replace.propertyIsEnumerable(token.value)) {
					var replaceValue:String = ruleSet.literal_replace[token.value];
					token.value = replaceValue;
					token.kind = TokenKind.CUSTOME;
					token.type = TokenTypes.REPLACE
				}

			}


		}
	}


}
}
