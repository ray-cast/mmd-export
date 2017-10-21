import QtQuick 2.3
import QtQuick.Window 2.2

Window
{
	color: "#323232"
	modality: Qt.ApplicationModal
	visible: false
	property bool screenCentered: true

	function reload() {}
	function close() { visible = false }
	
	function open()
	{
		visible = true
		reload()
	}

	Component.onCompleted:
	{
		if (screenCentered)
		{
			x = Screen.width / 2 - width / 2
			y = Screen.height / 2 - height / 2
		}
	}
}
