package data {
public class TokenVO {

	public var kind:int;
	public var type:String;
	public var value:String;
	public var keyWord:String;

	public function TokenVO(kind:int, type:String, value:String, keyWord:String) {
		this.kind = kind;
		this.type = type;
		this.value = value;
		this.keyWord = keyWord;
	}


}
}
