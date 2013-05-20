package core {
import com.bit101.components.TextArea;

import constants.AppConstants;
import constants.BlockTypes;
import constants.Literals;
import constants.TokenKind;
import constants.TokenTypes;

import data.BlockBaseVO;
import data.BlockContainerVO;
import data.BlockGroupVO;
import data.BlockTokenVO;
import data.TokenVO;

public class FileParser {
	private var debugLabel:TextArea;

	private var tokens:Vector.<TokenVO>;
	private var index:int;
	private var tokenCount:int;

	private var tokenStack:Vector.<TokenVO>;


	private var tempBlock:BlockBaseVO;


	public function FileParser(debugLabel:TextArea) {
		this.debugLabel = debugLabel;
	}


	public function analizeTokens(tokens:Vector.<TokenVO>):void {
		this.tokens = tokens;
		tokenCount = tokens.length;
		index = 0;

		var root:BlockContainerVO = new BlockContainerVO(BlockTypes.ROOT);
		analizeBlock(root);
		// if something is left after scanning... just add it to the end. ()
		if (index < tokenCount) {
			readTillTheFileEnd(root);
		}

		debugLabel.text += "//==================\n// analize\n//==================\n";
		if (AppConstants.DEBUG_PARSER) {
			debugLabel.text += root.debugBlock("");
		}

		debugLabel.text += "//==================\n// output\n//==================\n";
		if (AppConstants.DEBUG_OUTPUT) {
			debugLabel.text += root.readBlock();
		}
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
						var packageBlock:BlockContainerVO = new BlockContainerVO(BlockTypes.PACKAGE);
						readStrictToken(packageBlock, TokenTypes.LITERAL, Literals.PACKAGE);
						readPath(packageBlock);
						readBlock(packageBlock);
						fillBlock.subBlocks.push(packageBlock);
						break;
					case Literals.IMPORT:
						clearStack(fillBlock);
						var importBlock:BlockContainerVO = new BlockContainerVO(BlockTypes.IMPORT);
						readStrictToken(importBlock, TokenTypes.LITERAL, Literals.IMPORT);
						readPath(importBlock);
						fillBlock.subBlocks.push(importBlock);
						break;
					case Literals.CLASS:
						var classBlock:BlockContainerVO = new BlockContainerVO(BlockTypes.CLASS);
						extractModifiers(fillBlock, classBlock);
						readStrictToken(importBlock, TokenTypes.LITERAL, Literals.CLASS);
						readClassHeader(classBlock);
						readBlock(classBlock);
						fillBlock.subBlocks.push(classBlock);
						break;
					case Literals.VAR:
//						var varBlock:BlockContainerVO = new BlockContainerVO(BlockTypes.VAR);

//						extractModifiers(fillBlock, varBlock);


						tokenStack.push(token);
						index++;


						break;
					case Literals.CONST:
//						subType = BlockTypes.CONST;
						tokenStack.push(token);
						index++;
						break;
					case Literals.FUNCTION:
//						subType = BlockTypes.FUNCTION;
						tokenStack.push(token);
						index++;
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
	private function readClassHeader(classBlock:BlockContainerVO):void {
		var classHeaderBlock:BlockGroupVO = new BlockGroupVO(null, BlockTypes.CLASS_HEADER);
		readTillToken(classHeaderBlock, TokenTypes.OPEN_BLOCK);
		classBlock.subBlocks.push(classHeaderBlock);
	}

	private function readTillToken(classHeaderBlock:BlockGroupVO, finishTokenType:String):void {
		while (index < tokenCount) {
			var token:TokenVO = tokens[index];
			if (token.type != finishTokenType) {
				classHeaderBlock.subTokns.push(token);
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
		readStrictToken(blockContainerVO, TokenTypes.OPEN_BLOCK);
		var block:BlockContainerVO = new BlockContainerVO(BlockTypes.BLOCK)
		analizeBlock(block);
		blockContainerVO.subBlocks.push(block);
		readStrictToken(blockContainerVO, TokenTypes.CLOSE_BLOCK);
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

	[Inline]
	private function readNextToken(blockContainerVO:BlockContainerVO, expectedType:String = null, expectedValue:String = null):Boolean {
		var retVal:Boolean = false;
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
		return retVal;
	}

	[Inline]
	private function readPath(blockContainerVO:BlockContainerVO):void {
		// simle literals, dot, literals, dot literal,... block open
		var pathTokens:Vector.<TokenVO> = new <TokenVO>[];

		var isLiteralStep:Boolean = true;
		var isDone:Boolean = false;

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
				}
			} else {
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
		return type == TokenTypes.WHITE_SPACE || type == TokenTypes.LINE_COMMENT || type == TokenTypes.BLOCK_COMMENT;
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
		var leftOvers:BlockContainerVO = new BlockContainerVO(BlockTypes.UNDEFINED);
		while (index < tokenCount) {
			leftOvers.subBlocks.push(tokens[index]);
		}
		blockContainerVO.subBlocks.push(leftOvers);
	}


}
}
