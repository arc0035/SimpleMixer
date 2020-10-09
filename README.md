# What
Naive Mixer. Just a toy, never use it. 

# Why
I write this toy just to understand what a real mixer(like micro mixer) should be.

# How
This is a distributed mixer using hash as proof. It submits a hash on depositing , then reveal the raw value on mixing.  

# Buggy

Why it's buggy mainly because:

- It omits the signature process so middle-man(like miners) may change the receiver address
- The observers can INTER the relationship between the sender and receiver!!! For example, Alice submits some commitment 1, then relayer submits the raw value
2 (Suppose hash(2) == 1) when mixing to Bob. Observers can find that commitment 1 is consumed on mixing to Bob, and verifies that hash(2) == 1. So obviously Alice is transfering to Bob. No mix at all.


