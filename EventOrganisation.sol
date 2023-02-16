// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Eventorganisation
{
    struct details
    {
        address admin;
        string name;
        uint date;
        uint price;
        uint ticketcount;
        uint ticketremaining;
    }

    mapping (uint=>details) public events;
    mapping (address=>mapping(uint=>uint)) public tickets;
    uint public nextid;

    function createevent(string memory name,uint date,uint price,uint ticketcount) external
    {
           require(date > block.timestamp,"wrong event organising");
           require(ticketcount > 0,"create ticket first");
           events[nextid] = details(msg.sender,name,date,price,ticketcount,ticketcount);
            nextid++;
    }

    function buyticket(uint id,uint quantity) public payable
    {
        require(events[id].date!=0,"Searching for tickets of invalid event");
        require(events[id].date > block.timestamp,"Event has been already done");
        require(events[id].ticketremaining >= quantity,"Ticket not available");
        require(msg.value == events[id].price*quantity,"Insufficient balance");
        tickets[msg.sender][id] = tickets[msg.sender][id] + quantity;
        events[id].ticketremaining = events[id].ticketremaining - quantity;
    }

    function transferticket(uint id,uint quantity,address to) public
    {
        require(events[id].date!=0,"Searching for tickets of invalid event");
        require(events[id].date > block.timestamp,"Event has been already done");
        require(tickets[msg.sender][id] >= quantity,"Insufficient amout of ticket to send");
        tickets[msg.sender][id] = tickets[msg.sender][id] - quantity;
        tickets[to][id] = tickets[to][id] + quantity;

    }
}

