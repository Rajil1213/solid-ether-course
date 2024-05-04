import * as path from "path";
import * as fs from "fs";
// solc does not have types
// eslint-disable-next-line @typescript-eslint/no-var-requires
const solc = require("solc");

const contract = "Inbox";
const contractFilename = "inbox.sol";

const contractPath = path.resolve(
  __dirname,
  "..",
  "contracts",
  contractFilename,
);

console.log("Contract Path:\n", contractPath);

const content = fs.readFileSync(contractPath, "utf-8");
console.log("Content:\n", content);

const input = {
  language: "Solidity",
  sources: {
    [contractFilename]: {
      content,
    },
  },
  settings: {
    outputSelection: {
      [contractFilename]: {
        [contract]: ["abi", "evm.bytecode.object"],
      },
    },
  },
};

const compiled = JSON.parse(solc.compile(JSON.stringify(input)));
console.log(compiled);

const bytecode: string =
  compiled.contracts[contractFilename][contract].evm.bytecode.object;
const byteCodePath: string = path.join(__dirname, "..", "InboxByteCode.bin");
fs.writeFileSync(byteCodePath, bytecode);

const abi: never[] = compiled.contracts[contractFilename][contract].abi;
const abiPath: string = path.join(__dirname, "..", "InboxAbi.json");
fs.writeFileSync(abiPath, JSON.stringify(abi, null, "  "));
