// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

import "./IERC20.sol";

contract Mixer {
    /***Events***/
    event Deposit(uint256 commitment);
    event Mix(address tgt);

    /***Fields***/
    uint public amt;
    IERC20 public erc20;

    mapping(uint256=>bool) commitments;

    /***Struct***/
    struct DepositProof{
        string proof;
        address receipent;
        //We omit the signature here  
    }

    constructor(address _erc20, uint _amt) public {
        erc20 = IERC20(_erc20);
        amt = _amt;
    }

    modifier onlyValidProof(DepositProof memory _proof){
        require(_isValidProof(_proof));
        _;
    }

    //人家可以判断出：alice释放了值为1的承诺
    function deposit(uint256 _commitment) public {
        require(!commitments[_commitment], "duplicate commitment");

        commitments[_commitment] = true;

        erc20.transferFrom(msg.sender, address(this), amt);        

        emit Deposit(_commitment);

    }

    //人家可以判断出：目标转账为bob的这笔交易，消耗了值为1的承诺
    function mix(DepositProof memory _proof) public onlyValidProof(_proof){
        uint256 commitment = uint256(keccak256(bytes(_proof.proof)));
        
        commitments[commitment] = false;

        erc20.transfer(_proof.receipent, amt);

        emit Mix(_proof.receipent);
    }

    function _isValidProof(DepositProof memory _proof) internal view returns (bool){
        //require(signatureValid(_proof));//Omit this...
        string memory proof = _proof.proof;
        uint256 commitment = uint256(keccak256(bytes(proof)));
        return commitments[commitment];
    }



}
