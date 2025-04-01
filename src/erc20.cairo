
// erc20.cairo (Main Contract)
#[starknet::contract]
mod erc_20 {
    use crate::lib::*;
    use starknet::contract_address_const;
    use starknet::get_caller_address;
    use starknet::ContractAddress;

    #[constructor]
    fn constructor(ref self: ContractState, recipient: ContractAddress, name: felt252, decimals: u8, initial_supply: felt252, symbol: felt252) {
        self.name.write(name);
        self.symbol.write(symbol);
        self.decimals.write(decimals);
        assert(!recipient.is_zero(), 'ERC20: mint to the 0 address');
        self.total_supply.write(initial_supply);
        self.balances.write(recipient, initial_supply);
        self.emit(Event::Transfer(Transfer { from: contract_address_const::<0>(), to: recipient, value: initial_supply }));
    }

    #[external(v0)]
    impl IERC20Impl of super::IERC20<ContractState> {
        fn get_name(self: @ContractState) -> felt252 { self.name.read() }
        fn get_symbol(self: @ContractState) -> felt252 { self.symbol.read() }
        fn get_decimals(self: @ContractState) -> u8 { self.decimals.read() }
        fn get_total_supply(self: @ContractState) -> felt252 { self.total_supply.read() }
        fn balance_of(self: @ContractState, account: ContractAddress) -> felt252 { self.balances.read(account) }
        fn allowance(self: @ContractState, owner: ContractAddress, spender: ContractAddress) -> felt252 { self.allowances.read((owner, spender)) }
        fn transfer(ref self: ContractState, recipient: ContractAddress, amount: felt252) {
            let sender = get_caller_address();
            self.transfer_helper(sender, recipient, amount);
        }
        fn transfer_from(ref self: ContractState, sender: ContractAddress, recipient: ContractAddress, amount: felt252) {
            let caller = get_caller_address();
            self.spend_allowance(sender, caller, amount);
            self.transfer_helper(sender, recipient, amount);
        }
        fn approve(ref self: ContractState, spender: ContractAddress, amount: felt252) {
            let caller = get_caller_address();
            self.approve_helper(caller, spender, amount);
        }
        fn increase_allowance(ref self: ContractState, spender: ContractAddress, added_value: felt252) {
            let caller = get_caller_address();
            self.approve_helper(caller, spender, self.allowances.read((caller, spender)) + added_value);
        }
        fn decrease_allowance(ref self: ContractState, spender: ContractAddress, subtracted_value: felt252) {
            let caller = get_caller_address();
            self.approve_helper(caller, spender, self.allowances.read((caller, spender)) - subtracted_value);
        }
    }
}
