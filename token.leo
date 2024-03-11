// Define the token contract
contract Token {

    // Define the token name and symbol
    let name: String
    let symbol: String

    // Define a mapping to track token balances
    let balances: Map<Public(ContractAccount), UFix64>

    // Define the contract owner
    let owner: Public(ContractAccount)

    // Constructor function to initialize the token
    public fn init(name: String, symbol: String) {
        self.name = name
        self.symbol = symbol
        self.balances = emptyMap<Public(ContractAccount), UFix64>()
        self.owner = getTransaction().getSender()
    }

    // Function to transfer tokens from one account to another
    public fn transfer(to: Public(ContractAccount), amount: UFix64) {
        let sender = getTransaction().getSender()

        // Ensure sender has enough balance
        let senderBalance = self.balances.getOrElse(sender, 0.0 as UFix64)
        require(senderBalance >= amount, "Insufficient balance")

        // Transfer tokens
        self.balances.put(sender, senderBalance - amount)
        self.balances.put(to, self.balances.getOrElse(to, 0.0 as UFix64) + amount)
    }

    // Function to get the balance of an account
    public fn balanceOf(account: Public(ContractAccount)) -> UFix64 {
        return self.balances.getOrElse(account, 0.0 as UFix64)
    }

    // Function to mint new tokens (only accessible by the contract owner)
    public fn mint(to: Public(ContractAccount), amount: UFix64) {
        require(getTransaction().getSender() == self.owner, "Only the contract owner can mint tokens")
        self.balances.put(to, self.balances.getOrElse(to, 0.0 as UFix64) + amount)
    }
}
