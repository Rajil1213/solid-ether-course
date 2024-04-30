import * as path from "path";
import * as fs from "fs";
// solc does not have types
const solc = require("solc");

import type { ContractAbi } from "web3";
import { BYTECODE_PREFIX } from "./constants";

const contract = "Inbox";
const inboxPath = path.resolve(__dirname, "..", "contracts", `${contract}.sol`);
console.log("Contract Path:\n", inboxPath);

const content = fs.readFileSync(inboxPath, "utf-8");
console.log("Content:\n", content);

const inbox = "inbox.sol";
const input = {
  language: "Solidity",
  sources: {
    [inbox]: {
      content,
    },
  },
  settings: {
    outputSelection: {
      [inbox]: {
        [contract]: ["abi", "evm.bytecode.object"],
      },
    },
  },
};

const compiled = JSON.parse(solc.compile(JSON.stringify(input))).contracts[
  "inbox.sol"
].Inbox;

export const abi: ContractAbi = compiled.abi;
export const bytecode: string = BYTECODE_PREFIX + compiled.evm.bytecode.object;
