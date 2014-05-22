import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

import "../Storage/storage.js" as Storage

Window {
    id: aboutWindow

    flags: Qt.Dialog

    minimumWidth: 230
    maximumWidth: 230
    minimumHeight: 250
    maximumHeight: 250

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        spacing: 15

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter

            spacing: 0

            Text {
                text: "Obecność"

                Layout.alignment: Qt.AlignHCenter

                font.bold: true
                font.pixelSize: 30
            }

            Text {
                Layout.alignment: Qt.AlignHCenter

                text: "wersja 0.1.0-dev"

                color: "#888888"
                font.pixelSize: 12
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.alignment: Qt.AlignHCenter

            Text {
                Layout.alignment: Qt.AlignHCenter

                text: "Wersja SQLite: " + Storage.getDatabaseVersion()
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

            text: "<a href=\"https://github.com/mlazowik/present\">github</a>"

            onLinkActivated: {
                Qt.openUrlExternally(link);
            }
        }
    }
}
