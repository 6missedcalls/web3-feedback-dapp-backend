const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await waveContract.deployed();

  console.log("Contract deployed to:", waveContract.address);
  console.log("Owner:", owner.address);

  // waveCount
  let waveTxn = await waveContract.wave('A message!');
  await waveTxn.wait(); // Wait for the transaction to be mined
  waveTxn = await waveContract.connect(randomPerson).wave('Another message!');
  await waveTxn.wait(); // Wait for the transaction to be mined
  let allWaves = await waveContract.getTotalWaves();
  console.log(allWaves);

  // likeCount
  let likeCount;
  let likeTxn = await waveContract.like();
  await likeTxn.wait();

  // comments
  let getComment;
  let setComment;
  setComment = await waveContract.setComment("Hello World");
  await setComment.wait(); 

  waveCount = await waveContract.getTotalWaves();
  likeCount = await waveContract.getTotalLikes();
  getComment = await waveContract.getComment();

  // get contract balance
  let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log(
    'Contract balance:',
    hre.ethers.utils.formatEther(contractBalance)
  );
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
}

runMain();