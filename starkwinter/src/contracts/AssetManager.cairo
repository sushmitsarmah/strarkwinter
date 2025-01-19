#[starknet::contract]
mod AssetManager {
    use starknet::storage_access::{StorageMap, StorageVar};
    use starknet_portfolio_manager::contracts::structs::Asset;
    use starknet_portfolio_manager::contracts::interfaces::IAssetManager;

    #[storage]
    struct Storage {
      assets: StorageMap<felt252, Asset>,
    }

    #[external(v0)]
    impl AssetManagerImpl of IAssetManager<ContractState> {
      fn add_asset(ref self: ContractState, name: felt252, address: felt252, asset_type: felt252) {
          assert(!self.assets.contains(address), 'Asset already exists');
          self.assets.insert(address, Asset {name: name, address: address, asset_type: asset_type, is_active: true});
      }

      fn remove_asset(ref self: ContractState, address: felt252) {
          assert(self.assets.contains(address), 'Asset does not exist');
          self.assets.insert(address, Asset {name: self.assets.get(address).name, address: address, asset_type: self.assets.get(address).asset_type, is_active: false});
      }

      fn get_asset(self: @ContractState, address: felt252) -> Asset {
            self.assets.get(address)
        }
    }
}