// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {FundRaiser} from "./FundRaiserContract.sol";

contract FundRaisersFactory {
    FundRaiser[] private fundRaiser;
    uint256 public maxLimit = 20;

    constructor() {}

    event createFundRaiserEvent(
        FundRaiser indexed _fundRaiser,
        address indexed sender
    );

    function getFundraiserCount() public view returns (uint256) {
        return fundRaiser.length;
    }

    function createFundRaiser(
        string memory _name,
        string memory _url,
        string memory _description,
        string memory _image_url,
        address _custodian,
        address payable _beneficiary
    ) public {
        FundRaiser _fundRaiser = new FundRaiser(
            _name,
            _url,
            _description,
            _image_url,
            _custodian,
            _beneficiary
        );
        fundRaiser.push(_fundRaiser);
        emit createFundRaiserEvent(_fundRaiser, msg.sender);
    }

    function getFundraiser(
        uint256 limit,
        uint256 offset
    ) public view returns (FundRaiser[] memory coll) {
        require(getFundraiserCount() > offset, "Offset is out of bounds");
        uint256 size = getFundraiserCount() - offset;
        size = size < limit ? size : limit;
        size = size < maxLimit ? size : maxLimit;
        coll = new FundRaiser[](size);
        for (uint i = 0; i < size; i++) {
            coll[i] = fundRaiser[offset + i];
        }
        return coll;
    }
}
