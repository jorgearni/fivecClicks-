const Word = require("../models/word.model.js");

exports.create = (req, res) => {
  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }

  const word = new Word({
    term: req.body.term,
    clicks: req.body.clicks
  });

  Word.create(word, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "error creating new word."
      });
    else res.send(data);
  });
};

exports.findAll = (req, res) => {
  Word.getAll((err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "error retrieving words."
      });
    else res.send(data);
  });
};

// Find a single Word with a wordId
exports.findOne = (req, res) => {
  Word.findById(req.params.idword, (err, data) => {
    if (err) {
      if (err.kind === "not_found") {
        res.status(404).send({
          message: `Not found Word with id ${req.params.idword}.`
        });
      } else {
        res.status(500).send({
          message: "error with id: " + req.params.idword
        });
      }
    } else res.send(data);
  });
};


exports.update = (req, res) => {
  if (!req.body) {
    res.status(400).send({
      message: " empty content!"
    });
  }

  console.log(req.body);

  Word.updateById(
    req.params.idword,
    new Word(req.body),
    (err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found Word with id ${req.params.idword}.`
          });
        } else {
          res.status(500).send({
            message: "Error updating Word id " + req.params.idword
          });
        }
      } else res.send(data);
    }
  );
};


exports.delete = (req, res) => {
  Word.remove(req.params.idword, (err, data) => {
    if (err) {
      if (err.kind === "not_found") {
        res.status(404).send({
          message: `word not found id ${req.params.idword}.`
        });
      } else {
        res.status(500).send({
          message: "could not delete word " + req.params.idword
        });
      }
    } else res.send({ message: `word deleted` });
  });
};


exports.deleteAll = (req, res) => {
  Word.removeAll((err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Error."
      });
    else res.send({ message: `Deleted` });
  });
};
