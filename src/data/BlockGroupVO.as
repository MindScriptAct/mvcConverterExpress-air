package data {
public class BlockGroupVO extends BlockBaseVO {

	public var subTokns:Vector.<TokenVO>;

	public function BlockGroupVO(packageTokens:Vector.<TokenVO> = null, blockType:int = 0/*BlockTypes.UNDEFINED*/) {
		type = blockType;
		if (packageTokens) {
			subTokns = packageTokens;
		} else {
			subTokns = new <TokenVO>[];
		}
	}

	override public function readBlock():String {
		var retVal:String = "";
		var blockCount:int = subTokns.length;
		for (var i:int = 0; i < blockCount; i++) {
			retVal += subTokns[i].value;
		}
		return retVal;
	}

	override public function debugBlock(tab:String):String {
		var retVal:String = "";
		for (var i:int = 0; i < subTokns.length; i++) {
			retVal += tab + "" + subTokns[i].type + "\t\t\t\t" + subTokns[i].keyWord + "\n";
		}
		return retVal;
	}


}
}
