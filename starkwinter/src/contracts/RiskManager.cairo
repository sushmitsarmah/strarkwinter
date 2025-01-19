#[starknet::contract]
mod RiskManager {
    use starknet::storage_access::StorageVar;
    use starknet_portfolio_manager::contracts::structs::RiskScore;
    use starknet_portfolio_manager::contracts::interfaces::IRiskManager;
    use starknet::get_block_timestamp;
    
    #[storage]
    struct Storage {
        last_risk_score: StorageVar<RiskScore>
    }

    #[external(v0)]
    impl RiskManagerImpl of IRiskManager<ContractState> {
        fn calculate_risk(ref self: ContractState, portfolio_value: u256) -> RiskScore {
            // Replace this with your actual AI Risk calculation logic
            // Here is a basic example of risk calc based on portfolio value.
            let risk = felt252_from_int(portfolio_value.low);
            let timestamp = get_block_timestamp();
            let risk_score = RiskScore {value: risk, timestamp: timestamp};
            self.last_risk_score.write(risk_score);
            risk_score
        }
    }

    fn felt252_from_int(val: u128) -> felt252 {
        felt252 {
            low: val.into(),
            high: 0_u128.into()
        }
    }
}