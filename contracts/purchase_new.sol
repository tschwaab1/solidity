//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6;

contract purchase{

    address payable private seller;
    address payable private buyer;
    address public shipper;
    address public new_shipper_bybuyer;
    address public new_shipper_byseller;
    uint public reject_percent;
    uint public minWei;
    enum StatusType {Start,Paid,Accepted}
    StatusType public status;

/*     mapping(address => uint) public buyer_balances;
    mapping(address => StatusType) public stati; */

    constructor(address s){
        seller = payable(msg.sender);
        status = StatusType.Start;
        minWei = 1000; //minimal Wei to create an Offer
        reject_percent = 20; //20%
        //Reject partial sum to buyer, rest to the seller
        shipper = s;
        new_shipper_bybuyer = shipper; /* give one different value if ..bybuyer/byseller is not defined until
        //the execution of change_shipper both are 0x00000... and equal, which would set it to a undefined/ default adress (0x000....)
        */
    }

    function propose_and_pay() public payable{

        string memory error_minWeiA = "You have to use at least ";
        string memory error_minWeiB = "Wei to create an Offer";
        string memory minWeiStr = string(abi.encodePacked(minWei, " "));
        string memory error_minWei = append(error_minWeiA, minWeiStr, error_minWeiB);
        //complicated way of concatenating 3 strings including one uint 
        require(status==StatusType.Start);
        require(msg.value >= minWei, error_minWei);
        //sender value has to be higher than minWei
        buyer=payable(msg.sender);
        status=StatusType.Paid;
    }


    function reject() public{
        require(msg.sender==seller);
        require(status==StatusType.Paid);
        status = StatusType.Start;
        buyer.transfer( (address(this)).balance );
    }

    function change_buyer(address buyyer) public {
        require(msg.sender == seller, "Not allowed to change the buyer!!");
        buyer = payable(buyyer);
    }

    function change_shipper(address new_shipper) public {
        require(msg.sender == buyer || msg.sender == seller, "Not allowed to change shipper!!!");
        //check if buyer or seller is  calling the function
        
        if(msg.sender == buyer){
            //if buyer
           new_shipper_bybuyer = new_shipper;

        }else {
            //else since only buyer or seller can execute the function
            //if it is not buyer, it can be only seller...
           new_shipper_byseller = new_shipper;
        }

        require(new_shipper_bybuyer == new_shipper_byseller, "Shipper && Buyer have to agree on the same new Shipper!");
        shipper = new_shipper;
    }

    function reject_purchase_buyer() public {
        require(msg.sender == buyer,"Only Buyer is allowed to");
        require(status == StatusType.Accepted, "Has to be an Accepted Order!");

        buyer.transfer( (((address(this)).balance) * reject_percent) / 100 ); //multiply first - send the percentage to the buyer
        seller.transfer( address(this).balance ); // rest to the seller?
        
        status = StatusType.Start;
        /*
        Multiplication example:
        Basic Balance: 10.000 Wei -> I want 20% which will be refunded by default if no other reject percent has been set
                       10.000 * 20 = 200.000 
                      200.000 / 100 =  2000 (y) :yes: works without float results
        **/
    }

    function accept() public{
        require(msg.sender==seller);
        require(status==StatusType.Paid);
        status = StatusType.Accepted;
    }

    function delivered() public{
        require(status==StatusType.Accepted);
        require(msg.sender==shipper);
        status = StatusType.Start;
        seller.transfer( (address(this)).balance );
    }

    function not_delivered() public{
        require(status==StatusType.Accepted);
        require(msg.sender==shipper);
        status = StatusType.Start;
        buyer.transfer( (address(this)).balance );
    }

    function reclaim() public{
        require(status==StatusType.Accepted);
        require(msg.sender==buyer);
        // qui devo inserire un controllo che sia passato abbastanza tempo 
        status = StatusType.Start;
        buyer.transfer( (address(this)).balance );        
    }

    //Additional Functions

    function append(string memory a, string memory b, string memory c) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c));
    }
    
}