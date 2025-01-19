#[starknet::interface]
trait IRiskManager<TContractState> {
    fn calculate_risk(ref self: TContractState, portfolio_value: u256) -> RiskScore;
}