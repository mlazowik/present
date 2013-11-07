import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    width: 500
    height: 400

    title: "Obecność"

    TableView {
        anchors.fill: parent

        TableViewColumn {
            title: "Imię"
        }

        TableViewColumn {
            title: "Nazwisko"
        }

        TableViewColumn {
            title: "Identyfikator"
        }

        TableViewColumn {
            title: "Akcje"
        }
    }
}
