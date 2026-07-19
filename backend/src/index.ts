import express from "express";

const app = express();



app.listen("3001", () => {
  console.log("Listening on port:3001");
//   if (process.env.NODE_ENV === "production") {
//     keepAliveCron.start();
//   }
});