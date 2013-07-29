package ruleSets {
import constants.FileStatus;
import constants.Literals;

import flash.utils.Dictionary;

public class RuleSetMvcExpressLive1to2 extends RuleSet {


	public function RuleSetMvcExpressLive1to2() {

		affectedFileStatus = FileStatus.MVC_EXPRESS_v1;

		imports_replace["org.mvcexpress.MvcExpress"] = "mvcexpress.MvcExpress";

		imports_replace["org.mvcexpress.modules.ModuleCore"] = "mvcexpress.dlc.live.modules.ModuleCoreLive";
		literal_replace["ModuleCore"] = "ModuleCoreLive";

		imports_replace["org.mvcexpress.mvc.Proxy"] = "mvcexpress.dlc.live.mvc.ProxyLive";
		imports_replace["org.mvcexpress.mvc.Mediator"] = "mvcexpress.dlc.live.mvc.MediatorLive";
		imports_replace["org.mvcexpress.mvc.Command"] = "mvcexpress.dlc.live.mvc.CommandLive";
		imports_replace["org.mvcexpress.mvc.PooledCommand"] = "mvcexpress.dlc.live.mvc.PooledCommandLive";


		literal_replace["Proxy"] = "ProxyLive";
		literal_replace["Mediator"] = "MediatorLive";
		literal_replace["Command"] = "CommandLive";
		literal_replace["PooledCommand"] = "PooledCommandLive";


		imports_replace["org.mvcexpress.live.Task"] = "mvcexpress.dlc.live.engine.Task";
		imports_replace["org.mvcexpress.live.Process"] = "mvcexpress.dlc.live.engine.Process";

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
