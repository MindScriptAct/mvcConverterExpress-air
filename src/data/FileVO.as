package data {
import flash.filesystem.File;

public class FileVO {

	public var file:File;
	public var tab:String;


	public function FileVO(file:File, tab:String) {
		this.file = file;
		this.tab = tab;
	}


}
}
