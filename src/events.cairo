// events.cairo
use starknet::ContractAddress;

#[event]
#[derive(Drop, starknet::Event)]
enum Event {
    Transfer: Transfer,
    Approval: Approval,
}

#[derive(Drop, starknet::Event)]
struct Transfer {
    sender: ContractAddress,
    recipient: ContractAddress,
    amount: felt252,
}

#[derive(Drop, starknet::Event)]
struct Approval {
    owner: ContractAddress,
    spender: ContractAddress,
    value: felt252,
}
