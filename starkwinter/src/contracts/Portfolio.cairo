#[starknet::contract]
mod Portfolio {
    use starknet::storage_access::{StorageMap, StorageVar};
    use starknet_portfolio_manager::contracts::structs::{Asset, Allocation, PortfolioState, RiskScore};
    use starknet_portfolio_manager::contracts::{AssetManager, RiskManager, Oracle, Constants};
    use starknet::get_block_timestamp;
    use starknet::ContractAddress;
    
    #[storage]
    struct Storage {
        asset_manager_address: StorageVar<ContractAddress>,
        risk_manager_address: StorageVar<ContractAddress>,
        oracle_address: StorageVar<ContractAddress>,
        portfolio_state: StorageVar<PortfolioState>,
        allocations: StorageMap<felt252, Allocation>,
    }
    
    #[event]
    #[derive(Drop, starknet::Event)]
    struct PortfolioRebalanced {
       timestamp: u64,
       risk_score: RiskScore,
       total_value: u256
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        asset_manager_address: ContractAddress,
        risk_manager_address: ContractAddress,
        oracle_address: ContractAddress,
    ) {
        self.asset_manager_address.write(asset_manager_address);
        self.risk_manager_address.write(risk_manager_address);
        self.oracle_address.write(oracle_address);

        // Initialize default values
        self.portfolio_state.write(PortfolioState{total_value: 0_u256, risk_score: RiskScore{value: 0_felt252, timestamp: 0_u64}, last_rebalanced_timestamp: 0_u64});
    }

    #[external(v0)]
    fn allocate(ref self: ContractState, asset_address: felt252, percentage: u128) {
      assert(percentage <= Constants::MAX_ALLOCATION_PERCENTAGE, 'Allocation exceeds max percentage');
        
      // Get current allocations
      let mut total_allocation: u128 = 0_u128;
      for allocation in self.allocations.values() {
          total_allocation += allocation.percentage;
      }
      assert(total_allocation + percentage <= Constants::MAX_ALLOCATION_PERCENTAGE, 'Total allocation exceeds 100%');
        
      self.allocations.insert(asset_address, Allocation{asset_address: asset_address, percentage: percentage});
    }


    #[external(v0)]
    fn rebalance(ref self: ContractState) {
      // Get current time and last rebalance time
        let current_timestamp = get_block_timestamp();
        let last_rebalance_timestamp = self.portfolio_state.read().last_rebalanced_timestamp;

      // Check if enough time has passed since the last rebalance
        assert(current_timestamp >= last_rebalance_timestamp + Constants::MIN_REBALANCE_INTERVAL, 'Minimum rebalance interval not reached');

        let total_value = self.calculate_portfolio_value();

        let risk_score = RiskManager::IRiskManagerDispatcher{contract_address: self.risk_manager_address.read()}.calculate_risk(total_value);
      
      // Re-allocation logic based on AI or any other algorithm
        self.perform_reallocation(total_value);

        // Update the portfolio state
        self.portfolio_state.write(PortfolioState{total_value: total_value, risk_score: risk_score, last_rebalanced_timestamp: current_timestamp});
        
        // emit rebalanced event
        self.emit(PortfolioRebalanced {
            timestamp: current_timestamp,
            risk_score: risk_score,
            total_value: total_value
        });
    }

    fn calculate_portfolio_value(self: @ContractState) -> u256 {
        let mut total_value: u256 = 0_u256;
      for allocation in self.allocations.values() {
          let asset_price = Oracle::IOracleDispatcher{contract_address: self.oracle_address.read()}.get_price(allocation.asset_address);
        
          //  In this example, we assume each allocated percentage represents a certain number of units of the corresponding asset
          let asset_value = (u256_from_u128(allocation.percentage) * asset_price) / 100_u256;
          total_value += asset_value;
      }
        total_value
    }

    // Placeholder for AI-driven reallocation logic
    fn perform_reallocation(ref self: ContractState, _total_value: u256) {
      // TODO: Here you should implement the AI driven reallocation logic
      // For this example, we will just rebalance to the original allocations
       
    }

    fn u256_from_u128(val: u128) -> u256 {
        u256 {
            low: val.into(),
            high: 0_u128.into()
        }
    }

    // View function to get current portfolio state
    #[view]
    fn get_portfolio_state(self: @ContractState) -> PortfolioState {
        self.portfolio_state.read()
    }
    
    #[view]
    fn get_allocations(self: @ContractState) -> StorageMap<felt252, Allocation> {
        self.allocations.read()
    }
    
    #[view]
    fn get_asset_manager_address(self: @ContractState) -> ContractAddress {
        self.asset_manager_address.read()
    }

    #[view]
    fn get_risk_manager_address(self: @ContractState) -> ContractAddress {
        self.risk_manager_address.read()
    }

    #[view]
    fn get_oracle_address(self: @ContractState) -> ContractAddress {
        self.oracle_address.read()
    }
}