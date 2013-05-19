package data {
import constants.BlockTypes;

public class BlockTokenVO extends BlockBaseVO {

	public var token:TokenVO;

	public function BlockTokenVO(token:TokenVO) {
		this.token = token;
		type = BlockTypes.KEY;
	}

	override public function readBlock():String {
		return token.value;
	}

	override public function debugBlock(tab:String):String {
		return tab + "+" + token.type + "\t\t\t\t" + token.keyWord + "\n";
	}
}
}
