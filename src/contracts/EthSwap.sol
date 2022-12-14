pragma solidity ^0.5.0;

import "./Token.sol";

contract EthSwap {
	string public name = "EthSwap Instant Exchange";
	Token public token;
	uint public rate = 100;

	event TokensPurchased(
		address account,
		address token,
		uint amount,
		uint rate
		);

	event TokensSold(
		address account,
		address token,
		uint amount,
		uint rate
		);

	constructor (Token _token) public {
		token = _token;
	}

	function buyTokens() public payable{
		//Calculate the number of tokens to buy
		uint tokenAmount = msg.value * rate;

		//Require that ethswap has enough tokens
		require(token.balanceOf(address(this)) >= tokenAmount);

		//Transfer tokens to the user
		token.transfer(msg.sender, tokenAmount);

		//Emit on event
		emit TokensPurchased(msg.sender, address(token), tokenAmount, rate);
	}

	function sellTokens(uint _amount) public{
		//User an't sell more tokens than they have
		require(token.balanceOf(msg.sender) >= _amount);
		
		//Calculate the amount of Ether to redeem
		uint etherAmount = _amount / rate;

		//Require that ethswap has enough ether
		require(address(this).balance >= etherAmount);

		//Perform Sale
		token.transferFrom(msg.sender, address(this), _amount);
		msg.sender.transfer(etherAmount);

		//Emit on event
		emit TokensSold(msg.sender, address(token), _amount, rate);
	}
}