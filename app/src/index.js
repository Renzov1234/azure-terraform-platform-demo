const { app } = require("@azure/functions");

require("./functions/createExpense")(app);
require("./functions/getExpenses")(app);
