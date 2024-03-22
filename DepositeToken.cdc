import CryptoPoops from 0x06
import NonFungibleToken from 0x05

transaction(recipient: Address) {

  prepare(acct: AuthAccount) {
      let nftMinter = acct.borrow<&CryptoPoops.NFTMinter>(from: /storage/Minter)!

       let publicReference = getAccount(recipient).getCapability(/public/Collection)
                    .borrow<&CryptoPoops.Collection{NonFungibleToken.CollectionPublic}>()
                    ?? panic("This acc does not have collection") 

        publicReference.deposit(token: <- nftMinter.createNFT())
    }

    execute {
    log("Stored new NFT")
    }
}
