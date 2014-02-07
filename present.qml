import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import "Storage/storage.js" as Storage
import "Modals" as Modals

ApplicationWindow {
    id: root

    title: "Obecność"

    width: 700
    height: 400

    minimumHeight: 200
    minimumWidth: 700

    MenuBar {
        Menu {
            title: "Plik"
            MenuItem {
                text: "O programie"

                onTriggered: {
                    aboutWindow.visible = true;
                }
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10

        ColumnLayout {
            //spacing: 10

            TableView {
                id: presentStudentsTable

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

                    width: 100
                }

                TableViewColumn {
                    role: "cardId"
                    title: "Identyfikator"
                }

                model: ListModel {
                    id: presentStudentsList
                }

                function updatePresentStudents() {
                    var presentStudents = Storage.getPresentStudents();

                    presentStudentsList.clear();
                    for (var i = 0; i < presentStudents.length; i++) {
                        presentStudentsList.append(presentStudents[i]);
                    }
                }
            }

            TextField {
                id: namePresentField

                Layout.fillWidth: true

                Keys.onReturnPressed: {
                }
            }
        }

        ColumnLayout {
            Button {
                id: btnEnters

                text: "<-"

                onClicked: {
                    studentsTable.studentEnters();
                }
            }

            Button {
                id: btnLeaves

                text: "->"

                onClicked: {
                    addStudentWindow.visible = true;
                }
            }
        }

        ColumnLayout {
            //spacing: 10

            TableView {
                id: studentsTable

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

                    width: 100
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

                function studentEnters() {
                    if (currentRow !== -1) {
                        Storage.logStudentAction(
                            studentsList.get(currentRow).studentId,
                            1
                        );

                        presentStudentsTable.updatePresentStudents();
                    }
                }
            }

            TextField {
                id: nameField

                Layout.fillWidth: true

                Keys.onReturnPressed: {
                }
            }
        }
    }


    /*

    Button {
        id: btnAdd

        text: "Dodaj"

        onClicked: {
            addStudentWindow.visible = true;
        }
    }

    */

    Modals.AddStudent {
        id: addStudentWindow
    }

    Modals.About {
        id: aboutWindow
    }

    Component.onCompleted: {
        Storage.initalize();
        studentsTable.updateStudents();
        presentStudentsTable.updatePresentStudents();
    }
}
