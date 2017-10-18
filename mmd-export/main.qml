import QtQuick 2.2
import Painter 1.0

PainterPlugin 
{
	tickIntervalMS: -1
	jsonServerPort: -1

	Component.onCompleted: { alg.ui.addToolBarWidget("UIToolbar.qml"); }
}