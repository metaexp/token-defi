const MetaEXP = artifacts.require('MetaEXP')

async function estimateGas(contract, ...params) {
  const estimation = await contract.new.estimateGas(...params)
  return { gas: estimation + 4500000 }
}

module.exports = async (deployer, network, accounts) => {
  await deployer.deploy(
    MetaEXP,
    '0xD99D1c33F9fC3444f8101754aBC46c52416550D1',
    accounts[7],
  )
}
