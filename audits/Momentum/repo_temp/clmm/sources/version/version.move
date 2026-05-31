module mmt_v3::version;

use mmt_v3::current_version::{current_major_version, current_minor_version};
use mmt_v3::error;

public struct Version has key, store {
    id: UID,
    major_version: u64,
    minor_version: u64,
}

public struct VersionCap has key, store {
    id: UID,
}

fun init(ctx: &mut TxContext) {
    let version = Version {
        id: object::new(ctx),
        major_version: current_major_version(),
        minor_version: current_minor_version(),
    };
    let cap = VersionCap {
        id: object::new(ctx),
    };
    transfer::share_object(version);
    transfer::transfer(cap, tx_context::sender(ctx));
}

// ======= version control ==========

public fun value_major(v: &Version): u64 { v.major_version }

public fun value_minor(v: &Version): u64 { v.minor_version }

public fun upgrade_major(v: &mut Version, _: &VersionCap) {
    v.major_version = current_major_version() + 1;
}

public fun upgrade_minor(v: &mut Version, val: u64, _: &VersionCap) {
    assert!(val > v.minor_version, error::invalid_minor_version());
    v.minor_version = val;
}

public fun set_version(v: &mut Version, _: &VersionCap, major: u64, minor: u64) {
    assert!(major >= v.major_version, error::invalid_major_version());
    if (major == v.major_version) {
        assert!(minor > v.minor_version, error::invalid_minor_version());
    };
    v.major_version = major;
    v.minor_version = minor;
}

public fun is_supported_major_version(v: &Version): bool {
    v.major_version == current_major_version()
}

public fun is_supported_minor_version(v: &Version): bool {
    current_minor_version() >= v.minor_version
}

public fun assert_supported_version(v: &Version) {
    assert!(
        (is_supported_major_version(v) && is_supported_minor_version(v)),
        error::version_not_supported(),
    );
}

#[test_only]
public fun init_(ctx: &mut TxContext): Version {
    let version = Version {
        id: object::new(ctx),
        major_version: current_major_version(),
        minor_version: current_minor_version(),
    };
    let cap = VersionCap {
        id: object::new(ctx),
    };
    // transfer::share_object(version);
    transfer::transfer(cap, tx_context::sender(ctx));

    version
}

#[test_only]
public fun init_with_cap(ctx: &mut TxContext): (Version, VersionCap) {
    let version = Version {
        id: object::new(ctx),
        major_version: current_major_version(),
        minor_version: current_minor_version(),
    };
    let cap = VersionCap {
        id: object::new(ctx),
    };
    (version, cap)
}

#[allow(unused_variable)]
#[test_only]
public fun destroy_version_for_testing(version: Version) {
    let Version { id, minor_version, major_version } = version;
    object::delete(id);
}

#[test_only]
public fun destroy_version_cap_for_testing(cap: VersionCap) {
    let VersionCap { id } = cap;
    object::delete(id);
}

#[test_only]
public fun call_init_for_test(ctx: &mut TxContext) {
    init(ctx);
}
