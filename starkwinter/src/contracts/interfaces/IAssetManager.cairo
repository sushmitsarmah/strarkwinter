#[starknet::interface]
trait IAssetManager<TContractState> {
    fn add_asset(ref self: TContractState, name: felt252, address: felt252, asset_type: felt252);
    fn remove_asset(ref self: TContractState, address: felt252);
    fn get_asset(self: @TContractState, address: felt252) -> Asset;
}