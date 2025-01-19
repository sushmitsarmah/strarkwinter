#[derive(Copy, Drop, Serde)]
struct Asset {
    name: felt252,
    address: felt252,
    asset_type: felt252,
    is_active: bool,
}