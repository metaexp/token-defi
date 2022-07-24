// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "@openzeppelin/contracts/access/AccessControl.sol";

contract MetaEXP is ERC20, AccessControl {
    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) private _isExcluded;
    address[] private _excluded;
    using SafeMath for uint256;

    uint256 public _devFee = 2;
    uint256 private _previousDevFee = _devFee;
    address public devWallet = 0xa0a4Deb109B12912D84f598468b434618503d3D5;
    address public feeWallet = 0xa0a4Deb109B12912D84f598468b434618503d3D5;
    address manager = 0x0A71A2F077Cd652305Df492138c506AAa2fd31E3;

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    constructor(address _devWallet, address _feeWallet)
        ERC20("MetaEXP", "MXP")
    {
        devWallet = _devWallet;
        feeWallet = _feeWallet;
        _isExcludedFromFee[manager] = true;
        _isExcludedFromFee[devWallet] = true;
        _isExcludedFromFee[address(this)] = true;
        _setupRole(MANAGER_ROLE, manager);
        _setupRole(MANAGER_ROLE, _devWallet);
        _mint(devWallet, 337600000000 * 10**10);
    }

    function decimals() public view virtual override returns (uint8) {
        return 10;
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _tokenTransfer(msg.sender, recipient, amount);
        return true;
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) private {
        if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
            removeAllFee();
        }
        uint256 devAmt = amount.mul(_devFee).div(100);
        uint256 total = amount.sub(devAmt);
        _transfer(sender, feeWallet, devAmt);
        _transfer(sender, recipient, total);
        if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
            restoreAllFee();
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _tokenTransfer(sender, recipient, amount);
        return true;
    }

    function removeAllFee() private {
        if (_devFee == 0) {
            return;
        }
        _previousDevFee = _devFee;
        _devFee = 0;
    }

    function restoreAllFee() private {
        _devFee = _previousDevFee;
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function excludeFromFee(address account) public onlyRole(MANAGER_ROLE) {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) public onlyRole(MANAGER_ROLE) {
        _isExcludedFromFee[account] = false;
    }
}
