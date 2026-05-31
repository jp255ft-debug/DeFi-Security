module slippage_check::slippage_check;

use mmt_v3::pool::{Self, Pool};

public fun assert_slippage<T0, T1>(arg0: &mut Pool<T0, T1>, arg1: u128, arg2: bool) {
    if (arg2) {
        assert!(arg1 < pool::sqrt_price<T0, T1>(arg0), 111);
    } else {
        assert!(arg1 > pool::sqrt_price<T0, T1>(arg0), 111);
    };
}
