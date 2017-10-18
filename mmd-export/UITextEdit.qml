import QtQuick 2.3

TextEdit 
{
	color: "#C8C8C8"
	property bool borderActivated
	property color borderColor: "#000000"
	property real borderOpacity: 1.
	borderActivated: false
	textMargin: borderActivated ? 4 : 0
	clip: true

	Rectangle
	{
		anchors.fill: parent
		color: "transparent"
		border.color: borderActivated ? borderColor : "transparent"
		opacity: borderOpacity
		radius: 4
	}
}
