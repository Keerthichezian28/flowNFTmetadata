import NonFungibleToken from 0x05

pub contract CryptoPoops: NonFungibleToken {
  pub var totalSupply: UInt64

  pub event ContractInitialized()
  pub event Withdraw(id: UInt64, from: Address?)
  pub event Deposit(id: UInt64, to: Address?)

  pub resource NFT: NonFungibleToken.INFT {
    pub let id: UInt64

    pub let name: String

    init() {
      self.id = CryptoPoops.totalSupply
  CryptoPoops.totalSupply = CryptoPoops.totalSupply + ( 1 as UInt64)
      self.name = "Rishi"
     
    }
  }

  pub resource interface MyCollectionPublic {
    pub fun deposit(token: @NonFungibleToken.NFT)
    pub fun getIDs(): [UInt64]
    pub fun borrowNFT( id : UInt64): &NonFungibleToken.NFT
    pub fun borrowEntireNFT(id: UInt64): &NFT
}

  pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, MyCollectionPublic {
    pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

    pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
      let nft <- self.ownedNFTs.remove(key: withdrawID) 
            ?? panic("This NFT does not exist in this Collection.")
      return <- nft
    }

    pub fun deposit(token: @NonFungibleToken.NFT) {
      self.ownedNFTs[token.id] <-! token
    }

    pub fun getIDs(): [UInt64] {
      return self.ownedNFTs.keys
    }

    pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
      return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
    }

  //  pub fun borrowEntireNFT(id: UInt64): &NFT {
  //    let ref = &self.ownedNFTs[id] as auth &NonFungibleToken.NFT?
   //   return ref as! &NFT
   // }

    pub fun borrowEntireNFT(id: UInt64): &NFT {
      let ref = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
      return ref as! &NFT
    }

    init() {
      self.ownedNFTs <- {}
    }

    destroy() {
      destroy self.ownedNFTs
    }
  }

  pub fun createEmptyCollection(): @NonFungibleToken.Collection {
    return <- create Collection()
  }

  pub resource NFTMinter {

    pub fun createNFT(): @NFT {
      return <- create NFT()
    }

    init() {
    }

  }

  init() {
    self.totalSupply = 0
    emit ContractInitialized()
    self.account.save(<- create NFTMinter(), to: /storage/Minter)
  }
}
