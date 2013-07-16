package view {
import com.bit101.components.PushButton;
import com.bit101.components.Text;
import com.bit101.graphic.WebImage;

import flash.display.Sprite;
import flash.filesystem.File;

public class FileLine extends Sprite {

	public static var homePath:String;

	public var viewButton:PushButton;
	public var analizeButton:PushButton;

	public var id:int;
	public var file:File;

	private var fileLabel:Text;

	public function FileLine() {
		//var nameSpit:Array = file.nativePath.split(textLabel.text)

		fileLabel = new Text(this, 30, 0, "");
		fileLabel.width = 700;
		fileLabel.height = 20;
		fileLabel.mouseEnabled = false;
		fileLabel.mouseChildren = false;

		viewButton = new PushButton(this, 650, 0, "View");
		viewButton.width = 50;
		analizeButton = new PushButton(this, 700, 0, "Anilize");

	}

	private var webImage:WebImage;

	public function setData(id:int, file:File, tab:String, status:int):void {
		this.id = id;
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

		if (webImage) {
			webImage.load("icons/status_" + status + ".png");
		} else {
			webImage = new WebImage(this, 0, 0, "icons/status_" + status + ".png");
		}


	}

}
}
