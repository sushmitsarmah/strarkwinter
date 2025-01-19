#[derive(Copy, Drop, Serde)]
struct PortfolioState {
    total_value: u256,
    risk_score: RiskScore,
    last_rebalanced_timestamp: u64,
}