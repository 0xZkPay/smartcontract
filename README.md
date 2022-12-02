# Smart Contract

Smart Contract for tracking zkPay users loyalty points using NFT

Deployed on:

1. Polygon Mumbai Network - 0x19064239B6592F01deC4EC6C9E5976136d51c33B - https://thegraph.com/hosted-service/subgraph/0xzkpay/zkpay-mumbai
2. 

## Installation
1. Clone the repo by using 
```shell
git clone https://github.com/ZkPay/smartcontract.git
```
2. Install the dependencies by using the command `npm install`.
   This way your environment will be reproducible, and you will avoid future version conflicts.

## Configuration
1. Rename the file `.env.example` to `.env`
2. Update the values of the given parameters:
```shell
ETHERSCAN_API_KEY=
SEPOLIA_RPC_URL=
WALLABY_RPC_URL=
MATICMUM_RPC_URL=
POLYGON_RPC_URL=
MNEMONIC=
```
3. `ETHERSCAN_API_KEY` is required to verify the contract deployed on the blockchain network. Since we're using the Polygon Testnet, We need to get the API key from ```https://polygonscan.com```

4. Next we need to update the RPC URL based on the network of our choice. Since we have chosen the Polygon Testnet, we need to provide `MATICMUM_RPC_URL` from 
the `https://alchemy.com` or `https://infura.io`. In case if we choose, Sepolia or Wallaby, we need to update their respective RPC URLs. 

5. Lastly we need to provide the wallet from which the gas will be deducted in order to deploy the smart contract. We provide the `MNEMONIC` i.e., The seed words from the ETH wallet/metamask to pay for the transaction. Ensure that there are enough funds in the wallet to pay for the transaction.

## Compiling the contract
Next, if you take a look at `contracts/`, you should be able to find `ZkPay.sol`

Compile the smart contract by using 
```shell
npx hardhat compile
```

## Testing the contract
This project has tests that uses `@openzeppelin/test-helpers`. If we take a look at `test/`, you should be able to find `test.js`.

To run the tests, we can use command:
```shell
npx hardhat test
```

## Deploying the contract
Next, to deploy the contract we will use a Hardhat script. Inside `scripts/` we use `deploy.js` and run it with 
```shell
npx hardhat run --network maticmum scripts/deploy.js
```
> `ZkPay Deployed to: 0x19064239B6592F01deC4EC6C9E5976136d51c33B`

## Etherscan verification

To try out Etherscan verification, we need to deploy a contract to an Ethereum network that's supported by Etherscan, such as `Polygon Testnet - maticmum`.

Then, copy the deployment address and paste it in to replace `DEPLOYED_CONTRACT_ADDRESS` in this command:

```shell
npx hardhat verify --network maticmum --constructor-args ZkPayArguments.js DEPLOYED_CONTRACT_ADDRESS
```
where `ZkPayArguments.js` is a javascript module that exports the argument list.

> `https://mumbai.polygonscan.com/address/0x19064239B6592F01deC4EC6C9E5976136d51c33B#code`

Finally, visit the contract address on the Blockchain Explorer (PolygonScan) and interact with the smart contract at section `Read Contract` and `Write Contract`
