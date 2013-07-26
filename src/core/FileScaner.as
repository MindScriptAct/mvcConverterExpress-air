package core {
import constants.FileStatus;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class FileScaner {

	public function FileScaner() {
	}

	public function scan(file:File):int {
		var retVal:int = FileStatus.UNSUPORTED;


		var localFileStream:FileStream = new FileStream();
		try {

			localFileStream.open(file, FileMode.READ);

			var fileText:String = localFileStream.readUTFBytes(file.size);


			if (fileText.indexOf("mvcexpress.mvc") > -1) {
				retVal = FileStatus.MVC_EXPRESS_v2;
			} else if (fileText.indexOf("mvcexpress.modules") > -1) {
				retVal = FileStatus.MVC_EXPRESS_v2;
			}


			if (fileText.indexOf("org.mvcexpress.mvc") > -1) {
				retVal = FileStatus.MVC_EXPRESS_v1;
			} else if (fileText.indexOf("org.mvcexpress.modules") > -1) {
				retVal = FileStatus.MVC_EXPRESS_v1;
			}


			if (fileText.indexOf("org.mvcexpress.extension.unpuremvc") > -1) {
				retVal = FileStatus.UNPURE_MVC;
			}


			if (fileText.indexOf("org.puremvc.as3") > -1) {
				retVal = FileStatus.PURE_MVC;
			}

		} catch (error:Error) {
			trace("WARINING : failed to read the file: ", file.nativePath, error);
			retVal = FileStatus.ERROR;
		}


		return retVal;
	}
}
}
