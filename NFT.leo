// Define the NFT contract
contract NFT {

    // Define the token name and symbol
    let name: String
    let symbol: String

    // Define a mapping to track token ownership
    let owners: Map<Public(ContractAccount), Public(ContractAccount)>

    // Define the contract owner
    let owner: Public(ContractAccount)

    // Constructor function to initialize the NFT
    public fn init(name: String, symbol: String) {
        self.name = name
        self.symbol = symbol
        self.owners = emptyMap<Public(ContractAccount), Public(ContractAccount)>()
        self.owner = getTransaction().getSender()
    }

    // Function to mint a new token and assign ownership
    public fn mint(to: Public(ContractAccount)) {
        require(getTransaction().getSender() == self.owner, "Only the contract owner can mint tokens")
        require(!self.owners.contains(to), "Token already minted for this address")

        // Assign ownership
        self.owners.put(to, to)
    }

    // Function to transfer ownership of a token
    public fn transfer(from: Public(ContractAccount), to: Public(ContractAccount)) {
        require(self.owners.getOrElse(from, to) == from, "Sender does not own the token")
        self.owners.put(from, to)
    }

    // Function to check the current owner of a token
    public fn ownerOf(tokenId: Public(ContractAccount)) -> Public(ContractAccount) {
        return self.owners.getOrElse(tokenId, getTransaction().getSender())
    }
}
