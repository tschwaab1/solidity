//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6;

interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function transfer(address to, uint tokens) external returns (bool success);
    
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract OMIMoney is ERC20Interface{
    string public name = "Omicron";
    string public symbol = "OMI";

    uint public supply;
    uint public totalOwners;
    address public founder;

    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) private allowed;

    mapping(string => uint) proposeValue; //value of proposed mint tokens
//    mapping(string => uint) public proposeAnswe;
    mapping(string => mapping(address =>bool)) public proposeVoters; //yes votes
    
    mapping(string => mapping(uint =>address)) public addressList; //List of the addresses of voters voter["this"][]
    mapping(string => uint) public voters; //number of voters per name 
  /*  mapping(string => uint) public voting_quantity;    
    mapping(string => uint) public voting_close;    
    mapping(string => uint) public voting_yes;    
    mapping(string => uint) public voting_no;  
*/
    constructor(uint s){
        supply=s;
        founder=msg.sender;
        balances[founder]=supply;
        totalOwners = 1;
    }
    function totalSupply() public view override returns (uint){
        return(supply);
    }

    function propMint(string memory _name,uint amount) public {
        require(amount > 0, "You can't create/mint less than 1 token!");
        require(proposeValue[_name] == 0, "Already exsists with this anme!!!");
        require(balances[msg.sender] > 0, "Only ppl with tokens can vote");
        //require(msg.sender == founder);

       // if(bytes(proposeValue[_name]).length == 0){
            
       // }

        proposeValue[_name] = amount;
        /**


    mapping(string => uint) proposeValue;
    mapping(string => uint) public proposeAnswe;
    mapping(string => mapping(address =>uint)) public proposeVoters;

        If more than 50% voted for minting than do this and so on...
        supply += supply+amount;
        balances[founder] = blances[founder] + amount;
        */
    }


    function voteYes(string memory _name) public {
        require(proposeValue[_name] != 0, "Already exsists with this anme!!!");
        require(balances[msg.sender] > 0, "Only ppl with tokens can vote");

        proposeVoters[_name][msg.sender] = true; // set voting[name][address] true
        addressList[_name][voters[_name]] = msg.sender; //write voter into adsress list
        voters[_name] = voters[_name] + 1; //make total voter count[name] +1

        //mapping(string => mapping(uint =>address)) public addressList;
    }

    function mint(string memory _name) public{
        require(msg.sender == founder, "Only founder can do mint");
        uint yesVootes = 0;
        uint amount = proposeValue[_name];

        for (uint j = 0; j >= totalOwners; j ++) { // loop until total users count reached
        
            address vots = addressList[_name][j]; //get address of voter

                if(proposeVoters[_name][vots] == true){ //use address to get voting result true/false
                    
                    yesVootes = yesVootes + 1; //if true -> counter + 1
                }
        }

        if(yesVootes >= (totalOwners / 2)){   //after loop: if yes votes > (50% of total votes count)
            supply = supply+amount;		//add to supply
            balances[founder] = balances[founder] + amount; //send new tokens to founder
        }
         
                         
                
        //require()
    }

    function getYesVotes(string memory _name) public view returns(uint){
        return voters[_name];
    }
  /*  function voteYes(string name) public {
        require(bytes(proposeValue[name]) > 0, "Does not exsist!!!");
    }
*/
    /*
        Modifica il contratto cryptotoken dando la possibilità
        al fondatore di RIDURRE la supply distruggendo dei token che devono essere suoi.
    */
    function burn(uint amount) public {
        require(msg.sender == founder, "Only Founder can burn");

        uint accountBalance = balances[founder];
        require(accountBalance >= amount, "burn amount exceeds balance");

        balances[founder] = accountBalance - amount;
        supply -= amount;

        emit Transfer(msg.sender, address(0), amount);
    }

    function balanceOf(address tokenOwner) public view override returns (uint){
        return(balances[tokenOwner]);
    }

    function transfer(address to, uint tokens) public override returns (bool){
        uint to_balance = balanceOf(to);
        require(tokens>0 && balances[msg.sender]>=tokens);
        balances[msg.sender]-=tokens;
        balances[to]+=tokens;
        emit Transfer(msg.sender,to,tokens);
        
            if(to_balance <= 0){
                totalOwners = totalOwners +1; // add +1
            }

        return(true);
    }

    function allowance(address tokenOwner, address spender) public view override returns (uint){
    //function allowance(address from, adress to, uint tokens) public override returns(bool){
        //require(tokens >0 && balance[from]>=tokens &&)
        return(allowed[tokenOwner][spender]);
    }

    function approve(address spender, uint tokens) public override returns (bool){
        //require(tokens>0, "tokends have to be positive");
        require(balances[msg.sender]>=tokens);

        allowed[msg.sender][spender]=tokens;
        emit Approval(msg.sender, spender, tokens);
        return(true);
    }


    function transferFrom(address from, address to, uint tokens) public override returns (bool){
        uint to_balance = balanceOf(to);
        require(tokens >0,"must be positive");
        require(allowed[from][msg.sender]>=tokens, "sth wrong");
        require(balances[from]>=tokens);
        balances[from]-=tokens;
        balances[to]+=tokens;
        emit Transfer(from, to, tokens);

            if(to_balance <= 0){ //if the balance of "to" is zero, he had no tokens before
                                 //so add +1 to totalOwners
                totalOwners = totalOwners +1; // add +1
            }

        return(true);

    }


}
