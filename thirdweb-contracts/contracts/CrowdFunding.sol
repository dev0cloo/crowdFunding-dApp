// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// CrowdFunding contract to create and manage campaigns

contract CrowdFunding {
    constructor() {}

    // creates a Campaign object to store the variables
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    //assign a number to each campaign
    mapping(uint256 => Campaign) public campaigns;

    uint256 numberOfCampaigns = 0;

    // creates a campaign and returns a campaign id
    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        Campaign storage campaign = campaigns[numberofCampaigns];
        require(
            campaign.deadline < block.timestamp,
            "The deadline should be a date in the future."
        );

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;
    }

    // donate to a campaign and store the address and amount
    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if (sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    function getDonators() public {}

    function getCampaigns() public {}
}
