import ganache from "ganache";
import { beforeEach, describe, expect, it } from "vitest";
import type { ContractAbi, Contract } from "web3";
import { Web3 } from "web3";
import { bytecode, abi } from "../scripts/compile";

const web3 = new Web3(ganache.provider());
let accounts: Array<string> = [];
let contract: Contract<ContractAbi>;

describe("Inbox Contract", () => {
  beforeEach(async () => {
    accounts = await web3.eth.getAccounts();
    expect(accounts.length).toBeGreaterThan(0);

    const contractOwner = accounts[0];

    // Use one of the returned accounts to deploy our contract
    contract = await new web3.eth.Contract(abi)
      .deploy({ data: bytecode, arguments: ["Hello, world!"] })
      .send({
        from: contractOwner,
        gas: "1000000",
      });
  });

  it("should deploy the contract correclty", () => {
    console.log(contract);
  });
});
