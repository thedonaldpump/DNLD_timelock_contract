// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import './IBEP20.sol';

contract TimeLock {
    
    IBEP20 public _token;
    
    address public _beneficiary;
    
    uint256 public _releaseTime;
    
    constructor(IBEP20 tokenAddress, address beneficiaryAddress, uint256 releaseTimeValue) {
        // set the internal variables using the passed parameters
        
        _token = tokenAddress;
        _beneficiary = beneficiaryAddress;
        _releaseTime = releaseTimeValue;
    }
    
    function token() public view returns(IBEP20) {
        // public view function that returns the address of the token
        return _token;
    }
    
    function beneficiary() public view returns(address) {
        // public view function that returns the address of the contract beneficiary
        return _beneficiary;
    }
    
    function releaseTime() public view returns(uint256) {
        // public view function that returns the contract's release time
        return _releaseTime;    
    }
    
    function blockTime() public view returns(uint) {
        // public view function that returns the block timestamp
        return block.timestamp;
    }
    
    function lockedBalance() public view returns(uint) {
        // public view balance locked in timelock
        uint256 balance = _token.balanceOf(address(this));
        
        return balance;
    }
    
    function timeLeft() public view returns(uint256) {
        // public view function that returns how much time is time is left on the timelock
        if(block.timestamp < _releaseTime) {
            return _releaseTime - block.timestamp;
        }
        
        return 0;
    }
    
    function lockStatus() public view returns(bool) {
        // public view function that returns true or false depending on if it's time 
        // to release the contract or not.
        return block.timestamp >= _releaseTime;
    }
    
    function release() public returns(bool) {
        // the core function responsible for transferring the funds to the beneficiary
        require(block.timestamp >= _releaseTime, "Release time has not arrived yet, Cannot release tokens.");
        
        uint256 balance = _token.balanceOf(address(this));
        
        require(balance > 0, "No tokens in Timelock Contract Balance.");
        
        _token.transfer(_beneficiary, balance);
        
        return true;
    }
    
    
}
