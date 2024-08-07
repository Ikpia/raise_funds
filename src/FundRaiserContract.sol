// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract FundRaiser {
    string public name;
    string public url;
    string public description;
    string public image_url;
    address public custodian;
    address payable public beneficiary;
    uint256 public totalAmount;
    uint256 public totalNumOfDonations;

    constructor(
        string memory _name,
        string memory _url,
        string memory _description,
        string memory _image_url,
        address _custodian,
        address payable _beneficiary
    ) {
        name = _name;
        url = _url;
        description = _description;
        image_url = _image_url;
        custodian = _custodian;
        beneficiary = _beneficiary;
    }

    modifier onlyCustodian() {
        require(msg.sender == custodian, "not the custodian of the contract");
        _;
    }

    event sendEvent(address indexed sender, uint256 amount);
    event withdrawEvent(uint256 balance);

    struct Donate {
        uint256 amount;
        uint256 date;
    }
    mapping(address => Donate[]) private donations;

    function updateBenficiary(
        address payable _benficiary
    ) public onlyCustodian {
        beneficiary = _benficiary;
    }

    function donate() public payable {
        /*Donate[] storage _donation = donations[msg.sender];
        Donate memory _donate =  Donate(msg.value, block.timestamp);
        _donation.push(_donate);
        donations[msg.sender] = _donation;*/

        Donate memory _donation = Donate(msg.value, block.timestamp);
        donations[msg.sender].push(_donation);
        totalAmount += msg.value;
        totalNumOfDonations++;
        emit sendEvent(msg.sender, msg.value);
    }

    function numOfDonation() public view returns (uint256) {
        return donations[msg.sender].length;
    }

    function getDonation()
        public
        view
        returns (uint256[] memory amounts, uint256[] memory dates)
    {
        uint256 count = numOfDonation();
        amounts = new uint256[](count);
        dates = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            Donate storage _donate = donations[msg.sender][i];
            amounts[i] = _donate.amount;
            dates[i] = _donate.date;
        }
        return (amounts, dates);
    }

    function withdraw() public onlyCustodian {
        uint256 balance = address(this).balance;
        beneficiary.transfer(balance);
        emit withdrawEvent(balance);
    }

    receive() external payable {
        totalAmount += msg.value;
        totalNumOfDonations++;
    }

    fallback() external payable {
        totalAmount += msg.value;
        totalNumOfDonations++;
    }
}
