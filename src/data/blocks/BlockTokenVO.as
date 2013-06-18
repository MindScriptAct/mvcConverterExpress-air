package data.blocks {
import data.*;

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
		return tab + "+" + token.type + "\t\t\t\t" + token.keyWord + "\t\t\t\t\t\t" + token.value + "\n";
	}

	override public function fillTokens(tokens:Vector.<TokenVO>):void {
		tokens.push(token);
	}

}
}
