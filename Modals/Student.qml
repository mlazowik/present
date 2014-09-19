import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

import "../Storage/storage.js" as Storage
import "Student.js" as Student

Window {
    id: studentWindow

    property int studentId: -1;

    flags: Qt.Dialog

    minimumWidth: 300
    maximumWidth: 300
    minimumHeight: 110
    maximumHeight: 110

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop

            TextField {
                id: firstName

                Layout.fillWidth: true

                focus: true
                placeholderText: "Imię"

                onTextChanged: {
                    btnAdd.enabled = Student.notEmpty();
                }

                Keys.onReturnPressed: {
                    saveIfNotEmpty();
                }
            }

            TextField {
                id: lastName

                Layout.fillWidth: true

                placeholderText: "Nazwisko"

                onTextChanged: {
                    btnAdd.enabled = Student.notEmpty();
                }

                Keys.onReturnPressed: {
                    saveIfNotEmpty();
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            TextField {
                id: cardId

                Layout.fillWidth: true

                placeholderText: "Numer karty bibliotecznej"

                onTextChanged: {
                    btnAdd.enabled = Student.notEmpty();
                }

                Keys.onReturnPressed: {
                    saveIfNotEmpty();
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight | Qt.AlignBottom

            Button {
                text: "Anuluj"

                onClicked: {
                    studentWindow.visible = false
                }
            }
            Button {
                id: btnAdd

                text: "Zapisz"

                enabled: false

                onClicked: {
                    saveIfNotEmpty();
                }
            }
        }
    }

    onVisibleChanged: {
        firstName.focus = true;

        firstName.text = "";
        lastName.text = "";
        cardId.text = "";

        studentId = -1;

        //Student.setInput(searchField.text);
        //searchField.text = "";
    }

    function setData(student) {
        studentId = student.studentId;
        firstName.text = student.firstName;
        lastName.text = student.lastName;
        cardId.text = student.cardId;
    }

    function saveIfNotEmpty() {
        if (Student.notEmpty()) {
            Student.save(studentId);
            studentWindow.visible = false;
        }
    }
}
