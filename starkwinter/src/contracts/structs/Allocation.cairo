#[derive(Copy, Drop, Serde)]
struct Allocation {
    asset_address: felt252,
    percentage: u128,
}