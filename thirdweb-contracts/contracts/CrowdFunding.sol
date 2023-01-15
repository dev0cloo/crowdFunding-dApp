// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// CrowdFunding contract to create and manage campaigns

contract CrowdFunding {
    constructor() {}

    // defines a struct that will be used to store the variables for each campaign
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

    //assigns a unique number to each campaign, and is accessible to anyone
    mapping(uint256 => Campaign) public campaigns;

    uint256 numberOfCampaigns = 0;

    // allows anyone to create a campaign and it returns a campaign ID
    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        //checks that the campaign's deadline is in the future and the target is greater than zero
        require(
            block.timestamp < _deadline,
            "The deadline should be a date in the future."
        );
        require(
            _target > 0,
            "The campaign should have a target greater than 0."
        );
        Campaign storage campaign = campaigns[numberOfCampaigns];
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;
        numberOfCampaigns++;
        return numberOfCampaigns - 1;
    }

    //allows users to make donations to a specific campaign identified by its ID
    function donateToCampaign(uint256 _id) public payable {
        //checks if the campaign ID exists
        require(_id < numberOfCampaigns, "Campaign ID does not exist.");
        Campaign storage campaign = campaigns[_id];
        require(
            block.timestamp < campaign.deadline,
            "Campaign deadline has passed."
        );
        //updates the userDonations, donators, donations and amountCollected
        uint256 amount = msg.value;
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);
        campaign.amountCollected += amount;
    }

    // returns donators and the amount donated
    function getDonators(
        uint256 _id
    ) public view returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);
        for (uint256 i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];
            allCampaigns[i] = item;
        }
        return allCampaigns;
    }

    function withdrawFunds(uint256 _id) public {
        require(_id < numberOfCampaigns, "Campaign ID does not exist.");
        Campaign storage campaign = campaigns[_id];
        require(
            msg.sender == campaign.owner,
            "Only the campaign owner can withdraw funds."
        );
        require(campaign.amountCollected > 0, "No funds to withdraw.");
        payable(msg.sender).transfer(campaign.amountCollected);
    }
}
