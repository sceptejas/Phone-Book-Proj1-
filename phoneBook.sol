// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
contract phonebook{
    struct people{
        string name;
        uint256 phoneNo;
        address MetaMask;
    }
    people[] public peopleArray;
    mapping(string => people)NameToDetails;
    function addToBook(string memory _name, uint256 _phoneNo, address _Metamask) public{
        people memory newPerson = people(_name, _phoneNo, _Metamask);
        peopleArray.push(newPerson);
        NameToDetails[_name] = newPerson;       
    } 
    function getMapping(string memory _name) view public returns(uint256){
        return NameToDetails[_name].phoneNo;
    }
}
