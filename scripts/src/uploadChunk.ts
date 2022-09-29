import { createActor } from "candb-client-typescript/dist/createActor";
import { _SERVICE as RBTExp } from "../declarations/rbtexp/rbtexp.did"
import { idlFactory } from "../declarations/rbtexp";

import { readFileSync, writeFile } from 'fs';
import { resolve } from "path";
import { stringify } from "csv-stringify";

type DataRow = {
  count: number;
  cycles: number;
  heapSizeMB: number;
}

const rows: DataRow[] = []

async function go() {
  const host = "http://127.0.0.1:8000";
  const canisterId = "ryjl3-tyaaa-aaaaa-aaaba-cai";
  const actor = createActor<RBTExp>({
    IDL: idlFactory,
    canisterId,
    agentOptions: {
      host,
    }
  });

  console.log("actor", actor);

  // I found the limit get to with a 1MB chunk is 1587
  for (let i=1; i<1588; i+=1) {
    const fileName = `new_chunk_1`; // upload the same 1MB chunk
    const key = i;
    let buffer = loadFile(fileName)
    try {
      let result = await actor.uploadChunk(key.toString(), buffer)
      let metrics = await actor.getCanisterMetrics();
      rows.push({
        count: key,
        heapSizeMB: Number(metrics.heapSize),
        cycles: Number(metrics.cycles)
      });

      console.log("uploaded chunk #", i)
      console.log(`key uploaded=${key}, result=${result}`)
    } catch (err) {
      console.error(`error processing file: ${fileName}`);
      console.error(err);
    }
  }

  stringify(rows, {
    header: true,
    columns: [ 
      { key: "count", header: "Round/Count"},
      { key: "heapSizeMB", header: "Heap Size in MB"},
      { key: "cycles", header: "Cycles Remaining"},
    ]
  }, function(err, data) {
    writeFile("rows.csv", data, "utf-8", function(err) {
      if (err) {
        console.error("some error occurred writing files")
        console.log("data", data)
      } else {
        console.log("successfully wrote all data to rows.csv")
      }
    })
  })
}

function loadFile(fileName: string) {
  const filePath = resolve(__dirname, "../", fileName)
  console.log("resolved filePath", filePath)
  const buffer = readFileSync(filePath)
  return [...new Uint8Array(buffer)];
}

go();