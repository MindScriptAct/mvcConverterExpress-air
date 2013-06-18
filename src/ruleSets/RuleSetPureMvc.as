package ruleSets {
import constants.Literals;

import flash.utils.Dictionary;

public class RuleSetPureMvc extends RuleSet {


	public function RuleSetPureMvc() {

		imports_replace["org.puremvc.as3.patterns.facade.Facade"] = "org.mvcexpress.extension.unpuremvc.patterns.facade.UnpureFacade";
		imports_replace["org.puremvc.as3.patterns.facade.*"] = "org.mvcexpress.extension.unpuremvc.patterns.facade.UnpureFacade";

		imports_replace["org.puremvc.as3.patterns.command.MacroCommand"] = "org.mvcexpress.extension.unpuremvc.patterns.command.UnpureMacroCommand";
		imports_replace["org.puremvc.as3.patterns.command.SimpleCommand"] = "org.mvcexpress.extension.unpuremvc.patterns.command.UnpureSimpleCommand";
		//imports["org.puremvc.as3.patterns.command.*"] = ["org.mvcexpress.extension.unpuremvc.patterns.command.UnpureMacroCommand", "org.mvcexpress.extension.unpuremvc.patterns.command.UnpureSimpleCommand"]

		imports_replace["org.puremvc.as3.patterns.mediator.Mediator"] = "org.mvcexpress.extension.unpuremvc.patterns.mediator.UnpureMediator";
		imports_replace["org.puremvc.as3.patterns.mediator.*"] = "org.mvcexpress.extension.unpuremvc.patterns.mediator.UnpureMediator";


		imports_replace["org.puremvc.as3.patterns.proxy.Proxy"] = "org.mvcexpress.extension.unpuremvc.patterns.proxy.UnpureProxy";
		imports_replace["org.puremvc.as3.patterns.proxy.*"] = "org.mvcexpress.extension.unpuremvc.patterns.proxy.UnpureProxy";

		imports_replace["org.puremvc.as3.patterns.observer.Notification"] = "org.mvcexpress.extension.unpuremvc.patterns.observer.UnpureNotification";
		imports_replace["org.puremvc.as3.patterns.observer.*"] = "org.mvcexpress.extension.unpuremvc.patterns.observer.UnpureNotification";

		imports_replace["org.puremvc.as3.interfaces.INotification"] = "org.mvcexpress.extension.unpuremvc.patterns.observer.UnpureNotification";


		literals_replace["Facade"] = "UnpureFacade"; // check imports.
		literals_replace["Mediator"] = "UnpureMediator"; // check import.
		literals_replace["Proxy"] = "UnpureProxy"; // check import.

		literals_replace["MacroCommand"] = "UnpureMacroCommand";
		literals_replace["SimpleCommand"] = "UnpureSimpleCommand";


		literals_replace["INotification"] = "UnpureNotification"; // check import.


		function_modifier_replace["Proxy"] = new Dictionary();
		function_modifier_replace["Proxy"]["onRegister"] = [Literals.PUBLIC, Literals.PROTECTED];
		function_modifier_replace["Proxy"]["onRemove"] = [Literals.PUBLIC, Literals.PROTECTED];

		function_modifier_replace["UnpureProxy"] = new Dictionary();
		function_modifier_replace["Proxy"]["onRegister"] = [Literals.PUBLIC, Literals.PROTECTED];
		function_modifier_replace["Proxy"]["onRemove"] = [Literals.PUBLIC, Literals.PROTECTED];


	}
}
}
