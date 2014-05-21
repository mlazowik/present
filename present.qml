import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

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
                text: "Dodaj ucznia"

                onTriggered: {
                    addStudentWindow.visible = true;
                }
            }

            MenuSeparator {}

            MenuItem {
                text: "O programie"

                onTriggered: {
                    aboutWindow.visible = true;
                }
            }
        }
    }

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 10

        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                spacing: 10

                Text {
                    id: studentsHeader

                    Layout.fillWidth: true

                    text: "<strong>Poza biblioteką</strong>"

                    horizontalAlignment: Text.AlignHCenter
                }

                TableView {
                    id: studentsTable

                    property var students

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
                        students = Storage.getStudents();

                        updateStudentsList();
                    }

                    function updateStudentsList() {
                        studentsList.clear();

                        var filter = searchField.text;
                        for (var i = 0; i < students.length; i++) {
                            if (filter === "" || studentMatches(students[i], filter)) {
                                studentsList.append(students[i]);
                            }
                        }
                    }

                    function studentEnters() {
                        if (currentRow !== -1) {
                            Storage.logStudentAction(
                                studentsList.get(currentRow).studentId,
                                1
                            );

                            presentStudentsTable.updatePresentStudents();
                            studentsTable.updateStudents();
                        }
                    }

                    onDoubleClicked: {
                        studentEnters();
                    }
                }
            }

            ColumnLayout {
                spacing: 10

                /*Button {
                id: btnAdd

                text: "Dodaj"

                onClicked: {
                    addStudentWindow.visible = true;
                }
            }*/

                Button {
                    id: btnEnters

                    text: "->"

                    onClicked: {
                        studentsTable.studentEnters();
                    }
                }

                Button {
                    id: btnLeaves

                    text: "<-"

                    onClicked: {
                        presentStudentsTable.studentLeaves();
                    }
                }
            }

            ColumnLayout {
                spacing: 10

                Text {
                    id: presentStudentsHeader

                    Layout.fillWidth: true

                    text: "<strong>Obecni</strong>"

                    horizontalAlignment: Text.AlignHCenter
                }

                TableView {
                    id: presentStudentsTable

                    property var presentStudents

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
                        presentStudents = Storage.getPresentStudents();

                        updatePresentStudentsList();
                    }

                    function updatePresentStudentsList() {
                        presentStudentsList.clear();

                        var filter = searchField.text;
                        for (var i = 0; i < presentStudents.length; i++) {
                            if (filter === "" || studentMatches(presentStudents[i], filter)) {
                                presentStudentsList.append(presentStudents[i]);
                            }
                        }
                    }

                    function studentLeaves() {
                        if (currentRow !== -1) {
                            Storage.logStudentAction(
                                        presentStudentsList.get(currentRow).studentId,
                                        -1
                                        );

                            presentStudentsTable.updatePresentStudents();
                            studentsTable.updateStudents();
                        }
                    }

                    onDoubleClicked: {
                        studentLeaves();
                    }
                }
            }
        }

        TextField {
            id: searchField

            Layout.fillWidth: true

            onTextChanged: {
                studentsTable.updateStudentsList();
                presentStudentsTable.updatePresentStudentsList();
            }
        }
    }

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

    function studentMatches(student, filter) {
        var parts = filter.split(" ");

        for (var i = 0; i < parts.length; i++) {
            if (parts[i] !== '' && !studentMatchesSingle(student, parts[i])) {
                return false;
            }
        }

        return true;
    }

    function studentMatchesSingle(student, filter) {
        filter = filter.toLowerCase();

        return student["firstName"].toLowerCase().search(filter) !== -1
            || student["lastName"].toLowerCase().search(filter) !== -1
            || (student["cardId"] !== null && student["cardId"].toLowerCase().search(filter) !== -1)
            || (student["otherIds"] !== null && student["otherIds"].toLowerCase().search(filter) !== -1);
    }
}
