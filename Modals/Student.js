.import "../Storage/storage.js" as Storage

function save(id) {
    if (notEmpty() === false) {
        console.log("At least one field is empty. This shouldn't happen.")
        return;
    }

    var res = 0;

    if (id === -1) {
        Storage.addStudent(
            firstName.text,
            lastName.text,
            cardId.text
        );
    } else {
        Storage.editStudent(
            id,
            firstName.text,
            lastName.text,
            cardId.text
        );
    }

    studentsTable.updateStudents();
    presentStudentsTable.updatePresentStudents();
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
