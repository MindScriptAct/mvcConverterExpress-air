package ruleSets {
import constants.FileStatus;

import flash.utils.Dictionary;

public class RuleSet {

	public var affectedFileStatus:int = FileStatus.NOT_DEFINED;

	public var imports_replace:Dictionary = new Dictionary();
	public var imports_remove:Dictionary = new Dictionary();

	public var literal_replace:Dictionary = new Dictionary();

	public var class_import_replace:Dictionary = new Dictionary();

	public var function_modifier_replace:Dictionary = new Dictionary();

	public var function_triger:Dictionary = new Dictionary();

	public var var_trugger:Dictionary = new Dictionary();

	public var var_remove:Dictionary = new Dictionary();



}
}
