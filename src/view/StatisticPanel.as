package view {
import com.bit101.components.Label;
import com.bit101.components.Label;
import com.bit101.graphic.WebImage;

import flash.display.Sprite;

public class StatisticPanel extends Sprite {

	var statusLabels:Vector.<Label> = new <Label>[];

	public function StatisticPanel() {
		new WebImage(this, 0, 0, "icons/status_0.png")
		new WebImage(this, 0, 20, "icons/status_1.png")
		new WebImage(this, 0, 40, "icons/status_2.png")
		new WebImage(this, 0, 80, "icons/status_3.png")
		new WebImage(this, 0, 100, "icons/status_4.png")
		new WebImage(this, 0, 120, "icons/status_5.png")
		new WebImage(this, 0, 150, "icons/status_6.png")

		statusLabels.push(new Label(this, 30, 0, "0"));
		statusLabels.push(new Label(this, 30, 20, "0"));
		statusLabels.push(new Label(this, 30, 40, "0"));
		statusLabels.push(new Label(this, 30, 80, "0"));
		statusLabels.push(new Label(this, 30, 100, "0"));
		statusLabels.push(new Label(this, 30, 120, "0"));
		statusLabels.push(new Label(this, 30, 150, "0"));


	}

	public function setAmount(amount:uint, statusId:int):void {
		statusLabels[statusId].text = String(amount);
	}

	public function inclease(statusId:int):void {
		statusLabels[statusId].text = String(int(statusLabels[statusId].text) + 1);
	}

	public function reduce(statusId:int):void {
		statusLabels[statusId].text = String(int(statusLabels[statusId].text) - 1);
	}
}
}
