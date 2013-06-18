package data.blocks {
import data.*;

public class BlockGroupVO extends BlockBaseVO {

	public var subTokens:Vector.<TokenVO>;

	public function BlockGroupVO(packageTokens:Vector.<TokenVO> = null, blockType:int = 0/*BlockTypes.UNDEFINED*/) {
		type = blockType;
		if (packageTokens) {
			subTokens = packageTokens;
		} else {
			subTokens = new <TokenVO>[];
		}
	}

	override public function readBlock():String {
		var retVal:String = "";
		var blockCount:int = subTokens.length;
		for (var i:int = 0; i < blockCount; i++) {
			retVal += subTokens[i].value;
		}
		return retVal;
	}

	override public function debugBlock(tab:String):String {
		var retVal:String = "";
		var blockCount:int = subTokens.length;
		for (var i:int = 0; i < blockCount; i++) {
			retVal += tab + "" + subTokens[i].type + "\t\t\t\t" + subTokens[i].keyWord + "\t\t\t\t\t\t" + subTokens[i].value + "\n";
		}
		return retVal;
	}

	override public function fillTokens(tokens:Vector.<TokenVO>):void {
		var blockCount:int = subTokens.length;
		for (var i:int = 0; i < blockCount; i++) {
			tokens.push(subTokens[i]);
		}
	}

}
}
