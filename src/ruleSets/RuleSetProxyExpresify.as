package ruleSets {
import data.blocks.BlockGroupVO;

public class RuleSetProxyExpresify extends RuleSet {

	public function RuleSetProxyExpresify() {

		imports_replace["org.mvcexpress.extension.unpuremvc.patterns.proxy.UnpureProxy"] = "org.mvcexpress.mvc.Proxy";

		literal_replace["UnpureProxy"] = "Proxy";

		literal_replace["sendNotification"] = "sendMessage";

		literal_replace["retrieveProxy"] = "hack_proxyMap.getProxy";

		var_remove["NAME"] = true;


	}

}
}
