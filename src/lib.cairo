// TASK: Create a Counter Contract

// Stores a counter value. (storage)                              // storage, entry, events
// Increments the counter. (entry)
// Decrements the counter. (entry)
// Retrieves the current counter value.  (entry)

#[starknet::interface]
pub trait ICounter<TContractState> {
    fn increment(ref self: TContractState, number: u32) -> bool;
    fn decrement(ref self: TContractState, number: u32) -> bool;
    fn get_count(self: @TContractState) -> u32;
}

/// Simple contract for managing balance.
#[starknet::contract]
mod Counter {
    use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        count: u32,
    }

    #[constructor]
    fn constructor(ref self: ContractState, number: u32) {
        self.count.write(number);
    }

    #[abi(embed_v0)]
    impl CounterImpl of super::ICounter<ContractState> {
        fn increment(ref self: ContractState, number: u32) -> bool {
            let count = self.count.read();
            let new_count = count + number;

            self.count.write(new_count);
            return true;
        }
        
        fn decrement(ref self: ContractState, number: u32) -> bool {
            let count = self.count.read();

            if number > count {
                return false;
            }

            let new_count = count - number;

            self.count.write(new_count);
            return true;
        }

        fn get_count(self: @ContractState) -> u32 {
            let count = self.count.read();
            count
        }
    }
}