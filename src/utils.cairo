// utils.cairo
use starknet::get_caller_address;
use starknet::ContractAddress;
use starknet::storage::{StorageMapReadAccess, StorageMapWriteAccess};
use core::num::traits::Zero;
use starknet::event::EventEmitter;
use starknet::ContractState;
use super::events::{Event, Transfer, Approval};

#[generate_trait]
trait StorageTrait {
    fn transfer_helper(ref self: ContractState, sender: ContractAddress, recipient: ContractAddress, amount: felt252);
    fn approve_helper(ref self: ContractState, owner: ContractAddress, spender: ContractAddress, amount: felt252);
}

impl StorageImpl of StorageTrait {
    fn transfer_helper(ref self: ContractState, sender: ContractAddress, recipient: ContractAddress, amount: felt252) {
        assert(!sender.is_zero(), 'ERC20: transfer from 0');
        assert(!recipient.is_zero(), 'ERC20: transfer to 0');
        self.balances.write(sender, self.balances.read(sender) - amount);
        self.balances.write(recipient, self.balances.read(recipient) + amount);
        self.emit(Event::Transfer(Transfer { sender, recipient, amount }));
    }

    fn approve_helper(ref self: ContractState, owner: ContractAddress, spender: ContractAddress, amount: felt252) {
        assert(!spender.is_zero(), 'ERC20: approve from 0');
        self.allowances.write((owner, spender), amount);
        self.emit(Event::Approval(Approval { owner, spender, value: amount }));
    }
}
