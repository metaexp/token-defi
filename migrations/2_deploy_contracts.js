const MetaEXP = artifacts.require('MetaEXP')

async function estimateGas(contract, ...params) {
  const estimation = await contract.new.estimateGas(...params)
  return { gas: estimation + 4500000 }
}

module.exports = async (deployer, network, accounts) => {
  await deployer.deploy(
    MetaEXP,
    accounts[7],
    accounts[8]
  )
}
