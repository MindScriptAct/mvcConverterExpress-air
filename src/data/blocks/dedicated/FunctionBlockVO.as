package data.blocks.dedicated {
import constants.BlockTypes;

import data.TokenVO;

import data.blocks.BlockContainerVO;

public class FunctionBlockVO extends BlockContainerVO {

	public var name:String;

	public function FunctionBlockVO() {
		super(BlockTypes.FUNCTION);
	}
}
}
