package data.blocks {
import constants.BlockTypes;

import data.TokenVO;

public class BlockContainerVO extends BlockBaseVO {

	public var subBlocks:Vector.<BlockBaseVO> = new <BlockBaseVO>[];


	public function BlockContainerVO(blockType:int = 0/*BlockTypes.UNDEFINED*/) {
		this.type = blockType;
	}

	override public function readBlock():String {
		var retVal:String = "";
		var blockCount:int = subBlocks.length;
		for (var i:int = 0; i < blockCount; i++) {
			retVal += subBlocks[i].readBlock();
		}
		return retVal;
	}

	override public function debugBlock(tab:String):String {
		var retVal:String = "";
		for (var i:int = 0; i < subBlocks.length; i++) {
			retVal += tab + BlockTypes.DEBUG[subBlocks[i].type] + ":" + "\n" + subBlocks[i].debugBlock(tab + "\t");
		}
		return retVal;
	}

	override public function fillTokens(tokens:Vector.<TokenVO>):void {
		var blockCount:int = subBlocks.length;
		for (var i:int = 0; i < blockCount; i++) {
			subBlocks[i].fillTokens(tokens);
		}
	}
}
}
