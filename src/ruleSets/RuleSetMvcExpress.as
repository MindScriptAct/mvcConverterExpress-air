package ruleSets {
import constants.FileStatus;

public class RuleSetMvcExpress extends RuleSet {

	public function RuleSetMvcExpress() {

		affectedFileStatus = FileStatus.UNPURE_MVC;

		imports_replace["org.mvcexpress.extension.unpuremvc.patterns.command.UnpureSimpleCommand"] = "org.mvcexpress.mvc.Command";
		//imports_replace["org.mvcexpress.extension.unpuremvc.patterns.command.UnpureMacroCommand"] = "????";

		imports_replace["org.mvcexpress.extension.unpuremvc.patterns.mediator.UnpureMediator"] = "org.mvcexpress.mvc.Mediator";

		imports_replace["org.mvcexpress.extension.unpuremvc.patterns.proxy.UnpureProxy"] = "org.mvcexpress.mvc.Proxy";

		//literal_replace["UnpureMacroCommand"] = "??";
		literal_replace["UnpureSimpleCommand"] = "Command";

		literal_replace["UnpureMediator"] = "Mediator"; // check import.
		literal_replace["UnpureProxy"] = "Proxy"; // check import.


	}

}
}
