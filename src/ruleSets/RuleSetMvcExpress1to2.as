package ruleSets {
import constants.FileStatus;
import constants.Literals;

import flash.utils.Dictionary;

public class RuleSetMvcExpress1to2 extends RuleSet {


	public function RuleSetMvcExpress1to2() {

		affectedFileStatus = FileStatus.MVC_EXPRESS_v1;

		imports_replace["org.mvcexpress.MvcExpress"] = "mvcexpress.MvcExpress";

		imports_replace["org.mvcexpress.modules.ModuleCore"] = "mvcexpress.modules.ModuleCore";

		imports_replace["org.mvcexpress.mvc.Proxy"] = "mvcexpress.mvc.Proxy";
		imports_replace["org.mvcexpress.mvc.Mediator"] = "mvcexpress.mvc.Mediator";
		imports_replace["org.mvcexpress.mvc.Command"] = "mvcexpress.mvc.Command";
		imports_replace["org.mvcexpress.mvc.PooledCommand"] = "mvcexpress.mvc.PooledCommand";


		imports_replace["org.mvcexpress.utils.AssertExpress"] = "mvcexpress.utils.AssertExpress";
		imports_replace["org.mvcexpress.utils.checkClassStringConstants"] = "mvcexpress.utils.checkClassStringConstants";
		imports_replace["org.mvcexpress.utils.checkClassSuperclass"] = "mvcexpress.utils.checkClassSuperclass";


		imports_remove["org.mvcexpress.modules.ModuleSprite"] = true;
		imports_remove["org.mvcexpress.modules.ModuleMovieclip"] = true;


		literal_replace["ModuleSprite"] = "Sprite";
		literal_replace["ModuleMovieclip"] = "MovieClip";


		function_modifier_replace["Mediator"] = new Dictionary();
		function_modifier_replace["Mediator"]["onRegister"] = [Literals.PUBLIC, Literals.PROTECTED];
		function_modifier_replace["Mediator"]["onRemove"] = [Literals.PUBLIC, Literals.PROTECTED];

//		function_modifier_replace["UnpureProxy"] = new Dictionary();
//		function_modifier_replace["Proxy"]["onRegister"] = [Literals.PUBLIC, Literals.PROTECTED];
//		function_modifier_replace["Proxy"]["onRemove"] = [Literals.PUBLIC, Literals.PROTECTED];


	}
}
}
