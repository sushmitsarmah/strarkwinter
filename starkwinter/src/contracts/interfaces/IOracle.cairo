#[starknet::interface]
trait IOracle<TContractState> {
    fn get_price(self: @TContractState, asset_address: felt252) -> u256;
}