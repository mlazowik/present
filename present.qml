import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import "Storage/storage.js" as Storage
import "Modals" as Modals

ApplicationWindow {
    id: root

    title: "Obecność"

    Component.onCompleted: {
        Storage.initalize();
        title += " (sqlite " + Storage.getDatabaseVersion() + ")";

        mainTable.updateStudents();
    }

    width: 500
    height: 400

    minimumHeight: 200
    minimumWidth: 400

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        spacing: 10

        TableView {
            id: mainTable

            Layout.fillWidth: true
            Layout.fillHeight: true

            TableViewColumn {
                role: "firstName"
                title: "Imię"

                width: 100
            }

            TableViewColumn {
                role: "lastName"
                title: "Nazwisko"

                width: 150
            }

            TableViewColumn {
                role: "cardId"
                title: "Identyfikator"
            }

            model: ListModel {
                id: studentsList
            }

            function updateStudents() {
                var students = Storage.getStudents();

                studentsList.clear();
                for (var i = 0; i < students.length; i++) {
                    studentsList.append(students[i]);
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            TextField {
                Layout.fillWidth: true
                focus: true
            }

            Button {
                text: "Dodaj"

                onClicked: {
                    addStudentWindow.visible = true
                }
            }
        }
    }

    Modals.AddStudent {
        id: addStudentWindow
    }
}
