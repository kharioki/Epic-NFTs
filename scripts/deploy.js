const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log('Contract deployed to ', nftContract.address);

  // make nft function
  let txn = await nftContract.makeAnEpicNFT();
  // wait for nft to be mined
  await txn.wait();
  console.log('minted nft #1');

  // mint another
  txn = await nftContract.makeAnEpicNFT();
  // wait for nft to be mined
  await txn.wait();
  console.log('minted nft #2');

};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (e) {
    console.error(e);
    process.exit(1);
  }
};

runMain();
