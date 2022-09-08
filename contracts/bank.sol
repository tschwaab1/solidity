//SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.6;

contract bank{
    mapping(address => uint) private balances;
    address owner;
    uint public fee;

    constructor(){  // contract's constructor function
        owner = msg.sender;
        fee = 11111;
    }

    receive() external payable{
        balances[msg.sender] += msg.value;
    }

    function deposit() payable public{
        balances[msg.sender]+=msg.value;

        //subtract fee
        balances[msg.sender] = balances[msg.sender] - fee;
    }

    function internal_transfer(uint q, address R) public{
        require(balances[msg.sender]>=(q+fee));
        balances[R]+=q;
        balances[msg.sender]-=q;
        //subtract fee
        balances[msg.sender] = balances[msg.sender] - fee;
    }

    function external_transfer(uint q, address payable R) public payable{
        require(balances[msg.sender]>=(q+fee));
        //check if enough money is avaliable

        bool sent = R.send(q);
        //boolean with status
        require(sent, "Failed to send Ether");
                //subtract fee
        balances[msg.sender] = balances[msg.sender] - fee;
        balances[msg.sender] = balances[msg.sender] - q;
        //subtract money
    }

    //2.
    function take_the_money_and_run() public{
        require(owner == msg.sender);
        //msg.sender.transfer(address(this).balances);
        //(payable(msg.sender)).transfer(address(this);
        //subtract fee
        //balances[msg.sender] = balances[msg.sender] - fee;
        (payable(msg.sender)).transfer((address(this)).balance); // Transfered from my Add (Creat0r of Contract TO Contract addr??!?!?)
                     //        (address(this)).balance 

        //OLD: (payable(msg.sender)).transfer(balances[msg.sender]);
        /** 2. is it working? or add all balances[x] money to one var and take this amount???*/
    }

    function deposit_on_another(address R) payable public{
        balances[R]+=msg.value;
                //subtract fee
        balances[msg.sender] = balances[msg.sender] - fee;
    }

    function withdraw(uint q) public{
        require(balances[msg.sender]>=(q+fee));
                //subtract fee
        balances[msg.sender] = balances[msg.sender] - fee;
        balances[msg.sender]-=q;
        (payable(msg.sender)).transfer(q);

        
    }

    function set_fee(uint fe) public{
        require(owner == msg.sender);
        fee = fe;
    }

    function tell_balance() view public returns(uint){
        return(balances[msg.sender]);
    }

}