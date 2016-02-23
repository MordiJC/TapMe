import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1

import "components"

Window {
	id: mainWindow
	visible: true
	title: "TapMe"
	width: 300; height: 500

	// Game data
	property int points: 0
	property int lost: 0

	property int minNextBalloonTime: 100
	property int maxNextBalloonTime: 1500

	property real minNextBalloonSpeed: 20
	property real maxNextBalloonSpeed: 180

	property var balloonsComponent: Qt.createComponent("components/Balloon.qml")

	property var balloonsOnScreen: [];
	//balloonsComponent.createObject(game, {x: 50, y: -10, scale: 1,imageWidth: 25.5,
	//imageHeight: 32, speed: 0})

	/// [ Utility functions ] \\\

	// Get random from range: <a, b>
	function getRandom(a, b) {
		var t = Math.min(a,b); b = Math.max(a,b); a = t
		return Math.random() * (b-a+1) + a;
	}

	// Get random int from range: <a, b>
	function getRandomInt(a, b) {
		var t = Math.min(a,b); b = Math.max(a,b); a = t
		return Math.floor(Math.random() * (b-a+1)) + a;
	}

	function spawnBaloon() {
		//balloonsOnScreen[balloonsOnScreen.length] = balloonsComponent.createObject(game, {x: getRandomInt(10, 270), y: getRandomInt(10, 430), scale: 1, imageWidth: 25.5, imageHeight: 32});
		balloonsOnScreen[balloonsOnScreen.length]
				= balloonsComponent.createObject(game,{
													x: getRandomInt(10, game.width),
													y: game.height,
													scale: 1,
													imageWidth: 25.5,
													imageHeight: 32,
													clickHandler: mainWindow.balloonClicked,
													lostHandler: mainWindow.balloonFlewAway,
													speed: getRandomInt(mainWindow.minNextBalloonSpeed, mainWindow.maxNextBalloonSpeed)
												});
	}

	function balloonClicked(balloon, it, ln) {
		for(it = 0, ln = game.children.length; it < ln; ++it)
		{
			if(game.children[it] === balloon){
				++points;
				game.children[it].destroy();
				delete game.children[it];
			}
		}
	}

	function balloonFlewAway(balloon, it, ln) {
		for(it = 0, ln = game.children.length; it < ln; ++it)
		{
			if(game.children[it] === balloon){
				++lost;
				game.children[it].destroy();
				delete game.children[it];
			}
		}
	}

	Timer {
		id: spawningTimer
		running: true
		interval: 1000
		repeat: false
		onTriggered: {
			// Spawn baloon
			mainWindow.spawnBaloon()

			// Get random time from range
			spawningTimer.interval = getRandomInt(mainWindow.minNextBalloonTime, mainWindow.maxNextBalloonTime)
			// Start timer
			spawningTimer.start()
		}
	}

	ColumnLayout {
		anchors.fill: parent
		Rectangle {
			id: game
			anchors.bottom: textRow.top
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.top: parent.top
			clip: true
			color: "white"
		}

		Row {
			id: textRow
			anchors.bottom: parent.bottom
			anchors.left: parent.left
			anchors.right: parent.right
			spacing: Math.abs(textRow.width - (pointsColumn.width + lostColumn.width))
			anchors.rightMargin: 10

			onWidthChanged: {
				spacing = Math.abs(textRow.width - (pointsColumn.width + lostColumn.width));
			}

			Column {
				id: pointsColumn
				Row {
					Text {
						id: pointsLabel
						text: qsTr("Points: ")
						font.pointSize: 14
					}
					Text {
						id: pointsCounter
						text: mainWindow.points
						font.pointSize: 14
					}
				}
			}

			Column {
				id: lostColumn
				Row {
					Text {
						id: lostLabel
						text: qsTr("Lost: ");
						font.pointSize: 14
					}
					Text {
						id: lostCounter
						text: mainWindow.lost
						font.pointSize: 14
					}
				}
			}
		}
	}
}
