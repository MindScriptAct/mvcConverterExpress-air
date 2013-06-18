package view {
import com.bit101.components.PushButton;
import com.bit101.components.Text;

import flash.display.Sprite;
import flash.filesystem.File;

public class FileLine extends Sprite {

	public static var homePath:String;

	public var analizeButton:PushButton;

	public var file:File;

	private var fileLabel:Text;

	public function FileLine() {
		//var nameSpit:Array = file.nativePath.split(textLabel.text)

		fileLabel = new Text(this, 30, 0, "");
		fileLabel.width = 700;
		fileLabel.height = 20;
		fileLabel.mouseEnabled = false;
		fileLabel.mouseChildren = false;

		analizeButton = new PushButton(this, 700, 0, "Anilize");

	}

	public function setData(file:File, tab:String):void {
		this.file = file;
		fileLabel.text = "";
		if (file) {

//		var nameSpit:Array = file.nativePath.split(homePath);

			if (file.isDirectory) {
//			fileLabel.text += tab + "+-" + nameSpit[1] + "\n";
				fileLabel.text += tab + "#    " + file.name + "\n";
			} else {
//			fileLabel.text += tab + " -" + nameSpit[1] + "\n";
				fileLabel.text += tab + "     " + file.name + "\n";
			}
		}
	}

}
}
