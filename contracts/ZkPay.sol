// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";

/**
 * @dev {ERC721} token, including:
 *
 *  - ability for holders to burn (destroy) their tokens
 *  - a creator role that allows for token minting (creation)
 *  - a pauser role that allows to stop all token transfers
 *  - token ID and URI autogeneration
 *
 * This contract uses {AccessControl} to lock permissioned functions using the
 * different roles - head to its documentation for details.
 *
 * The account that deploys the contract will be granted the creator and pauser
 * roles, as well as the default admin role, which will let it grant both creator
 * and pauser roles to other accounts.
 */
contract ZkPay is
    Context,
    AccessControlEnumerable,
    ERC721Enumerable,
    ERC721Burnable,
    ERC721Pausable
{
    using Counters for Counters.Counter;

    bytes32 public constant ZKPAY_ADMIN_ROLE = keccak256("ZKPAY_ADMIN_ROLE");
    bytes32 public constant ZKPAY_OPERATOR_ROLE = keccak256("ZKPAY_OPERATOR_ROLE");
    bytes32 public constant ZKPAY_CREATOR_ROLE = keccak256("ZKPAY_CREATOR_ROLE");

    Counters.Counter private _tokenIdTracker;

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    event LoyaltyNFTCreated(
        uint256 tokenID,
        address indexed creator,
        string metaDataUri
    );

    using Strings for uint256;

    /**
     * @dev Grants `ZKPAY_ADMIN_ROLE`, `ZKPAY_CREATOR_ROLE` and `ZKPAY_OPERATOR_ROLE` to the
     * account that deploys the contract.
     *
     * Token URIs will be autogenerated based on `baseURI` and their token IDs.
     * See {ERC721-tokenURI}.
     */
    constructor(
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) {
        // Set the name and Symbol for the NFT Contract
        _setupRole(ZKPAY_ADMIN_ROLE, _msgSender());

        _setRoleAdmin(ZKPAY_ADMIN_ROLE, ZKPAY_ADMIN_ROLE);
        _setRoleAdmin(ZKPAY_CREATOR_ROLE, ZKPAY_OPERATOR_ROLE);
        _setRoleAdmin(ZKPAY_OPERATOR_ROLE, ZKPAY_ADMIN_ROLE);

    }

    /**
     * @dev Creates a new token for `to`. Its token ID will be automatically
     * assigned (and available on the emitted {IERC721-Transfer} event), and the token
     * URI autogenerated based on the base URI passed at construction.
     *
     * See {ERC721-_safeMint}.
     *
     * Requirements:
     *
     * - the caller must have the `ZKPAY_CREATOR_ROLE`.
     */
    function createLoyaltyNFT(string memory metadataHash)
        public
        onlyRole(ZKPAY_CREATOR_ROLE)
        returns (uint256)
    {
        // We cannot just use balanceOf to create the new tokenId because tokens
        // can be burned (destroyed), so we need a separate counter.
        _tokenIdTracker.increment();
        uint256 currentTokenID = _tokenIdTracker.current();
        _safeMint(_msgSender(), currentTokenID);
        _setTokenURI(currentTokenID, metadataHash);

        emit LoyaltyNFTCreated(
            currentTokenID,
            _msgSender(),
            tokenURI(currentTokenID)
        );
        return currentTokenID;
    }

    /**
     * @dev Creates a new token for `to`. Its token ID will be automatically
     * assigned (and available on the emitted {IERC721-Transfer} event), and the token
     * URI autogenerated based on the base URI passed at construction.
     *
     * See {ERC721-_safeMint}.
     *
     * Requirements:
     *
     * - the caller must have the `ZKPAY_CREATOR_ROLE`.
     */
    function delegateLoyaltyNFTCreation(
        address creator,
        string memory metadataHash
    ) public onlyRole(ZKPAY_OPERATOR_ROLE) returns (uint256) {
        // We cannot just use balanceOf to create the new tokenId because tokens
        // can be burned (destroyed), so we need a separate counter.
        _tokenIdTracker.increment();
        uint256 currentTokenID = _tokenIdTracker.current();
        _safeMint(creator, currentTokenID);
        _setTokenURI(currentTokenID, metadataHash);

        emit LoyaltyNFTCreated(currentTokenID, creator, metadataHash);
        return currentTokenID;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(_exists(tokenId), "ZkPay: Non-Existent LoyaltyNFT");
        string memory _tokenURI = _tokenURIs[tokenId];

        return _tokenURI;       
    }

    /**
     * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _setTokenURI(uint256 tokenId, string memory _tokenURI)
        internal
        virtual
    {
        require(_exists(tokenId), "ZkPay: Non-Existent LoyaltyNFT");
        _tokenURIs[tokenId] = _tokenURI;
    }

    /**
     * @dev Pauses all token transfers.
     *
     * See {ERC721Pausable} and {Pausable-_pause}.
     *
     * Requirements:
     *
     * - the caller must have the `ZKPAY_OPERATOR_ROLE`.
     */
    function pause() public onlyRole(ZKPAY_OPERATOR_ROLE) {
        _pause();
    }

    /**
     * @dev Unpauses all token transfers.
     *
     * See {ERC721Pausable} and {Pausable-_unpause}.
     *
     * Requirements:
     *
     * - the caller must have the `ZKPAY_OPERATOR_ROLE`.
     */
    function unpause() public onlyRole(ZKPAY_OPERATOR_ROLE) {
        _unpause();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControlEnumerable, ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}