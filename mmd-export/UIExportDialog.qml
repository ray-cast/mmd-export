import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import "export.js" as MMD

UIDialog
{
	width: 800
	height: 600
	minimumWidth: 400
	minimumHeight: 300
	title: "Select materials to export"

	QtObject
	{
		id: internal
		property var documentType:
		{
			'Material': "material",
			'Stack': "stack",
			'Channel': "channel"
		}

		function nextModelIndex(model, materialName)
		{
			var result = 0
			for (result = 0; result < model.count; ++result)
			{
				var modelObject = model.get(result)
				if (modelObject.type === documentType.Material && modelObject.name.localeCompare(materialName) > 0)
					break
			}

			return result
		}

		function updateProgressWindow(text)
		{
			progressWindow.text = text
		}

		function launchExport(exportMaps)
		{
			try
			{
				progressWindow.open()
				MMD.exportAssets(exportMaps, updateProgressWindow);
			}
			catch (err)
			{
			  alg.log.warn(err.message)
			}
			finally
			{
				progressWindow.close()
			}
		}
	}

	function reload()
	{
		var document = alg.mapexport.documentStructure()
		var mapsList = MMD.exportMaps();
		documentStructureModel.clear()
		
		for (var i in document.materials)
		{
			var material = document.materials[i]
			var materialID = internal.nextModelIndex(documentStructureModel, material.name)
			var modelMaterialId = materialID

			documentStructureModel.insert(materialID, {'name': material.name, 'path': material.name, 'type': internal.documentType.Material, 'parentIndex': 0, 'defaultChecked': mapsList.isChecked(material.name)})
			++materialID

			for (var j in material.stacks)
			{
				var stack = material.stacks[j]
				var stackPath = material.name + "." + stack.name
				var modelStackId = stack.name !== "" ? materialID : --materialID

				if (stack.name !== "")
				{
					documentStructureModel.insert(materialID, {'name': stack.name, 'path': stackPath, 'type': internal.documentType.Stack, 'parentIndex': materialID - modelMaterialId, 'defaultChecked': mapsList.isChecked(stackPath)})
				}

				++materialID

				for (var channelID in stack.channels)
				{
					var channel = stack.channels[channelID]
					var channelPath = stackPath + "." + channel
					documentStructureModel.insert(materialID, {'name': channel, 'path': channelPath, 'type': internal.documentType.Channel, 'parentIndex': materialID - modelStackId, 'defaultChecked': mapsList.isChecked(channelPath)})
					++materialID
				}

				var materialAdditional = alg.mapexport.additionalMapIdentifiers(material.name)
				for (var j in materialAdditional)
				{
					var additional = materialAdditional[j]
					var additionalPath = stackPath + "." + additional

					if (additional !== "")
					{
						documentStructureModel.insert(materialID, {'name': additional, 'path': additionalPath, 'type': internal.documentType.Channel, 'parentIndex': materialID - modelStackId, 'defaultChecked': mapsList.isChecked(additionalPath)})
					}
				}
			}
		}
	}

	onAccepted: 
	{
		var exportMaps = {}

		for (var i = 0; i < repeater.count; ++i)
		{
			if (repeater.itemAt(i).prevItem == undefined)
			{
				exportMaps[repeater.itemAt(i).text] = {}
				exportMaps[repeater.itemAt(i).text]['checked'] = repeater.itemAt(i).checked
			}
			else
			{
				exportMaps[repeater.itemAt(i).prevItem.text][repeater.itemAt(i).text] = repeater.itemAt(i).checked
			}
		}

		internal.launchExport(exportMaps)
	}

	UIProgressBar
	{
		id: progressWindow
	}

	ListModel
	{
		id: documentStructureModel
	}

	Rectangle
	{
		id: content
		parent: contentItem
		anchors.fill: parent
		anchors.margins: 12
		color: "transparent"
		clip: true

		ColumnLayout
		{
			spacing: 10
			anchors.fill: parent

			Flow 
			{
				anchors.top: parent.top
				anchors.left: parent.left; anchors.right: parent.right
				spacing: 6
				layoutDirection: Qt.LeftToRight
				UIButton { id: allButton; text: "All" }
				UIButton { id: noneButton; text: "None" }
				UIButton { id: basecolorButton; text: "basecolor" }
				UIButton { id: normalButton; text: "normal" }
				UIButton { id: roughnessButton; text: "roughness" }
				UIButton { id: metallicButton; text: "metallic" }
				UIButton { id: occlusionButton; text: "occlusion" }
				UIButton { id: heightButton; text: "height" }
				UIButton { id: curvatureButton; text: "curvature" }
				UIButton { id: thicknessButton; text: "thickness" }
				UIButton { id: worldSpaceNormalButton; text: "world_space_normal" }

				Connections
				{
					target: allButton; 
					onClicked:
					{
						for (var i = 0; i < repeater.count; ++i)
								repeater.itemAt(i).checked = true
					}
				}
				Connections
				{
					target: noneButton; 
					onClicked:
					{
						for (var i = 0; i < repeater.count; ++i)
								repeater.itemAt(i).checked = false
					}
				}
				Connections 
				{ 
					target: basecolorButton
					onClicked: 
					{
						for (var i = 0; i < repeater.count; ++i) {
							if (repeater.itemAt(i).text == "basecolor")
								repeater.itemAt(i).checked = !repeater.itemAt(i).checked
						}
					} 
				}
				Connections 
				{ 
					target: normalButton
					onClicked: 
					{
						for (var i = 0; i < repeater.count; ++i) {
							if (repeater.itemAt(i).text == "normal")
								repeater.itemAt(i).checked = !repeater.itemAt(i).checked
						}
					} 
				}
				Connections 
				{ 
					target: roughnessButton
					onClicked: 
					{
						for (var i = 0; i < repeater.count; ++i) {
							if (repeater.itemAt(i).text == "roughness")
								repeater.itemAt(i).checked = !repeater.itemAt(i).checked
						}
					} 
				}
				Connections 
				{ 
					target: metallicButton
					onClicked: 
					{
						for (var i = 0; i < repeater.count; ++i) {
							if (repeater.itemAt(i).text == "metallic")
								repeater.itemAt(i).checked = !repeater.itemAt(i).checked
						}
					} 
				}
				Connections 
				{ 
					target: occlusionButton
					onClicked: 
					{
						for (var i = 0; i < repeater.count; ++i) {
							if (repeater.itemAt(i).text == "ambient_occlusion")
								repeater.itemAt(i).checked = !repeater.itemAt(i).checked
						}
					} 
				}
				Connections 
				{ 
					target: heightButton
					onClicked: 
					{
						for (var i = 0; i < repeater.count; ++i) {
							if (repeater.itemAt(i).text == "height")
								repeater.itemAt(i).checked = !repeater.itemAt(i).checked
						}
					} 
				}
				Connections 
				{ 
					target: curvatureButton
					onClicked: 
					{
						for (var i = 0; i < repeater.count; ++i) {
							if (repeater.itemAt(i).text == "curvature")
								repeater.itemAt(i).checked = !repeater.itemAt(i).checked
						}
					} 
				}
				Connections 
				{ 
					target: thicknessButton
					onClicked: 
					{
						for (var i = 0; i < repeater.count; ++i) {
							if (repeater.itemAt(i).text == "thickness")
								repeater.itemAt(i).checked = !repeater.itemAt(i).checked
						}
					} 
				}
				Connections 
				{ 
					target: worldSpaceNormalButton
					onClicked: 
					{
						for (var i = 0; i < repeater.count; ++i) {
							if (repeater.itemAt(i).text == "world_space_normals")
								repeater.itemAt(i).checked = !repeater.itemAt(i).checked
						}
					} 
				}
			}

			UIScrollView
			{
				id: scrollView
				Layout.fillWidth: true
				Layout.fillHeight: true
				horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
				property int viewportWidth: viewport.width

				ColumnLayout 
				{
					spacing: 4
					Layout.minimumWidth: scrollView.viewportWidth
					Layout.maximumWidth: scrollView.viewportWidth

					Repeater
					{
						id: repeater
						model: documentStructureModel
						RowLayout
						{
							id: rowItem
							spacing: 6
							property int paddingSize: type === internal.documentType.Stack ? 10 : type === internal.documentType.Channel ? 20 : 0
							property var prevItem: null
							property alias checked: modelCheckBox.checked
							property alias text: modelTextEdit.text
							property string documentPath: path

							signal clicked()

							Layout.leftMargin: paddingSize
							Layout.minimumWidth: scrollView.viewportWidth - paddingSize
							Layout.maximumWidth: scrollView.viewportWidth - paddingSize

							Component.onCompleted:
							{
								if (parentIndex > 0) prevItem = repeater.itemAt(index - parentIndex)
							}

							UICheckBox
							{
								id: modelCheckBox
								checked: defaultChecked

								onClicked: { rowItem.clicked() }
								onCheckedChanged:
								{
									if (prevItem && checked)
										prevItem.checked = true;
								}

								Connections
								{
									target: prevItem
									onClicked:
									{
										checked = prevItem.checked
										rowItem.clicked()
									}
								}
							}
							UITextEdit
							{
								id: modelTextEdit
								readOnly: true
								borderActivated: true
								borderOpacity: type === internal.documentType.Stack ? 0.65 : type === internal.documentType.Channel ? 0.3 : 1.0
								Layout.fillWidth: true
								text: name
							}
						}
					}
				}
			}
		}
	}
}