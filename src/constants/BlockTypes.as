/**
 * Created with IntelliJ IDEA.
 * User: rbanevicius
 * Date: 5/16/13
 * Time: 4:12 PM
 * To change this template use File | Settings | File Templates.
 */
package constants {
import flash.utils.Dictionary;

public class BlockTypes {

	private static var blockCount:int = 0;

	public static const DEBUG:Dictionary = new Dictionary();

	public static const UNDEFINED:int = blockCount++;
	public static const ROOT:int = blockCount++;
	public static const PACKAGE:int = blockCount++;
	public static const IMPORT:int = blockCount++;
	public static const CLASS:int = blockCount++;
	public static const VAR:int = blockCount++;
	public static const CONST:int = blockCount++;
	public static const FUNCTION:int = blockCount++;

	public static const KEY:int = blockCount++;
	public static const PATH:int = blockCount++;
	public static const BLOCK:int = blockCount++;

	public static const MODIFIERS:int = blockCount++;
	public static const CLASS_HEADER:int = blockCount++;
	public static const VAR_DEFINITION:int = blockCount++;


	// init
	public static function initBlockTypes():void {
		DEBUG[UNDEFINED] = "UNDEFINED";
		DEBUG[ROOT] = "ROOT";
		DEBUG[PACKAGE] = "PACKAGE";
		DEBUG[IMPORT] = "IMPORT";
		DEBUG[CLASS] = "CLASS";
		DEBUG[VAR] = "VAR";
		DEBUG[CONST] = "CONST";
		DEBUG[FUNCTION] = "FUNCTION";

		DEBUG[KEY] = "key";
		DEBUG[PATH] = "path";
		DEBUG[BLOCK] = "block";

		DEBUG[MODIFIERS] = "modifiers";

		DEBUG[CLASS_HEADER] = "class-header";

		DEBUG[VAR_DEFINITION] = "var-definition";
	}

}
}
