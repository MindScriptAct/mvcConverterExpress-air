/**
 * Created with IntelliJ IDEA.
 * User: rbanevicius
 * Date: 5/15/13
 * Time: 2:54 PM
 * To change this template use File | Settings | File Templates.
 */
package constants {
import flash.utils.Dictionary;

public class Literals {

	// Statements

	public static const BREAK:String = "break";
	public static const CASE:String = "case";
	public static const CONTINUE:String = "continue";
	public static const DEFAULT:String = "default";
	public static const DO:String = "do";
	public static const ELSE:String = "else";
	public static const FOR:String = "for";
	public static const EACH:String = "each";
	public static const IN:String = "in";
	public static const IF:String = "if";
	public static const LABEL:String = "label";
	public static const RETURN:String = "return";
	public static const SUPER:String = "super";
	public static const SWITCH:String = "switch";
	public static const THROW:String = "throw";
	public static const TRY:String = "try";
	public static const CATCH:String = "catch";
	public static const FINALLY:String = "finally";
	public static const WHILE:String = "while";
	public static const WITH:String = "with";


	//Attribute Keywords

	public static const DYNAMIC:String = "dynamic"
	public static const FINAL:String = "final"
	public static const INTERNAL:String = "internal"
	public static const NATIVE:String = "native"
	public static const OVERRIDE:String = "override"
	public static const PRIVATE:String = "private"
	public static const PROTECTED:String = "protected"
	public static const PUBLIC:String = "public"
	public static const STATIC:String = "static"


	//Definition keywordS

	public static const REST:String = "..."
	public static const CLASS:String = "class"
	public static const CONST:String = "const"
	public static const EXTENDS:String = "extends"
	public static const FUNCTION:String = "function"
	public static const GET:String = "get"
	public static const IMPLEMENTS:String = "implements"
	public static const INTERFACE:String = "interface"
	public static const NAMESPACE:String = "namespace"
	public static const PACKAGE:String = "package"
	public static const SET:String = "set"
	public static const VAR:String = "var"


	//Primary expression keywords
	public static const FALSE:String = "false";
	public static const NULL:String = "null";
	public static const THIS:String = "this";
	public static const TRUE:String = "true";

	// misc
	public static const VOID:String = "void"
	public static const NOVALUE:String = "Null"

	public static const IMPORT:String = "import"

	// all
	public static var ALL_LITERALS:Dictionary = new Dictionary();
	public static var BLOCK_STARTER_LITERALS:Dictionary = new Dictionary();
	public static var MODIFIER_LITERALS:Dictionary = new Dictionary();

	// init
	public static function initLiteral():void {

		// overide object dynamic getters.


		ALL_LITERALS[BREAK] = "BREAK";
		ALL_LITERALS[CASE] = "CASE";
		ALL_LITERALS[CONTINUE] = "CONTINUE";
		ALL_LITERALS[DEFAULT] = "DEFAULT";
		ALL_LITERALS[DO] = "DO";
		ALL_LITERALS[ELSE] = "ELSE";
		ALL_LITERALS[FOR] = "FOR";
		ALL_LITERALS[EACH] = "EACH";
		ALL_LITERALS[IN] = "IN";
		ALL_LITERALS[IF] = "IF";
		ALL_LITERALS[LABEL] = "LABEL";
		ALL_LITERALS[RETURN] = "RETURN";
		ALL_LITERALS[SUPER] = "SUPER";
		ALL_LITERALS[SWITCH] = "SWITCH";
		ALL_LITERALS[THROW] = "THROW";
		ALL_LITERALS[TRY] = "TRY";
		ALL_LITERALS[CATCH] = "CATCH";
		ALL_LITERALS[FINALLY] = "FINALLY";
		ALL_LITERALS[WHILE] = "WHILE";
		ALL_LITERALS[WITH] = "WITH";

		ALL_LITERALS[DYNAMIC] = "DYNAMIC";
		ALL_LITERALS[FINAL] = "FINAL";
		ALL_LITERALS[INTERNAL] = "INTERNAL";
		ALL_LITERALS[NATIVE] = "NATIVE";
		ALL_LITERALS[OVERRIDE] = "OVERRIDE";
		ALL_LITERALS[PRIVATE] = "PRIVATE";
		ALL_LITERALS[PROTECTED] = "PROTECTED";
		ALL_LITERALS[PUBLIC] = "PUBLIC";
		ALL_LITERALS[STATIC] = "STATIC";

		ALL_LITERALS[REST] = "REST";
		ALL_LITERALS[CLASS] = "CLASS";
		ALL_LITERALS[CONST] = "CONST";
		ALL_LITERALS[EXTENDS] = "EXTENDS";
		ALL_LITERALS[FUNCTION] = "FUNCTION";
		ALL_LITERALS[GET] = "GET";
		ALL_LITERALS[IMPLEMENTS] = "IMPLEMENTS";
		ALL_LITERALS[INTERFACE] = "INTERFACE";
		ALL_LITERALS[NAMESPACE] = "NAMESPACE";
		ALL_LITERALS[PACKAGE] = "PACKAGE";
		ALL_LITERALS[SET] = "SET";
		ALL_LITERALS[VAR] = "VAR";

		ALL_LITERALS[FALSE] = "FALSE";
		ALL_LITERALS[TRUE] = "TRUE";
		ALL_LITERALS[NULL] = "NULL";
		ALL_LITERALS[THIS] = "THIS";

		ALL_LITERALS[VOID] = "VOID";
		ALL_LITERALS[NOVALUE] = "NOVALUE";

		ALL_LITERALS[IMPORT] = "IMPORT";


		BLOCK_STARTER_LITERALS[PACKAGE] = true;
		BLOCK_STARTER_LITERALS[IMPORT] = true;
		BLOCK_STARTER_LITERALS[CLASS] = true;
		BLOCK_STARTER_LITERALS[VAR] = true;
		BLOCK_STARTER_LITERALS[CONST] = true;
		BLOCK_STARTER_LITERALS[FUNCTION] = true;


		MODIFIER_LITERALS[DYNAMIC] = true;
		MODIFIER_LITERALS[FINAL] = true;
		MODIFIER_LITERALS[INTERNAL] = true;
		MODIFIER_LITERALS[NATIVE] = true;
		MODIFIER_LITERALS[OVERRIDE] = true;
		MODIFIER_LITERALS[PRIVATE] = true;
		MODIFIER_LITERALS[PROTECTED] = true;
		MODIFIER_LITERALS[PUBLIC] = true;
		MODIFIER_LITERALS[STATIC] = true;


	}


}
}
