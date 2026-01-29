const { TableClient } = require("@azure/data-tables");

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
  app.http("getExpenses", {
    methods: ["GET"],
    authLevel: "anonymous",
    route: "expenses",
    handler: async (request) => {
      const table = getTableClient();
      await table.createTable().catch(() => {});

      const items = [];
      const iter = table.listEntities({
        queryOptions: { filter: "PartitionKey eq 'expenses'" }
      });

      for await (const e of iter) {
        items.push({
          id: e.rowKey,
          date: e.date,
          category: e.category,
          description: e.description,
          amount: e.amount
        });
      }

      // newest first (simple)
      items.sort((a, b) => (b.id > a.id ? 1 : -1));

      return ok({ count: items.length, items });
    }
  });
};
