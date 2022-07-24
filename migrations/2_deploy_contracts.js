const MetaEXP = artifacts.require('MetaEXP')



module.exports = async (deployer, network, accounts) => {
  await deployer.deploy(
    MetaEXP,
    '0xa0a4Deb109B12912D84f598468b434618503d3D5',
    '0xa0a4Deb109B12912D84f598468b434618503d3D5',
  )
}
