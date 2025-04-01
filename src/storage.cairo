// storage.cairo
use starknet::ContractAddress;
use starknet::storage::Map;


#[storage]
struct Storage {
    name: felt252,
    symbol: felt252,
    decimals: u8,
    total_supply: felt252,
    balances: Map::<ContractAddress, felt252>,
    allowances: Map::<(ContractAddress, ContractAddress), felt252>,
}