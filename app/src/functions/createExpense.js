const { TableClient } = require("@azure/data-tables");

function badRequest(message) {
  return { status: 400, jsonBody: { error: message } };
}

function ok(body) {
  return { status: 200, jsonBody: body };
}

function getTableClient() {
  const conn = process.env.AzureWebJobsStorage;
  const tableName = process.env.EXPENSES_TABLE_NAME || "expenses";
  if (!conn) throw new Error("Missing AzureWebJobsStorage");
  return TableClient.fromConnectionString(conn, tableName);
}

module.exports = (app) => {
  app.http("createExpense", {
    methods: ["POST"],
    authLevel: "anonymous",
    route: "expenses",
    handler: async (request) => {
      let payload;
      try {
        payload = await request.json();
      } catch {
        return badRequest("Invalid JSON body.");
      }

      const { date, category, description, amount } = payload || {};
      if (!date || !category || !description) return badRequest("date, category, description are required.");
      if (typeof amount !== "number" || Number.isNaN(amount)) return badRequest("amount must be a number.");

      const table = getTableClient();
      await table.createTable().catch(() => {}); // idempotent

      const now = new Date();
      const rowKey = `${now.getTime()}-${Math.random().toString(16).slice(2)}`;

      const entity = {
        partitionKey: "expenses",
        rowKey,
        date,
        category,
        description,
        amount
      };

      await table.createEntity(entity);

      return ok({ id: rowKey, ...entity });
    }
  });
};
