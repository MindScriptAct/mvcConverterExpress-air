package ruleSets {
import constants.FileStatus;
import constants.Literals;

import flash.utils.Dictionary;

public class RuleSetUnpureMvc2 extends RuleSet {


	public function RuleSetUnpureMvc2() {

		affectedFileStatus = FileStatus.PURE_MVC;

		imports_replace["org.puremvc.as3.patterns.facade.Facade"] = "mvcexpress.dlc.unpuremvc.patterns.facade.UnpureFacade";
		imports_replace["org.puremvc.as3.patterns.facade.*"] = "mvcexpress.dlc.unpuremvc.patterns.facade.UnpureFacade";
		imports_remove["org.puremvc.as3.interfaces.IFacade"] = true;

		imports_replace["org.puremvc.as3.patterns.command.MacroCommand"] = "mvcexpress.dlc.unpuremvc.patterns.command.UnpureMacroCommand";
		imports_replace["org.puremvc.as3.patterns.command.SimpleCommand"] = "mvcexpress.dlc.unpuremvc.patterns.command.UnpureSimpleCommand";

		imports_remove["org.puremvc.as3.patterns.command.*"] = true;

		imports_remove["org.puremvc.as3.interfaces.ICommand"] = true;

		imports_replace["org.puremvc.as3.patterns.mediator.Mediator"] = "mvcexpress.dlc.unpuremvc.patterns.mediator.UnpureMediator";
		imports_replace["org.puremvc.as3.patterns.mediator.*"] = "mvcexpress.dlc.unpuremvc.patterns.mediator.UnpureMediator";

		//imports_replace["org.puremvc.as3.interfaces.IMediator"] = "mvcexpress.dlc.unpuremvc.patterns.mediator.UnpureMediator";

		imports_remove["org.puremvc.as3.interfaces.IMediator"] = true;

		imports_replace["org.puremvc.as3.patterns.proxy.Proxy"] = "mvcexpress.dlc.unpuremvc.patterns.proxy.UnpureProxy";
		imports_replace["org.puremvc.as3.patterns.proxy.*"] = "mvcexpress.dlc.unpuremvc.patterns.proxy.UnpureProxy";
		//imports_replace["org.puremvc.as3.interfaces.IProxy"] = "mvcexpress.dlc.unpuremvc.patterns.proxy.UnpureProxy";
		imports_remove["org.puremvc.as3.interfaces.IProxy"] = true;

		imports_replace["org.puremvc.as3.patterns.observer.Notification"] = "mvcexpress.dlc.unpuremvc.patterns.observer.UnpureNotification";
		imports_replace["org.puremvc.as3.patterns.observer.*"] = "mvcexpress.dlc.unpuremvc.patterns.observer.UnpureNotification";

		imports_replace["org.puremvc.as3.interfaces.INotification"] = "mvcexpress.dlc.unpuremvc.patterns.observer.UnpureNotification";


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

		function_modifier_replace["Mediator"] = new Dictionary();
		function_modifier_replace["Mediator"]["onRegister"] = [Literals.PUBLIC, Literals.PROTECTED];
		function_modifier_replace["Mediator"]["onRemove"] = [Literals.PUBLIC, Literals.PROTECTED];


	}
}
}
