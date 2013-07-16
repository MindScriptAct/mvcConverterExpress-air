package ruleSets {
import constants.Literals;

import flash.utils.Dictionary;

public class RuleSetUnpureMvc extends RuleSet {


	public function RuleSetUnpureMvc() {

		imports_replace["org.puremvc.as3.patterns.facade.Facade"] = "org.mvcexpress.extension.unpuremvc.patterns.facade.UnpureFacade";
		imports_replace["org.puremvc.as3.patterns.facade.*"] = "org.mvcexpress.extension.unpuremvc.patterns.facade.UnpureFacade";
		imports_remove["org.puremvc.as3.interfaces.IFacade"] = true;

		imports_replace["org.puremvc.as3.patterns.command.MacroCommand"] = "org.mvcexpress.extension.unpuremvc.patterns.command.UnpureMacroCommand";
		imports_replace["org.puremvc.as3.patterns.command.SimpleCommand"] = "org.mvcexpress.extension.unpuremvc.patterns.command.UnpureSimpleCommand";

		imports_remove["org.puremvc.as3.patterns.command.*"] = true;

		imports_remove["org.puremvc.as3.interfaces.ICommand"] = true;

		imports_replace["org.puremvc.as3.patterns.mediator.Mediator"] = "org.mvcexpress.extension.unpuremvc.patterns.mediator.UnpureMediator";
		imports_replace["org.puremvc.as3.patterns.mediator.*"] = "org.mvcexpress.extension.unpuremvc.patterns.mediator.UnpureMediator";

		//imports_replace["org.puremvc.as3.interfaces.IMediator"] = "org.mvcexpress.extension.unpuremvc.patterns.mediator.UnpureMediator";

		imports_remove["org.puremvc.as3.interfaces.IMediator"] = true;

		imports_replace["org.puremvc.as3.patterns.proxy.Proxy"] = "org.mvcexpress.extension.unpuremvc.patterns.proxy.UnpureProxy";
		imports_replace["org.puremvc.as3.patterns.proxy.*"] = "org.mvcexpress.extension.unpuremvc.patterns.proxy.UnpureProxy";
		//imports_replace["org.puremvc.as3.interfaces.IProxy"] = "org.mvcexpress.extension.unpuremvc.patterns.proxy.UnpureProxy";
		imports_remove["org.puremvc.as3.interfaces.IProxy"] = true;

		imports_replace["org.puremvc.as3.patterns.observer.Notification"] = "org.mvcexpress.extension.unpuremvc.patterns.observer.UnpureNotification";
		imports_replace["org.puremvc.as3.patterns.observer.*"] = "org.mvcexpress.extension.unpuremvc.patterns.observer.UnpureNotification";

		imports_replace["org.puremvc.as3.interfaces.INotification"] = "org.mvcexpress.extension.unpuremvc.patterns.observer.UnpureNotification";


		literal_replace["Facade"] = "UnpureFacade"; // check imports.
		literal_replace["IFacade"] = "UnpureFacade"; // check imports.

		literal_replace["Mediator"] = "UnpureMediator"; // check import.
		literal_replace["Proxy"] = "UnpureProxy"; // check import.

		literal_replace["MacroCommand"] = "UnpureMacroCommand";
		literal_replace["SimpleCommand"] = "UnpureSimpleCommand";


		literal_replace["INotification"] = "UnpureNotification"; // check import.

		class_import_replace["Proxy"] = new Dictionary();
		class_import_replace["Proxy"]["IProxy"] = "";

		class_import_replace["Mediator"] = new Dictionary();
		class_import_replace["Mediator"]["IMediator"] = "";

		class_import_replace["SimpleCommand"] = new Dictionary();
		class_import_replace["SimpleCommand"]["ICommand"] = "";

		class_import_replace["MacroCommand"] = new Dictionary();
		class_import_replace["MacroCommand"]["ICommand"] = "";


		function_modifier_replace["Proxy"] = new Dictionary();
		function_modifier_replace["Proxy"]["onRegister"] = [Literals.PUBLIC, Literals.PROTECTED];
		function_modifier_replace["Proxy"]["onRemove"] = [Literals.PUBLIC, Literals.PROTECTED];

		function_modifier_replace["UnpureProxy"] = new Dictionary();
		function_modifier_replace["Proxy"]["onRegister"] = [Literals.PUBLIC, Literals.PROTECTED];
		function_modifier_replace["Proxy"]["onRemove"] = [Literals.PUBLIC, Literals.PROTECTED];


	}
}
}
