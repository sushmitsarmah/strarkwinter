mod contracts {
    pub mod Portfolio;
    pub mod AssetManager;
    pub mod RiskManager;
    pub mod Oracle;
    pub mod Constants;
    
    pub mod structs {
        pub mod Asset;
        pub mod PortfolioState;
        pub mod RiskScore;
        pub mod Allocation;
    }

    pub mod interfaces {
        pub mod IAssetManager;
        pub mod IRiskManager;
        pub mod IOracle;
    }
}