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

function checkEmpty() {
    return (
        firstName.text !== ""
        && lastName.text !== ""
        && cardId.text !== ""
    );
}
