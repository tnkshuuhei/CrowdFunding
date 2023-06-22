// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

contract CrowdFunding {
    struct Campaign {
			address owner;
			string title;
			string description;
			uint256 target;
			uint256 deadline;
			uint256 amountCollected;
			string image;
			address[] donators;
			uint256[] donations; 
		}
		mapping (uint256 => Campaign) public campains;
		
		uint256 public numberOfCampaigns = 0;

		// return the id of campain
		function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns(uint256){
			//TODO
			Campaign storage campaign = campains[numberOfCampaigns];
			// check if deadline is in the future
			require(_deadline > block.timestamp, "Deadline must be in the future");
			
			// store given values into the struct
			campaign.owner = _owner;
			campaign.title = _title;
			campaign.description = _description;
			campaign.target = _target;
			campaign.deadline = _deadline;
			campaign.amountCollected = 0;
			campaign.image = _image;
			numberOfCampaigns++;
			//TODO
			return numberOfCampaigns - 1;
		}

		function donateToCapmpaign(uint256 _id) public payable{
			uint256 amount = msg.value;
			Campaign storage campaign = campains[_id]; 

			campaign.donators.push(msg.sender);
			campaign.donations.push(amount);
			
			(bool sent,) = payable(campaign.owner).call{value: amount}("");
			if(sent){
				campaign.amountCollected += amount;
			}
		}
		// return the address of donators and the amount of donations
		function getDonators(uint256 _id) public view returns(address[] memory, uint256[]memory ){
			return (campains[_id].donators, campains[_id].donations);
		}
		function getCampaign() public view returns( Campaign[] memory){
			Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);
			for(uint256 i = 0; i < numberOfCampaigns; i++){
				Campaign storage item = campains[i];
				allCampaigns[i] = item;

			}
			return allCampaigns;
		}
}  