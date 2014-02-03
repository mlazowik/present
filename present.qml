import QtQuick.LocalStorage 2.0
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    title: "Obecność"

    property var db: null
    property var sqliteVersion: null
    property string scheme_students:
        "CREATE TABLE IF NOT EXISTS students(
            id              INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            first_name      TEXT NOT NULL,
            last_name       TEXT NOT NULL,
            card_id         TEXT,
            other_ids       TEXT
        );"
    property string scheme_log:
        "CREATE TABLE IF NOT EXISTS log(
            id              INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            timestamp       DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
            student_id      INTEGER NOT NULL,
            action          INTEGER NOT NULL,   -- 1 - enter, -1 - leave
            FOREIGN KEY(student_id) REFERENCES students(id)
        );"

    function openDB() {
        if (db !== null) {
            return;
        }

        try {
            db = LocalStorage.openDatabaseSync(
                "present",
                "0.1",
                "App that enables logging of presence of pupils in library",
                100000
            );

            console.log("Database created.");
        } catch (err) {
            console.log("Error creating database: " + err);
        }

        try {
            db.transaction(
                function(tx) {
                    sqliteVersion = tx.executeSql('SELECT sqlite_version();');
                    sqliteVersion = sqliteVersion.rows.item(0)["sqlite_version()"];

                    console.log("sqlite version: " + sqliteVersion);
                }
            )
        } catch (err) {
            console.log("Error getting sqlite version: " + err);
        };

        try {
            db.transaction(
                function(tx) {
                    tx.executeSql('PRAGMA foreign_keys = ON;');

                    console.log("Foreign keys enabled")
                }
            )
        } catch (err) {
            console.log("Error enabling foreign keys: " + err);
        };

        try {
            db.transaction(
                function(tx) {
                    tx.executeSql("DROP TABLE IF EXISTS students;");
                    tx.executeSql("DROP TABLE IF EXISTS log;");

                    tx.executeSql(scheme_students);
                    tx.executeSql(scheme_log);

                    var tables = tx.executeSql("SELECT * FROM sqlite_master WHERE type='table';");

                    for (var i = 0; i < tables.rows.length; i++) {
                        console.log(JSON.stringify(tables.rows.item(i)));
                    }
                }
            )

            console.log("Tables created.");
        } catch (err) {
            console.log("Error creating table in database: " + err);
        };
    }

    Component.onCompleted: openDB()

    width: 500
    height: 400

    minimumHeight: 200
    minimumWidth: 400

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        spacing: 10

        TableView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            /*function fetchData() {
                try {
                    db.transaction(
                        function(tx) {
                            var tables = tx.executeSql("SELECT * FROM sqlite_master WHERE type='table';");

                            for (var i = 0; i < tables.rows.length; i++) {
                                console.log(JSON.stringify(tables.rows.item(i)));
                            }
                        }
                    )

                    console.log("Tables created.");
                } catch (err) {
                    console.log("Error creating table in database: " + err);
                };
            }*/

            TableViewColumn {
                title: "Imię"

                width: 100
            }

            TableViewColumn {
                title: "Nazwisko"

                width: 150
            }

            TableViewColumn {
                title: "Identyfikator"
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
            }
        }
    }
}
