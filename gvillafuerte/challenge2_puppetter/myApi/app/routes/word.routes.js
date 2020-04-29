module.exports = app => {
  const words = require("../controllers/word.controller.js");

  app.post("/words", words.create);


  app.get("/words", words.findAll);


  app.get("/words/:idword", words.findOne);

  app.put("/words/:idword", words.update);
  app.delete("/words/:idword", words.delete);


  app.delete("/words", words.deleteAll);
};
