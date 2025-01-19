#[derive(Copy, Drop, Serde)]
struct RiskScore {
    value: felt252,
    timestamp: u64,
}