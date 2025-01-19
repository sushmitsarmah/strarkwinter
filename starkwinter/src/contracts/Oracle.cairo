#[starknet::contract]
mod Oracle {
    use starknet::storage_access::StorageMap;
    use starknet_portfolio_manager::contracts::interfaces::IOracle;
    
    #[storage]
    struct Storage {
      asset_prices: StorageMap<felt252, u256>
    }

    #[external(v0)]
    impl OracleImpl of IOracle<ContractState> {
        fn get_price(self: @ContractState, asset_address: felt252) -> u256 {
          self.asset_prices.get(asset_address)
      }
    }

    // Add an internal set_price function for admins to set prices.
    #[external(v0)]
    impl AdminImpl of ContractState {
      fn set_price(ref self: ContractState, asset_address: felt252, price: u256) {
          self.asset_prices.insert(asset_address, price);
        }
    }
}