const MetaEXP = artifacts.require('MetaEXP')

contract('MetaExp Defi', async (accounts) => {
  it('send', async () => {
    let metaEXP = await MetaEXP.deployed()

    let total = web3.utils.toWei((1000 * 10 ** 10).toString(), 'wei')
    let fee = web3.utils.toWei(((1000 * 10 ** 10 * 2) / 100).toString(), 'wei')
    await metaEXP.transfer(accounts[1], total, { from: accounts[0] })

    await metaEXP.transfer(accounts[2], total, { from: accounts[1] })
    let balanceOfFinalReceiver2 = await metaEXP.balanceOf(accounts[2])
    assert.equal(
      parseInt(balanceOfFinalReceiver2.toString()),
      parseInt(total.toString()) - parseInt(fee.toString()),
    )

    const balanceOfDevWallet = await metaEXP.balanceOf(accounts[7])
    assert.equal(
      parseInt(balanceOfFinalReceiver2.toString()),
      parseInt(total.toString()) - parseInt(fee.toString()),
    )

    assert.equal(
      parseInt(balanceOfDevWallet.toString()),
      parseInt(fee.toString()),
    )

    // console.log(total.toString())
    // console.log(balanceOfFinalReceiver.toString())
  })
})
