export const BYTECODE_PREFIX = "0x";
// run `anvil` from `foundry` at port 8545
export const ANVIL_ADDR = "http://localhost:8545";

export const ENV = {
  ETHEREUM_NETWORK: "ETHEREUM_NETWORK",
  INFURA_API_KEY: "INFURA_API_KEY",
  SIGNER_PRIVATE_KEY: "SIGNER_PRIVATE_KEY",
  DEMO_CONTRACT_ADDR: "DEMO_CONTRACT_ADDR",
} as const;
