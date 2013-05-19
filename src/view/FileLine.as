package view {
import com.bit101.components.PushButton;
import com.bit101.components.Text;

import flash.display.Sprite;
import flash.filesystem.File;

public class FileLine extends Sprite {

	public static var homePath:String;

	public var analizeButton:PushButton;

	public var file:File;

	public function FileLine(file:File, tab:String) {
		//var nameSpit:Array = file.nativePath.split(textLabel.text)

		this.file = file;

		var fileLabel:Text = new Text(this, 30, 0, "");
		fileLabel.width = 800;
		fileLabel.height = 20;

		var nameSpit:Array = file.nativePath.split(homePath);

		if (file.isDirectory) {
			fileLabel.text += tab + "+-" + nameSpit[1] + "\n";
		} else {
			fileLabel.text += tab + " -" + nameSpit[1] + "\n";
		}

		analizeButton = new PushButton(this, 800, 0, "Anilize");

	}

}
}
