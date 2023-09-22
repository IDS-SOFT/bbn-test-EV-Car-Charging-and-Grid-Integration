// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract EVCharging {
    // Define variables
    address public owner;
    uint public chargingFee;
    uint public chargingTime;
    uint public kWh;
    uint public totalCost;
    bool public isCharging;

    // Define events
    event ChargingStarted(address indexed user, uint indexed startTime);
    event ChargingStopped(address indexed user, uint indexed stopTime, uint indexed cost);

    // Constructor function
    constructor() {
        owner = msg.sender;
        chargingFee = 0.1 ether;
        chargingTime = 0;
        kWh = 0;
        totalCost = 0;
        isCharging = false;
    }

    // Function to start charging
    function startCharging() public payable {
        require(msg.value >= chargingFee, "Insufficient funds");
        require(!isCharging, "Charging already in progress");
        isCharging = true;
        emit ChargingStarted(msg.sender, block.timestamp);
    }

    // Function to stop charging
    function stopCharging(uint _kWh) public {
        require(isCharging, "No charging in progress");
        isCharging = false;
        kWh = _kWh;
        totalCost = kWh * chargingFee;
        emit ChargingStopped(msg.sender, block.timestamp, totalCost);
        payable(owner).transfer(totalCost);
    }
}
