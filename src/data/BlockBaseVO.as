package data {
import constants.BlockTypes;

import data.TokenVO;

public class BlockBaseVO {

	public var type:int = BlockTypes.UNDEFINED;

	private var parent:BlockBaseVO;


	public function readBlock():String {
		throw Error("Override me!");
		return null;
	}

	public function debugBlock(tab:String):String {
		throw Error("Override me!");
		return null;
	}


}
}
