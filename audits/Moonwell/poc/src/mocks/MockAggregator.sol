// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * @title AggregatorV3Interface
 * @notice Interface mínima do Chainlink AggregatorV3Interface
 */
interface AggregatorV3Interface {
    function decimals() external view returns (uint8);
    function description() external view returns (string memory);
    function version() external view returns (uint256);
    function getRoundData(uint80 _roundId)
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
    function latestRound() external view returns (uint256);
}

/**
 * @title MockAggregator
 * @notice Mock de um feed Chainlink que retorna preço stale (updatedAt = 0)
 */
contract MockAggregator is AggregatorV3Interface {
    int256 private _price;
    uint8 private _decimals;
    bool public isStale;
    
    constructor(int256 price_, uint8 decimals_, bool stale_) {
        _price = price_;
        _decimals = decimals_;
        isStale = stale_;
    }
    
    function decimals() external view override returns (uint8) {
        return _decimals;
    }
    
    function description() external pure override returns (string memory) {
        return "Mock Feed";
    }
    
    function version() external pure override returns (uint256) {
        return 1;
    }
    
    function getRoundData(uint80)
        external
        view
        override
        returns (uint80, int256, uint256, uint256, uint80)
    {
        if (isStale) {
            return (1, _price, 0, 0, 1);
        }
        return (1, _price, block.timestamp, block.timestamp, 1);
    }
    
    function latestRoundData()
        external
        view
        override
        returns (uint80, int256, uint256, uint256, uint80)
    {
        if (isStale) {
            return (1, _price, 0, 0, 1);
        }
        return (1, _price, block.timestamp, block.timestamp, 1);
    }
    
    function latestRound() external pure override returns (uint256) {
        return 1;
    }
    
    function setStale(bool stale_) external {
        isStale = stale_;
    }
}
