import QtQuick 2.3
import QtQuick.Window 2.2

UIModalWindow
{
	flags: Qt.Dialog

	signal accepted()

	property alias contentItem: content
	property string defaultButtonText: "Ok"

	function accept()
	{
		accepted()
		close()
	}

	FocusScope
	{
		focus: true
		Keys.onPressed:
		{
			if (event.key === Qt.Key_Escape)
				close()
			else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter)
				accept()
		}
	}

	Rectangle
	{
		id: content
		anchors.top: parent.top
		anchors.bottom: buttons.top
		anchors.left: parent.left
		anchors.right: parent.right
		color: "transparent"
	}

	Flow
	{
		id: buttons
		anchors.bottom: parent.bottom
		anchors.left: parent.left; anchors.right: parent.right
		anchors.margins: 6
		spacing: 6
		layoutDirection: Qt.RightToLeft

		UIButton
		{
		  text: "Cancel"
		  onClicked: close()
		}
		UIButton
		{
			text: defaultButtonText
			isDefaultButton: true
			onClicked:
			{
				accept()
			}
		}
	}
}