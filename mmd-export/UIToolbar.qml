import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Row
{
	UIExportDialog
	{
		id:exportDialog	
	}	
	Button
	{
		id: disney
		antialiasing: true
		tooltip: "Export to Ray-MMD"
		width: 30
		height: 30

		style: ButtonStyle 
		{
			background: Rectangle 
			{
				width: 30
				height: 30

				Image 
				{
					source: "icons/logo.png"
					fillMode: Image.PreserveAspectFit
					width: control.width; height: control.height
					mipmap: true
					opacity: 1.0
				}
			}
		}

		onClicked:
		{
			exportDialog.open()
		}
	}
}