import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import QtMultimedia

Window {
    width: 600
    height: 500
    visible: true
    title: qsTr("Media Player")
    color: "#AF8EFF"

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        onAccepted: {
            fileDialog.close()
            player.stop()
            player.source = fileDialog.currentFile
            player.play()
            btnPlay.enabled = true
        }
        onRejected: {
            fileDialog.close()
        }
        Component.onCompleted: visible = false
        nameFilters: [ "audio files (*.mp3)" ]
    }

    Row {
        id: row
        anchors.left:parent.left
        anchors.leftMargin: 30
        anchors.top:parent.top
        anchors.topMargin: 200
        RoundButton{
            id:btnSelectFile
            height:40
            width:100
            radius:10
            background: Rectangle{
                color: "#ffffff"
                radius:10
            }

            Text{
                anchors.centerIn: parent
                text:"Select File"
                font.bold: true
                color: "#4c5980"
            }
            onClicked: {fileDialog.open();}
        }
        RoundButton {
            id:btnPlay
            height:40
            width:100
            radius:10
            background: Rectangle{
                color: "#ffffff"
                radius:10
            }
            anchors.leftMargin: 40
            anchors.left: btnSelectFile.right
            Text{
                anchors.centerIn: parent
                text:player.playbackState ===  MediaPlayer.PlayingState ? qsTr("Pause") : qsTr("Play")
                font.bold: true
                color: btnPlay.enabled ? "#4c5980" : "#d6d9e0"
            }
            enabled:false
            onClicked: {
                switch(player.playbackState) {
                case MediaPlayer.PlayingState: player.pause(); break;
                case MediaPlayer.PausedState: player.play(); break;
                case MediaPlayer.StoppedState: player.play(); break;
                }
            }
        }
    }

    Text{
        id: tvSelectedFile
        anchors.top:row.bottom
        anchors.topMargin: 60
        anchors.left: parent.left
        anchors.leftMargin: 30
        text: {
            let selectedFile = fileDialog.selectedFile+""
            let fileName = selectedFile.substring(selectedFile.lastIndexOf("/")+1)
            if(fileName.length > 0) {
                return "<b>Selected File : </b>" + fileName
            }else{
                return ""
            }
        }
    }

    Slider {
        id: progressSlider
        width: parent.width
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 25
        anchors.leftMargin: 30
        anchors.rightMargin: 30
        anchors.top: tvSelectedFile.bottom
        enabled: player.seekable
        value: player.duration > 0 ? player.position / player.duration : 0
        background: Rectangle {
            implicitHeight: 8
            color: "white"
            radius: 3
            Rectangle {
                width: progressSlider.visualPosition * parent.width
                height: parent.height
                color: "#1D8BF8"
                radius: 3
            }
        }
        handle: {}
        onMoved: function () {
            player.position = player.duration * progressSlider.position
        }
    }

    MediaPlayer {
        id: player
        audioOutput: AudioOutput{}
    }
}
