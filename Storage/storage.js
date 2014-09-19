.import QtQuick.LocalStorage 2.0 as Sql

var scheme_students =
    "CREATE TABLE IF NOT EXISTS students( \
        studentId       INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, \
        firstName       TEXT NOT NULL, \
        lastName        TEXT NOT NULL, \
        cardId          TEXT, \
        otherIds        TEXT \
    );"
var scheme_log =
    "CREATE TABLE IF NOT EXISTS log( \
        id              INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, \
        timestamp       DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL, \
        studentId       INTEGER NOT NULL, \
        action          INTEGER NOT NULL, \
        FOREIGN KEY(studentId) REFERENCES students(studentId) \
    );"

function getDatabase() {
    var db;

    try {
        db = Sql.LocalStorage.openDatabaseSync(
            "present",
            "0.1",
            "App that enables logging of presence of students in library",
            100000
        );
    } catch (err) {
        console.log("Error creating database: " + err);
    }

    return db;
}

function getDatabaseVersion() {
    var sqliteVersion;
    var db = getDatabase();

    try {
        db.transaction(
            function(tx) {
                sqliteVersion = tx.executeSql('SELECT sqlite_version();');
                sqliteVersion = sqliteVersion.rows.item(0)["sqlite_version()"];
            }
        )
    } catch (err) {
        console.log("Error getting sqlite version: " + err);
    };

    return sqliteVersion;
}

function initalize() {
    var db = getDatabase();

    try {
        db.transaction(
            function(tx) {
                tx.executeSql('PRAGMA foreign_keys = ON;');
            }
        )
    } catch (err) {
        console.log("Error enabling foreign keys: " + err);
    };

    try {
        db.transaction(
            function(tx) {
                tx.executeSql(scheme_students);
                tx.executeSql(scheme_log);
            }
        )
    } catch (err) {
        console.log("Error creating table in database: " + err);
    };
}

function addStudent(firstName, lastName, cardId) {
    var db = getDatabase();

    try {
        db.transaction(
            function(tx) {
                var res = tx.executeSql(
                    "INSERT INTO students(firstName, lastName, cardId) VALUES(?, ?, ?)",
                    [firstName, lastName, cardId]
                );
            }
        )
    } catch (err) {
        console.log("Error adding student: " + err);
    };

    return 0;
}

function editStudent(studentId, firstName, lastName, cardId) {
    var db = getDatabase();

    try {
        db.transaction(
            function(tx) {
                var res = tx.executeSql(
                    "UPDATE students " +
                    "SET firstName = ?, lastName = ?, cardId = ? " +
                    "WHERE studentId = ?",
                    [firstName, lastName, cardId, studentId]
                );
            }
        )
    } catch (err) {
        console.log("Error editing student: " + err);
    };
}

function getStudents() {
    var db = getDatabase();
    var students = [];
    var presentStudents = [];
    var isPresent = [];
    var j = 0;

    presentStudents = getPresentStudents();

    for (var i = 0; i < presentStudents.length; i++) {
        isPresent[presentStudents[i]["studentId"]] = true;
    }

    try {
        db.transaction(
            function(tx) {
                var result = tx.executeSql("SELECT * FROM students");

                for (var i = 0; i < result.rows.length; i++) {
                    if (isPresent[result.rows.item(i)["studentId"]] !== true) {
                        students[j] = result.rows.item(i);
                        j++;
                    }
                }
            }
        )
    } catch (err) {
        console.log("Error getting students: " + err);
    };

    return students;
}

function getPresentStudents() {
    var db = getDatabase();
    var students = [];
    var j = 0;

    try {
        db.transaction(
            function(tx) {
                var res = tx.executeSql(
                    "SELECT * FROM students AS s " +
                    "INNER JOIN (SELECT * FROM (SELECT * FROM log ORDER BY timestamp) GROUP BY studentId) AS p " +
                    "ON s.studentId = p.studentId"
                );

                for (var i = 0; i < res.rows.length; i++) {
                    if (res.rows.item(i)['action'] === 1) {
                        students[j] = res.rows.item(i);
                        j++;
                    }
                }
            }
        )
    } catch (err) {
        console.log("Error getting present students: " + err);
    };

    return students;
}

function logStudentAction(studentId, action) {
    var db = getDatabase();

    try {
        db.transaction(
            function(tx) {
                var res = tx.executeSql(
                    "INSERT INTO log(studentId, action) VALUES(?, ?)",
                    [studentId, action]
                );
            }
        )
    } catch (err) {
        console.log("Error logging student action: " + err);
    };
}
