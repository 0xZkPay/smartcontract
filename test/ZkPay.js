const { time, loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

const ZkPay = artifacts.require("ZkPay");

let accounts;
let zkPay;
let owner;

describe("ZkPay", function () {

  before(async function() {
		accounts = await web3.eth.getAccounts();
		owner = accounts[0];
		zkPay = await ZkPay.new("ZkPay", "ZKPAY");
	});

  describe("Deployment", function () {
    it("Should return the right name and symbol of the token once ZkPay is deployed", async function() {
      assert.equal(await zkPay.name(), "ZkPay");
      assert.equal(await zkPay.symbol(), "ZKPAY");
    });
  });

});
