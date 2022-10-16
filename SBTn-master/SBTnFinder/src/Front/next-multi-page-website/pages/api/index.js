var Web3 = require('web3');

var rpcurlgoarb = "https://goerli-rollup.arbitrum.io/rpc";

const contract_abi1 = require("./metadata/contractABI.json");
var SmartContractAddress1 = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
var SmartContractABI1 = contract_abi1;

export async function searching (addressnft) {

  var provider = rpcurlgoarb;
  var web3 = new Web3(provider);
  var myContract = new web3.eth.Contract(SmartContractABI1, SmartContractAddress1);

  var func = await myContract.methods.search(addressnft).encodeABI();
    
  return func;
}

export { search };