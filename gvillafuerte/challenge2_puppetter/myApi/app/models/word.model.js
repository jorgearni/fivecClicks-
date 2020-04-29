const sql = require("./dbproperties.js");


const Word = function(word) {
  this.term = word.term;
};

Word.create = (newWord, result) => {
  sql.query("INSERT INTO words SET ?", newWord, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    console.log("created word: ", { id: res.insertId, ...newWord });
    result(null, { id: res.insertId, ...newWord });
  });
};

Word.findById = (idword, result) => {
  sql.query(`SELECT * FROM words WHERE idword = ${idword}`, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      console.log("found word: ", res[0]);
      result(null, res[0]);
      return;
    }


    result({ kind: "not_found" }, null);
  });
};

Word.getAll = result => {
  sql.query("SELECT * FROM words", (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    console.log("words: ", res);
    result(null, res);
  });
};

Word.updateById = (idword, word, result) => {
  sql.query(
    "UPDATE words SET term = ?, clicks = ? WHERE idword = ?",
    [word.term, word.clicks, idword],
    (err, res) => {
      if (err) {
        console.log("error: ", err);
        result(null, err);
        return;
      }

      if (res.affectedRows == 0) {
  
        result({ kind: "not_found" }, null);
        return;
      }

      console.log("updated word: ", { idword: idword, ...word });
      result(null, { idword: idword, ...word });
    }
  );
};

Word.remove = (idword, result) => {
  sql.query("DELETE FROM words WHERE idword = ?", idword, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    if (res.affectedRows == 0) {

      result({ kind: "not_found" }, null);
      return;
    }

    console.log("deleted word with id: ", idword);
    result(null, res);
  });
};

Word.removeAll = result => {
  sql.query("DELETE FROM words", (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }

    console.log(`deleted ${res.affectedRows} words`);
    result(null, res);
  });
};

module.exports = Word;
