import { beforeEach, describe, expect, it } from "vitest";
import { Contract, ContractAbi, Web3 } from "web3";
import abi from "../InboxAbi.json";
import * as fs from "fs";
import * as path from "path";
import { ANVIL_ADDR, BYTECODE_PREFIX } from "../scripts/constants";

const byteCodePath: string = path.join(__dirname, "..", "InboxByteCode.bin");
const byteCode: string = fs.readFileSync(byteCodePath, "utf8");

const web3 = new Web3(new Web3.providers.HttpProvider(ANVIL_ADDR));

const contract = new web3.eth.Contract(abi);
contract.handleRevert = true;

let accounts: Array<string> = [];
let inbox: Contract<ContractAbi> | undefined;

describe("Inbox Contract", () => {
  const defaultMessage = "Hello, world!";

  beforeEach(async () => {
    accounts = await web3.eth.getAccounts();
    expect(accounts.length).toBeGreaterThan(0);

    const contractOwner = accounts[0];

    inbox = await contract
      .deploy({
        data: BYTECODE_PREFIX + byteCode,
        arguments: [defaultMessage],
      })
      .send({
        from: contractOwner,
        gas: "10000000",
      });
  });

  it("should deploy the contract correctly", () => {
    expect(inbox?.options.address).not.toBeUndefined();
  });

  it("should have a default message upon deployment", async () => {
    expect(inbox).not.toBeUndefined();

    const message = await inbox!.methods.message().call();
    expect(message).toBe(defaultMessage);
  });


    const message = await txn!.methods.message().call();
    expect(message).toBe(defaultMessage);
  });
});
