package ruleSets {
import data.blocks.BlockGroupVO;

public class RuleSetMacroCommand extends RuleSet {

	public function RuleSetMvcExpress() {

		imports_replace["org.mvcexpress.extension.unpuremvc.patterns.command.UnpureMacroCommand"] = "org.mvcexpress.mvc.Command";

		literal_replace["UnpureMacroCommand"] = "Command";

		literal_replace["addSubCommand"] = "commandMap.execute";

		function_triger["initializeMacroCommand"] = handle_initializeMacroCommand;


	}


	public function handle_initializeMacroCommand(block:BlockGroupVO):void {
		trace("handle : ", block);
	}

}
}
