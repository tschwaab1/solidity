//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6;

contract vacation{

address payable proprietario; //owner
address payable turista; 
address arbitro;
uint doorCode;
uint price;
uint numberWeeks;
uint paid;
uint status; //
uint arrival;

    constructor(uint _doorCode, uint _price, address _arbitro){
        //Passo 1
        //set prezzo, adress of arbitro e doorcode -> set status 1
        doorCode = _doorCode;
        price = _price;
        arbitro = _arbitro;
        status = 1;
    }

    function booking() public payable{
        //Passo 2
        //get numberweeks, min 20% of price * numberweeks
        //save tourista adress (msg.sender), save how much paid?, status =2;


        //require msg.value > installment
        uint installment = (price * 20) / 100;
        installment = installment * numberWeeks;
        require(msg.value >= installment, "you have to sent at least 20% of the price!");
        require(status == 1, "no offer created or already payed");
        // if instead require?    
        turista = payable(msg.sender);
        paid = installment;
        status = 2;
        /*
        example int percent: price = 1000
                 numberWeeks = 2
                 1000 * 20 = 20000 / 100 = 200 -> 20% of 1000
                 200 * 2 = 400 (2000 * 0,2 = 400)
        */
    }

    function getCode() public returns(uint) {
        //Passo3
        //only by tourist, only if status = 2
        //save time, set staus =3
        //returns doorCode!!!!!
        
        require(msg.sender == turista, "Only tourist can execute this function");
        require(status == 2, "the installment is not payed or it's the wrong step");

        status = 3;
        arrival = block.timestamp;

        return doorCode;
    }

    function payment() public payable{
        //Passo 4
        //only by tourist && only if statzs == 3
        //msg.value > rest of money (80% of price * weeks)
        //tranfser to proprietario

        require(msg.sender == turista,"Only tourista can execute this function");
        require(status == 3,"only executable if the code has been requested!");

        uint rest_money = (price * 80) / 100;
        rest_money = rest_money * numberWeeks;

        //uint full_money = price * numberWeeks;

        //if((address(this).balance >= full_money){ //? is it rly working? is adressthisbalance rly at this point the total amount????
            //((address(this)).balance)
        if(msg.value >= rest_money){
            proprietario.transfer((address(this).balance));
            status = 1;
            paid = paid + rest_money;
        }

    }

    function reclamation() public {
        // Passo 5
        //only by tourist and only if arrival + 20 * 60 <= block.timestamp 
        //only if status ==3
        //than do status = 4

        uint timespan = arrival + 20 * 60;

        require(msg.sender == turista , "Only tourista can execute the function");
        require(status == 3, "Wrong status, reclamation not (yet) allowed!");
        require(timespan >= block.timestamp , "You can du reclamation only 20 minutes after getting the code/arrival");
            // arrvial + 20 minutes 
            //has to be within current timestamp
            //so it has to be bigger or equal current time
        status = 4;
    }

    function arbitration(uint percent) public {
        //Passo 6
        //only by arbitro, only status 4
        //if percent set
        //send installment "percent" * price to proprietario
        //send rest to tourista
        require(msg.sender == arbitro, "Only arbitro can execute this function!");
        require(status == 4, "wrong status, has to be 4(reclamation first!)");
        require(percent >= 0 && percent <= 100, "the percent parameter has to be between 0 and 100 (included)!");
    
    
        proprietario.transfer((paid*percent) / 100); //send x percent of paid
        turista.transfer((address(this).balance)); //send rest to tourista

    }

    function getStatus() public view returns(uint){
        return status;
    }




}
