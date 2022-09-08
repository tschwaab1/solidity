//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6;

/// @title ERC-721 Non-Fungible Token Standard
/// @dev See https://eips.ethereum.org/EIPS/eip-721
///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
interface ERC721 /* is ERC165 */ {
    /// @dev This emits when ownership of any NFT changes by any mechanism.
    ///  This event emits when NFTs are created (`from` == 0) and destroyed
    ///  (`to` == 0). Exception: during contract creation, any number of NFTs
    ///  may be created and assigned without emitting Transfer. At the time of
    ///  any transfer, the approved address for that NFT (if any) is reset to none.
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    /// @dev This emits when the approved address for an NFT is changed or
    ///  reaffirmed. The zero address indicates there is no approved address.
    ///  When a Transfer event emits, this also indicates that the approved
    ///  address for that NFT (if any) is reset to none.
    //event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    /// @dev This emits when an operator is enabled or disabled for an owner.
    ///  The operator can manage all NFTs of the owner.
 //   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) external view returns (uint256);
    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) external view returns (address);
    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
    ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
    ///  `onERC721Received` on `_to` and throws if the return value is not
    ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    /// @param data Additional data with no specified format, sent in call to `_to`
 //   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external payable;
    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev This works identically to the other function with an extra data parameter,
    ///  except this function just sets data to "".
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
// OKO esatamente uguale al transferfrom ma eh safe. 
   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external payable;
    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev This works identically to the other function with an extra data parameter,
    ///  except this function just sets data to "".
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer

// ha degli dati adizionali che manda qcosa a me.
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer



    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
    /// @notice Change or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    /// @param _approved The new approved NFT controller
    /// @param _tokenId The NFT to approve
  //  function approve(address _approved, uint256 _tokenId) external payable;
    /// @notice Enable or disable approval for a third party ("operator") to manage
    ///  all of `msg.sender`'s assets
    /// @dev Emits the ApprovalForAll event. The contract MUST allow
    ///  multiple operators per owner.
    /// @param _operator Address to add to the set of authorized operators
    /// @param _approved True if the operator is approved, false to revoke approval
 //   function setApprovalForAll(address _operator, bool _approved) external;
    /// @notice Get the approved address for a single NFT
    /// @dev Throws if `_tokenId` is not a valid NFT.
    /// @param _tokenId The NFT to find the approved address for
    /// @return The approved address for this NFT, or the zero address if there is none
 //   function getApproved(uint256 _tokenId) external view returns (address);
    /// @notice Query if an address is an authorized operator for another address
    /// @param _owner The address that owns the NFTs
    /// @param _operator The address that acts on behalf of the owner
    /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
 //   function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}
/// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
/// @dev See https://eips.ethereum.org/EIPS/eip-721
///  Note: the ERC-165 identifier for this interface is 0x5b5e139f.
interface ERC721Metadata /* is ERC721 */ {
    /// @notice A descriptive name for a collection of NFTs in this contract
    function name() external view returns (string memory _name);
    /// @notice An abbreviated name for NFTs in this contract
    function symbol() external view returns (string memory _symbol);
    /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
    /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
    ///  3986. The URI may point to a JSON file that conforms to the "ERC721
    ///  Metadata JSON Schema".
    function tokenURI(uint256 _tokenId) external view returns (string memory);
}

contract OMINFTs is ERC721,ERC721Metadata{
    string private NFTname="OMINFT";
    string private NFTsymbol="OMIE1625";
    string private defaultURI="https://crypto.schwaab.bayern/nft/nft.json";
    address private artist;
    uint256 private numberTokens;
    uint256 private fee;


    mapping(uint256 => address) private tokenOwner;
    mapping(uint256 => string) private tokenURIs;
    mapping(address => uint256) private howManyTokens;

    mapping(uint256 => address) public proposer; // contains the address of who made a proposal
    mapping(uint256 => uint) public proposedAmount;   // contains the proposed amount
    mapping(uint256 => uint) public proposalTime;   // timestamp of proposal

    constructor(){
        artist=msg.sender;
        numberTokens=0;
        fee = 20000; 
    }

    function name() public override view returns (string memory){
        return NFTname;
    }

    function symbol() public override view returns (string memory){
        return NFTsymbol;
    }

    function tokenURI(uint256 _tokenId) public override view returns (string memory){
        require(_tokenId < numberTokens,"token non ancora creato!");
        return tokenURIs[_tokenId];
    }

    function _mint(string memory _tokenURI) public returns(uint256){
        require(msg.sender==artist, "Non sei lartista!"); //*


        uint256 tokenID=numberTokens;
        numberTokens+=1;
        tokenOwner[tokenID]=msg.sender;
        howManyTokens[msg.sender]+=1;
        if (bytes(_tokenURI).length==0){
            tokenURIs[tokenID]=defaultURI; 
        } else {
            tokenURIs[tokenID]=_tokenURI;
        }
    emit Transfer(address(0), msg.sender, tokenID);
    return tokenID;
    }

    function mint_4all(string memory _tokenURI) public payable returns (uint256){
        
        string memory fee_txt = "mandare il fee in Wei: ";
        string memory feeAsString = uint2str(fee);

        string memory feeFull = string(abi.encodePacked(fee_txt, feeAsString));
        
        require(msg.value >= fee, feeFull);
        require(msg.sender != artist, "Usa _mint(), sei l'artista!!");
        payable(artist).transfer(fee);
        
       uint256 tokenID=numberTokens;
        numberTokens+=1;
        tokenOwner[tokenID]=msg.sender; 
        howManyTokens[msg.sender]+=1;
        if (bytes(_tokenURI).length==0){
            tokenURIs[tokenID]=defaultURI; 
        } else {
            tokenURIs[tokenID]=_tokenURI;
        }
    emit Transfer(address(0), msg.sender, tokenID);
    return tokenID;

    }

    function acceptProposal(uint256 _tID) public payable {
        require(msg.sender == ownerOf(_tID), "Solo tokenOwner poter fare acceptProposal");
        require(proposer[_tID] != address(0), "No Proposal for token");
        
        //require(bytes(proposer[_tID]).length >0);
        payable(msg.sender).transfer(proposedAmount[_tID]);
        payable(artist).transfer(fee);
        _transfer(proposer[_tID], _tID);        
    }

    function declineProposal(uint256 _tID) public payable {
        require(msg.sender == proposer[_tID], "Solo il proponente puo fare declineProposal");
        require(block.timestamp >= (proposalTime[_tID] + 600), "Solo dopo 60 secondi");

        address propo = proposer[_tID];

        payable(propo).transfer(proposedAmount[_tID]);

    }

    function createProposal(uint256 _tID, uint256 money) public payable {
        require(msg.value >= (money + fee), "Not enough money");

        proposer[_tID] = msg.sender;
        proposedAmount[_tID] = money;
        proposalTime[_tID] = block.timestamp;
        /**
            mapping(uint256 => address) public proposer // contains the address of who made a proposal
            mapping(uint256 => uint) public proposedAmount;   // contains the proposed amount
            mapping(uint256 => uint) public proposalTime;   // timestamp of proposal
        **/


    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function balanceOf(address _owner) public override view returns (uint256){
        return howManyTokens[_owner];
    }

    function ownerOf(uint256 _tokenId) public override view returns (address){
        require(_tokenId<numberTokens, "token non e anorra creato!");
        return tokenOwner[_tokenId];
    }


    function _transfer(address _to, uint256 _tokenId) private {
        address originalOwner=tokenOwner[_tokenId];
        howManyTokens[originalOwner] -= 1;
        tokenOwner[_tokenId]=_to;
        howManyTokens[_to]+=1;
        emit Transfer(originalOwner, _to,_tokenId);

    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public override payable{
        require(_tokenId<numberTokens,"non creato!");
        require(_from==tokenOwner[_tokenId],"non sei il proprietario");
        require(_from==msg.sender,"to token non e tuo!!");
        _transfer(_to,_tokenId);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) public override payable{
          transferFrom(_from,_to,_tokenId);     
    }
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public override payable{
          transferFrom(_from,_to,_tokenId);     
      }

}