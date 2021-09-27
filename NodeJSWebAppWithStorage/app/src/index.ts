import express from "express"
import dotenv from "dotenv";

import { DefaultAzureCredential } from "@azure/identity";
import { BlobServiceClient } from "@azure/storage-blob";

if (process.env.NODE_ENV !== "production") {
  dotenv.config();
}

const credential = new DefaultAzureCredential();
const serviceClient = new BlobServiceClient(process.env.storageacc__Blob__serviceUri!, credential)

const app = express();

app.get("/", async (_, res) => {
  res.status(200);
  res.header("Content-type: text/plain");

  const containerClient = serviceClient.getContainerClient("uploads");
  await containerClient.createIfNotExists();
  res.write(`Created: ${containerClient.url}\n`)
  res.end();
});

const port = process.env.PORT || 3000

app.listen(port, () => {
  console.log(`Started, listening on port ${port}`);
});