.import "../Storage/storage.js" as Storage

function add() {
    var res = Storage.addStudent(
        firstName.text,
        lastName.text,
        cardId.text
    );

    if (res !== 0) {
        console.log("Error adding student: " + res);
    } else {
        mainTable.updateStudents();
    }
}

/*
function add(db) {
    try {
        db.transaction(
            function(tx) {
                tx.executeSql(
                    "INSERT INTO students(first_name, last_name, card_id) \
                    VALUES(" +
                    firstName + ", " +
                    lastName + ", " +
                    cardId +
                    ")"
                );
            }
        )
    } catch (err) {
        console.log("Error adding student: " + err);

        return -1;
    };

    return db;
}
*/
