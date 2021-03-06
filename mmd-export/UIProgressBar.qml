import QtQuick 2.3
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

UIModalWindow
{
	minimumWidth: 400
	minimumHeight: 125
	maximumWidth: 400
	maximumHeight: 125
	title: "Exporting..."
	flags: Qt.Dialog | Qt.CustomizeWindowHint | Qt.WindowTitleHint | Qt.WindowSystemMenuHint

	property alias text: progressText.text

	Rectangle
	{
		color: "transparent"
		anchors.fill: parent
		anchors.margins: 12

		ColumnLayout
		{
			spacing: 18
			anchors.fill: parent

			Rectangle
			{
				color: "transparent"
				Layout.fillWidth: true
				UITextEdit
				{
					id: progressText
					anchors.centerIn: parent
					width: parent.width
					wrapMode: TextEdit.Wrap
					clip: true
					readOnly: true
				}
			}

			Rectangle
			{
				color: "transparent"
				Layout.fillWidth: true
				ProgressBar
				{
					  id: progressBar
					  anchors.centerIn: parent
					  width: parent.width
					  indeterminate: true

					style: ProgressBarStyle
					{
						background: Rectangle
						{
							color: "#323232"
							border.color: "#000000"
							border.width: 1
							implicitWidth: 200
							implicitHeight: 24
						}
						progress: Rectangle
						{
							color: control.indeterminate ? "transparent" : "#00BCF2"
							Item
							{
								id: bar
								anchors.fill: parent
								anchors.margins: 1
								visible: control.indeterminate
								clip: true
								property int actualIndex: 0

								Row
								{
									Repeater
									{
										Rectangle
										{
											color: "transparent"
											width: 120 ; height: control.height

											LinearGradient
											{
												anchors.fill: parent
												visible: index % 4 ? false : true
												start: Qt.point(0, 0)
												end: Qt.point(parent.width, 0)
												gradient: Gradient
												{
													GradientStop { position: 0.0; color: "#323232" }
													GradientStop { position: 1.0; color: "#00BCF2" }
												}
											}
										}
										model: control.width / 120 + 2
									}
									XAnimator on x
									{
										from: -120 ; to: 360
										duration: 1000
										loops: Animation.Infinite
										running: control.indeterminate
									}
								}
							}
						}
					}
				}
			}
		}
	}
}