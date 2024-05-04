import { Web3 } from "web3";
import { ENV } from "./constants";
import { BYTECODE_PREFIX } from "./constants";
import abi from "../InboxAbi.json";
import * as path from "path";
import * as fs from "fs";
import dotenv from "dotenv";

const main = async () => {
  const network = process.env[ENV.ETHEREUM_NETWORK] ?? "";
  const infuraAPIKey = process.env[ENV.INFURA_API_KEY] ?? "";
  const signerPrivKey = process.env[ENV.SIGNER_PRIVATE_KEY] ?? "";

  const byteCodePath: string = path.join(__dirname, "..", "InboxByteCode.bin");
  const byteCode: string = fs.readFileSync(byteCodePath, "utf8");

  const web3 = new Web3(
    new Web3.providers.HttpProvider(
      `https://${network}.infura.io/v3/${infuraAPIKey}`,
    ),
  );

  const signer = web3.eth.accounts.privateKeyToAccount(
    BYTECODE_PREFIX + signerPrivKey,
  );

  web3.eth.accounts.wallet.add(signer);

  const contract = new web3.eth.Contract(abi);

  const defaultMessage = "Hello, world from rajil!";
  const deployer = contract.deploy({
    data: byteCode,
    arguments: [defaultMessage],
  });

  const deployedContract = await deployer
    .send({
      from: signer.address,
      gas: (await deployer.estimateGas()).toString(),
    })
    .once("transactionHash", (txnHash) => {
      console.log("Mining deployment transaction...");
      console.log(`Visit: https://${network}.etherscan.io/tx/${txnHash}`);
    });

  console.log(`Contract deployed at ${deployedContract.options.address}`);
  console.log(
    `Add \`DEMO_CONTRACT=${deployedContract.options.address}\` to the .env file to store the contract address`,
  );
};

dotenv.config();

main()
  .then(() => {
    console.log("Done!");
  })
  .catch((err) => {
    console.log(err);
  });
