# software structure

NVB needs software to run -- it's not practical otherwise. 

This document tries to lay out at least one way of doing things.

## Bitcoin as host network

The Bitcoin blockchain can hold data in the form of OP_RETURN txs. That is useful because it provides some key qualities:

* Uncensorable
* Administrative non-dependence
* Pre-existing infrastructure

### Uncensorable

The Bitcoin network is designed to resist attempts to censor information. This is due to its 'best effort' relay property, where the default is to pass messages on to other nodes. In this way messages reach the vast majority of the network very quickly and attempts to censor them are stifled.

Additionally, the mining process ensures that all valid transactions are able to be included in a block even if this block occurs much later than the time of broadcast. This means a single miner attempting to censor particular sources will be foiled.

If votes are not uncensorable then the NVB is suseptible to corruption of the administration which is essential to avoid to ensure neutrality. Thus votes must not only remained uncensored, but be uncensorable.

### Administrative non-dependence

Basically this means one important thing: the administration cannot under any circumstances shut down the voting process (there are legal exceptions, but not technological exceptions). Both voting and the resolution of votes is largely independent from the administration (the exception is that the admin have the power to add/remove/modify issues, but not votes, thus it is far easier to replace the admin if they go bad).

### pre existing infrastructure

there's a lot of bitcoin software out there already, most notably: wallets and block explorers. modifying these is far simpler than designing a protocol by hand and implementing the server and clients.

also the network is a lot bigger than the party so is able to resist larger attacks (like not ddosing, which a website is vulnerable to)


