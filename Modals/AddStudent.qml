import QtQuick 2.1
import QtQuick.Window 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import "../Storage/storage.js" as Storage
import "AddStudent.js" as Student

Window {
    id: addStudentWindow

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
                    lastName.focus = true;
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
                    cardId.focus = true;
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
                    if (Student.notEmpty()) {
                        Student.add();
                        addStudentWindow.visible = false
                    }
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight | Qt.AlignBottom

            Button {
                text: "Anuluj"

                onClicked: {
                    addStudentWindow.visible = false
                }
            }
            Button {
                id: btnAdd

                text: "Dodaj"

                enabled: false

                onClicked: {
                    Student.add();
                    addStudentWindow.visible = false;
                }
            }
        }
    }

    onVisibleChanged: {
        firstName.focus = true;

        firstName.text = "";
        lastName.text = "";
        cardId.text = "";

        //Student.setInput(searchField.text);
        //searchField.text = "";
    }
}
