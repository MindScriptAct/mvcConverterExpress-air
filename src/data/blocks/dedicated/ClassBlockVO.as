package data.blocks.dedicated {
import constants.BlockTypes;

import data.TokenVO;

import data.blocks.BlockContainerVO;

public class ClassBlockVO extends BlockContainerVO {

	public var extendClassToken:TokenVO;
	public var implementsLiteralToken:TokenVO;

	public var implementClassTokens:Array;

	public function ClassBlockVO() {
		super(BlockTypes.CLASS);
	}
}
}
