import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs
import QtMultimedia

ApplicationWindow {
    width: Screen.width
    height: Screen.height
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
        nameFilters: [ "audio files (*.mp3)", "video files (*.mkv *.mp4 *.mov)" ]
    }

    Row {
        id: row
        height:40
        anchors.left:parent.left
        anchors.leftMargin: 30
        anchors.bottom:tvSelectedFile.top
        anchors.bottomMargin: 30
        RoundButton{
            id:btnSelectFile
            height:parent.height
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
            height:parent.height
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
        width:parent.width
        anchors.bottom:progressSlider.top
        anchors.bottomMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: 30
        wrapMode: Text.WordWrap
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
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        anchors.leftMargin: 30
        anchors.rightMargin: 30
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
        videoOutput: videoOutput
    }

    VideoOutput {
        id: videoOutput
        width:parent.width
        anchors.top: parent.top
        anchors.bottom: row.top
        anchors.bottomMargin: 60
        anchors.topMargin:20
        fillMode: VideoOutput.PreserveAspectFit
    }
}
