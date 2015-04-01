NVB needs software to run -- it's not practical otherwise. 

This document tries to lay out at least one way of doing things.

# Bitcoin as host network

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

## plan of attack

So, what to do?

### client

In order to craft votes Electrum can easily be repurposed. All one needs to do is add a new tab for voting, and create a form like this:

* text-field: issue id
* vote radio: yes, no (this is really 255 or 0, but simplified because we don't vote with numbers yet, might be worth while when it comes to tax though)
* button: vote

There can be a confirmation and then the tx is broadcast. Each tx uses a single address and broadcasts a tx like this:

* input 0: some input for the right identity
* output 0: op-return contianing vote
* output 1: an output back to the identity

### administration

obviously some admin needs to be done, like starting the party, creating issues, and approving voters (and the # of votes they have). this can likewise be done through electrum and op-return txs.

### self administraion

user options like 'transfrer vote to new identity' would be useful. As long as each identity is tracked we can do pw resets (as such). also it can transfer admin rights easily too, so we can move to better multisig.

### vote resolution

How to resolve the vote, thoguh?

Well, a block explorer can be rigged to record all op_return txs that pass through (that much is easy, and I've modified abe to do so without too much issue).

those op-returns can be downloaded, filtered, and scanned for all NVB op-returns. another client then loads this list and gives resolutions for each issue that is found (and only counting voters that are valid).

in this way previous tech is easily implemented and the list of all NVB votes (invalid and valid alike) can be passed to a program with the sole purpose of figuring things out, avoididng issues of integrating it and trying to display it and stuff like that. all that can come later (see bitcoin and what it started as, etc)

### actual operations

* vote (issue) (0-255) -- (maybe better numbres? 0-100? what makes good numbers? -1, 0, 1?)
* start party (and declaire administration)
* (future) select delegate
* (future) transfer voting rights (always tracked for resets)
* create issue (admin)
* (future) modify issue (admin)
* comment (like 37 bytes)
* empower identity with votes (admin)
* (future) de-empower identity (admin)

So 5 functions needed for MVP



