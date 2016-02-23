import QtQuick 2.0

Item {
	id: balloonRoot

	property real speed: 100
	property real scale: 1

	// Url to image
	property url imageSource: "/components/balloon_red.png"

	// Dimensions of image after pre-scaling.
	property real imageWidth: 0
	property real imageHeight: 0

	property var clickHandler: function(){}
	property var lostHandler: function(){}

	property string typeofLostHandler_buf: ""
	property string typeOfClickHandler_buf: ""

	onImageHeightChanged: {
		balloonImage.height = balloonRoot.imageHeight
	}

	onImageWidthChanged: {
		balloonImage.width = balloonRoot.imageWidth
	}

	NumberAnimation on y {
		id: risingAnimation
		to: balloonImage.height*-1
		duration: (Math.abs(y+balloonImage.height) / speed)*1000
	}

	onYChanged: {
		if(balloonRoot.y <= -balloonImage.height)
		{
			typeofLostHandler_buf = typeof(balloonRoot.lostHandler);

			if(typeofLostHandler_buf === "function") {
				balloonRoot.lostHandler(balloonRoot); // Call lost handler
			} else {
				console.warning(balloonRoot.objectName + " lostHandler is not function.");
			}
		}
	}

	Image {
		id: balloonImage

		source: balloonRoot.imageSource
		scale: balloonRoot.scale

		MouseArea {
			id: baloonMouseArea
			anchors.fill: parent

			onClicked: {
				typeOfClickHandler_buf = typeof(balloonRoot.clickHandler);

				if(typeOfClickHandler_buf === "function") {
					balloonRoot.clickHandler(balloonRoot); // Call click handler
					console.debug(balloonRoot.objectName + ": Clicked!");
				} else {
					console.warning(balloonRoot.objectName + ": clickHandler is not function.");
				}
			}
		}
	}
}
