//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.11;
contract randomDrawing {
	struct Product {		
		string productName;
		uint price;
		string imgLink;
	}
	address public owner;		// 소유자(= 총 판매자)
	int public totalParticipantInterest; // 참여자들의 총 이익
	uint public numParticipants; // 참여자 수
	uint public numProducts; // 총 상품 수
	uint public randomIndex; // 랜덤한 인덱스
	Product public highPriceProduct; // 상품 중 제일 비싼 가격
	mapping (uint => Product) public products; // 상품 리스트
	
	modifier onlyOwner () {
		require(msg.sender == owner);
		_;
	}
	
	
	constructor () {
		owner = msg.sender;
		numParticipants = 0;
		numProducts = 0;
		totalParticipantInterest = 0;
		highPriceProduct.productName = "nothing";
		highPriceProduct.price = 0;
		highPriceProduct.imgLink = "https://dummyimage.com/600x400/ffffff/4c56e0&text=nothing";
	}
	
	function addProduct( string memory productName,  uint price,  string memory imgLink) public onlyOwner returns (bool) {
		require(price >= 8000000);

		Product storage prd = products[numProducts++];
		prd.productName = productName;
		prd.price = price;
		prd.imgLink = imgLink;
		if (highPriceProduct.price < price) {
			highPriceProduct.price = price;
			highPriceProduct.productName = productName;
			highPriceProduct.imgLink = imgLink;
		}
		return true;
	}

	function applyRandom() public payable {
		// 랜덤한 상품 출력		
		require(msg.value == 10000000);
		require(numProducts > 0);

		randomIndex = uint(keccak256(abi.encodePacked(msg.sender, block.timestamp))) % numProducts;
		numParticipants++;
		totalParticipantInterest += int(uint(products[randomIndex].price)) - 10000000;
	}


	function checkOwner() view public returns(bool) {
		if (msg.sender == owner) return true;
		else return false;
	}


	function getBalance() view public onlyOwner returns(uint) {
		return address(this).balance;
	}


	function kill() public onlyOwner {
		selfdestruct(payable(owner));
	}
}
