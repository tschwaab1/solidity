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
    address public founder;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) private allowed;

    constructor(uint s){
        supply=s;
        founder=msg.sender;
        balances[founder]=supply;
    }
    function totalSupply() public view override returns (uint){
        return(supply);
    }
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
        require(tokens>0 && balances[msg.sender]>=tokens);
        balances[msg.sender]-=tokens;
        balances[to]+=tokens;
        emit Transfer(msg.sender,to,tokens);
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
        require(tokens >0,"must be positive");
        require(allowed[from][msg.sender]>=tokens, "sth wrong");
        require(balances[from]>=tokens);
        balances[from]-=tokens;
        balances[to]+=tokens;
        emit Transfer(from, to, tokens);
        return(true);

    }


}
