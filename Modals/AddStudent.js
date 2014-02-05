.import "../Storage/storage.js" as Storage

function add() {
    if (notEmpty() === false) {
        console.log("At least one field is empty. This shouldn't happen.")
        return;
    }

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

function notEmpty() {
    return (
        firstName.text !== ""
        && lastName.text !== ""
        && cardId.text !== ""
    );
}

function setInput(input) {
    var parts = input.split(" ");

    var first = "";
    var last = "";

    if (parts.length > 1) {
        for (var i = 0; i < parts.length - 1; i++) {
            if (i !== 0) {
                first += " ";
            }

            first += parts[i];
        }

        last = parts[parts.length-1];
    } else {
        first = parts[0];
    }

    firstName.text = first;
    lastName.text = last;

    if (first !== "") {
        if (last !== "") {
            cardId.focus = true;
        } else {
            lastName.focus = true;
        }
    }
}
