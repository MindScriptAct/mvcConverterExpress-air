package data {
import constants.BlockTypes;

public class BlockContainerVO extends BlockBaseVO {

	public function BlockContainerVO(blockType:int = 0/*BlockTypes.UNDEFINED*/) {
		this.type = blockType;
	}

	public var subBlocks:Vector.<BlockBaseVO> = new <BlockBaseVO>[];

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
}
}
