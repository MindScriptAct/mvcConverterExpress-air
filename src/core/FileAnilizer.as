package core {
import com.bit101.components.TextArea;

import constants.BlockTypes;
import constants.Literals;
import constants.TokenKind;
import constants.TokenTypes;

import data.BlockBaseVO;
import data.BlockContainerVO;
import data.BlockGroupVO;
import data.BlockTokenVO;
import data.TokenVO;

public class FileAnilizer {
	private var debugLabel:TextArea;

	private var tokens:Vector.<TokenVO>;
	private var index:int;
	private var tokenCount:int;

	private var tokenStack:Vector.<TokenVO>;


	private var tempBlock:BlockBaseVO;


	public function FileAnilizer(debugLabel:TextArea) {
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
			readTillTheEnd(root);
		}

		debugLabel.text += "//==================\n// analize\n//==================\n";
		debugLabel.text += root.debugBlock("");

		debugLabel.text += "//==================\n// output\n//==================\n";
		debugLabel.text += root.readBlock();
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
						var packageBlack:BlockContainerVO = new BlockContainerVO(BlockTypes.PACKAGE);
						writeSingeToken(packageBlack, TokenTypes.LITERAL, Literals.PACKAGE);
						readPackageHeader(packageBlack);
						readBlock(packageBlack);
						fillBlock.subBlocks.push(packageBlack);
						break;
					case Literals.IMPORT:
//						subType = BlockTypes.IMPORT;
						tokenStack.push(token);
						index++;
						break;
					case Literals.CLASS:
//						subType = BlockTypes.CLASS;
						tokenStack.push(token);
						index++;
						break;
					case Literals.VAR:
//						subType = BlockTypes.VAR;
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
	private function readBlock(blockContainerVO:BlockContainerVO):void {
		writeSingeToken(blockContainerVO, TokenTypes.OPEN_BLOCK);
		var block:BlockContainerVO = new BlockContainerVO(BlockTypes.BLOCK)
		analizeBlock(block);
		blockContainerVO.subBlocks.push(block);
		writeSingeToken(blockContainerVO, TokenTypes.CLOSE_BLOCK);
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
	private function writeSingeToken(blockContainerVO:BlockContainerVO, expectedType:String = null, expectedValue:String = null):void {
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
	private function readPackageHeader(blockContainerVO:BlockContainerVO):void {
		// simle literals, dot, literals, dot literal,... block open
		var packageTokens:Vector.<TokenVO> = new <TokenVO>[];
		var isLiteralStep:Boolean = true;
		var isDone:Boolean = false;
		while (index < tokenCount) {
			var token:TokenVO = tokens[index];
			if (isBlank(token.type)) {
				// all fine.. just add those.
			} else {
				if (token.type == TokenTypes.OPEN_BLOCK) {
					isDone = true;
				} else {
					if (isLiteralStep) {
						if (token.type == TokenTypes.LITERAL) {
							isLiteralStep = false;
						} else {
							throw  Error("Name expected here in package declaration.");
						}
					} else {
						if (token.type == TokenTypes.DOT) {
							isLiteralStep = true;
						} else {
							throw  Error("Dot expected here in package declaration.");
						}
					}
				}
			}

			if (isDone) {
				if (packageTokens.length) {
					blockContainerVO.subBlocks.push(new BlockGroupVO(packageTokens, BlockTypes.PATH));
				}
				return;
			} else {
				packageTokens.push(token);
				index++;
			}
		}
	}

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
	private function readTillTheEnd(blockContainerVO:BlockContainerVO):void {
		var leftOvers:BlockContainerVO = new BlockContainerVO(BlockTypes.UNDEFINED);
		while (index < tokenCount) {
			leftOvers.subBlocks.push(tokens[index]);
		}
		blockContainerVO.subBlocks.push(leftOvers);
	}


}
}
