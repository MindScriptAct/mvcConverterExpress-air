package ruleSets {
import constants.FileStatus;

import data.blocks.BlockGroupVO;

public class RuleSetMediatorExpresify extends RuleSet {

	public function RuleSetMediatorExpresify() {

		affectedFileStatus = FileStatus.UNPURE_MVC;

		imports_replace["org.mvcexpress.extension.unpuremvc.patterns.mediator.UnpureMediator"] = "org.mvcexpress.mvc.Mediator";


		imports_remove["org.mvcexpress.extension.unpuremvc.patterns.observer.UnpureNotification"] = true;

		literal_replace["UnpureMediator"] = "Mediator";

		literal_replace["sendNotification"] = "sendMessage";

	}

}
}
