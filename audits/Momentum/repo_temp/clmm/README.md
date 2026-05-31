# Mmt CLMM (Concentrated Liquidity Market Maker)

## Architecture

The project is organized into several key modules:

### Core Modules

- `app.move`: Main application entry points and core functionality
- `error.move`: Centralized error handling and definitions

### Storage

- `storage/pool.move`: Pool management and state
- `storage/tick.move`: Tick data structure and management
- `storage/global_config.move`: Global configuration parameters

### Utils

- `utils/bit_math.move`: Bitwise operations and calculations
- `utils/liquidity_math.move`: Liquidity-related calculations
- `utils/sqrt_price_math.move`: Square root price calculations
- `utils/swap_math.move`: Swap-related mathematics
- `utils/tick_math.move`: Tick-based calculations
- `utils/oracle.move`: Price oracle implementations

### Action Modules

#### Admin Module (`actions/admin.move`)

- Implements administrative operations and controls
- Manages protocol parameters and configurations
- Handles emergency protocol controls
- Implements access control for admin functions
- Manages protocol fee settings

#### Collect Module (`actions/collect.move`)

- Handles fee collection operations
- Manages reward distribution mechanisms
- Implements fee accounting and tracking
- Processes user fee claims

#### Create Pool Module (`actions/create_pool.move`)

- Handles pool creation and initialization
- Implements pool parameter validation
- Sets up initial pool state
- Configures pool-specific settings

#### Liquidity Module (`actions/liquidity.move`)

- Manages liquidity provision operations
- Handles position creation and modification
- Implements liquidity range calculations
- Processes liquidity addition and removal

#### Trade Module (`actions/trade.move`)

- Implements core swap functionality
- Handles trade execution and routing
- Manages slippage and price impact
- Implements trade path optimization
- Handles multi-hop trades

### Integer Mathematics Modules

#### Basic Integer Math Modules

- `integer-mate/math_u64.move`: Basic unsigned 64-bit integer operations
- `integer-mate/math_u128.move`: Basic unsigned 128-bit integer operations
- `integer-mate/math_u256.move`: Basic unsigned 256-bit integer operations

#### Full Math Modules

- `integer-mate/full_math_u64.move`: Extended unsigned 64-bit integer operations
- `integer-mate/full_math_u128.move`: Extended unsigned 128-bit integer operations

#### Signed Integer Modules

- `integer-mate/i32.move`: Signed 32-bit integer implementation and operations
- `integer-mate/i64.move`: Signed 64-bit integer implementation and operations
- `integer-mate/i128.move`: Signed 128-bit integer implementation and operations

Each signed integer module includes:

- Basic arithmetic operations
- Comparison operations
- Conversion functions
- Overflow checking
- Advanced mathematical operations

### Version Management

#### Current Version Module (`version/current_version.move`)

- Tracks current protocol version
- Manages version compatibility
- Provides version checking utilities

#### Version Module (`version/version.move`)

- Implements version control system
- Manages protocol upgrades
- Handles version transitions
- Implements version compatibility checks

### Testing

- `tests/`: Comprehensive test suite for all components

## Detailed Module Explanations

### Core Modules

#### App Module (`app.move`)

- Core application management and initialization
- Handles administrative capabilities and access control
- Manages protocol administrators and permissions
- Provides initialization logic for the protocol
- Contains critical security checks and administrative functions

#### Error Module (`error.move`)

- Centralized error handling system
- Defines standardized error codes and messages
- Ensures consistent error reporting across the protocol
- Helps with debugging and error tracking

### Storage Modules

#### Pool Module (`storage/pool.move`)

- Manages liquidity pool creation and configuration
- Handles pool state and parameters
- Implements pool-specific calculations and logic
- Manages token pair relationships and pool settings
- Tracks pool metrics and statistics

#### Tick Module (`storage/tick.move`)

- Implements concentrated liquidity tick system
- Manages price range boundaries and tick spacing
- Handles tick-based liquidity distribution
- Tracks fee accumulation per tick
- Implements tick crossing and price movement logic

#### Global Config Module (`storage/global_config.move`)

- Manages protocol-wide configuration parameters
- Handles fee tier settings and protocol constants
- Controls protocol upgrades and parameter updates
- Stores global protocol state

### Utility Modules

#### Bit Math Module (`utils/bit_math.move`)

- Implements efficient bitwise operations
- Provides optimized mathematical calculations
- Handles binary operations for price and tick calculations
- Supports other modules with mathematical utilities

#### Liquidity Math Module (`utils/liquidity_math.move`)

- Implements core liquidity calculations
- Handles liquidity addition and removal logic
- Calculates liquidity depths and distributions
- Provides mathematical functions for position management

#### Square Root Price Math Module (`utils/sqrt_price_math.move`)

- Implements precise square root price calculations
- Handles price-to-sqrt-price conversions
- Provides mathematical functions for price manipulation
- Ensures price accuracy and precision

#### Swap Math Module (`utils/swap_math.move`)

- Implements core swap calculations
- Handles price impact calculations
- Manages slippage control and limitations
- Calculates optimal swap paths and amounts

#### Tick Math Module (`utils/tick_math.move`)

- Provides mathematical functions for tick manipulation
- Handles tick-to-price conversions
- Implements tick spacing and range calculations
- Ensures tick boundary compliance

#### Oracle Module (`utils/oracle.move`)

- Implements price oracle functionality
- Manages time-weighted average prices (TWAP)
- Provides external price feed integration
- Handles oracle updates and calculations
