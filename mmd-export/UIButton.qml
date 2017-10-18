import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Button
{
	property bool isDefaultButton

	isDefaultButton: false

	style: ButtonStyle
	{
		background: Rectangle
		{
			implicitWidth: 50
			implicitHeight: 24
			border.width: isDefaultButton ? 2 : 1
			border.color: isDefaultButton ? "#C8C8C8" : "#000000"
			radius: 4
			color: control.pressed ? "#323232" : control.hovered ? "#3C3C3C" : "#494949"
		}
		label: Component
		{
			Text
			{
				text: control.text
				font.bold: isDefaultButton
				clip: true
				wrapMode: Text.WordWrap
				verticalAlignment: Text.AlignVCenter
				horizontalAlignment: Text.AlignHCenter
				anchors.fill: parent
				color: control.pressed ? "#FFFFFF" : control.hovered ? "#1e94e6" : "#C8C8C8"
			}
		}
	}
}